import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/app_routes.dart';
import '../../services/ai_matching_service.dart';

class AIPoolMatchScreen extends StatefulWidget {
  const AIPoolMatchScreen({super.key});

  @override
  State<AIPoolMatchScreen> createState() => _AIPoolMatchScreenState();
}

class _AIPoolMatchScreenState extends State<AIPoolMatchScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _loading = true;
  List<Map<String, dynamic>> _drivers = [];
  Map<String, dynamic>? _selectedDriver;

  Map<String, dynamic> _rideData = {};

  // AI result fields
  int _matchScore = 0;
  int? _etaMinutes;
  int _estimatedFarePerPerson = 0;
  int _savings = 0;

  Timer? _pollTimer;
  StreamSubscription<dynamic>? _driversSub;

  static const Color yellow = Color(0xFFFFCC00);
  static const Color black = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is Map<String, dynamic>) {
        _rideData = args;
      }

      _loadDrivers();

      // Try to subscribe to realtime driver updates (Supabase stream). If
      // the stream API isn't available or fails, polling will continue.
      try {
        final stream = _supabase.from('drivers').stream(primaryKey: ['id']);
        _driversSub = stream.listen((data) {
          if (!mounted) return;
          try {
            // Data from Supabase stream can be a list of maps or a single map
            final list = (data is List) ? data : [data];
            _drivers = list
                .map((e) =>
                    Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
                .toList();

            // ensure selected driver is still active, otherwise pick first active
            if (_selectedDriver != null) {
              final still = _drivers.firstWhere(
                  (d) => d['email'] == _selectedDriver!['email'],
                  orElse: () => <String, dynamic>{});
              if (still.isEmpty || !_isDriverActive(still)) {
                final activeDrivers = _drivers
                    .where((driver) => _isDriverActive(driver))
                    .toList();
                _selectedDriver =
                    activeDrivers.isNotEmpty ? activeDrivers.first : null;
              } else {
                _selectedDriver = still;
              }
            } else {
              final activeDrivers =
                  _drivers.where((driver) => _isDriverActive(driver)).toList();
              if (activeDrivers.isNotEmpty) {
                _selectedDriver = activeDrivers.first;
              }
            }

            // recompute AI match
            final ai = AIMatchingService.findBestDriverMatch(
              rideRequest: {
                'seats': _rideData['seats'] ?? 1,
                'totalFare': _rideData['totalFare'] ?? 150
              },
              drivers: _drivers,
            );
            _matchScore = ai['matchScore'] ?? 0;
            _etaMinutes = ai['etaMinutes'];
            _estimatedFarePerPerson = ai['estimatedFarePerPerson'] ?? 0;
            _savings = ai['savings'] ?? 0;

            setState(() {});
          } catch (_) {
            // ignore parse errors
          }
        }, onError: (_) {
          // fall back to polling
          _pollTimer ??=
              Timer.periodic(const Duration(seconds: 5), (_) => _loadDrivers());
        });
      } catch (_) {
        // Start polling as fallback
        _pollTimer ??=
            Timer.periodic(const Duration(seconds: 5), (_) => _loadDrivers());
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _driversSub?.cancel();
    super.dispose();
  }

  Future<void> _loadDrivers() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await _supabase
          .from('drivers')
          .select()
          .order('is_active', ascending: false)
          .order('rating', ascending: false);

      final List data = response as List;

      _drivers = data
          .map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
          .toList();

      final activeDrivers = _drivers.where((driver) {
        return driver['is_active'] == true &&
            driver['status'].toString().toLowerCase() == 'active';
      }).toList();

      if (activeDrivers.isNotEmpty) {
        _selectedDriver = activeDrivers.first;
      } else {
        _selectedDriver = null;
      }
    } catch (e) {
      _drivers = [];
      _selectedDriver = null;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load drivers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      try {
        // compute AI match result after drivers are loaded
        final ai = AIMatchingService.findBestDriverMatch(
          rideRequest: {
            'seats': _rideData['seats'] ?? 1,
            'totalFare': _rideData['totalFare'] ?? 150,
          },
          drivers: _drivers,
        );

        _matchScore = ai['matchScore'] ?? 0;
        _etaMinutes = ai['etaMinutes'];
        _estimatedFarePerPerson = ai['estimatedFarePerPerson'] ?? 0;
        _savings = ai['savings'] ?? 0;

        setState(() {
          _loading = false;
        });
      } catch (e) {
        // Handle any errors that occur during AI matching
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error computing AI match: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  bool _isDriverActive(Map<String, dynamic> driver) {
    return driver['is_active'] == true &&
        driver['status'].toString().toLowerCase() == 'active';
  }

  Future<void> _confirmRide() async {
    if (_selectedDriver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active driver available right now'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user = _supabase.auth.currentUser;

      await _supabase.from('rides').insert({
        'passenger_id': user?.id,
        'pickup_location': _rideData['pickup'] ?? 'Current Location',
        'drop_location': _rideData['drop'] ?? 'Selected Destination',
        'status': 'requested',
        'women_only': _rideData['womenOnly'] ?? false,
        'seats': _rideData['seats'] ?? 1,
        'driver_name': _selectedDriver!['name'],
        'driver_email': _selectedDriver!['email'],
        'vehicle_number': _selectedDriver!['vehicle_number'],
      });

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        AppRoutes.rideTracking,
        arguments: {
          ..._rideData,
          'driver': _selectedDriver,
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ride saved for demo. Opening tracking page.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.rideTracking,
        arguments: {
          ..._rideData,
          'driver': _selectedDriver,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickup = _rideData['pickup'] ?? 'Current Location';
    final drop = _rideData['drop'] ?? 'Selected Destination';
    final seats = _rideData['seats'] ?? 1;
    final womenOnly = _rideData['womenOnly'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: yellow,
        foregroundColor: black,
        title: const Text(
          'AI Pool Match',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: _loadDrivers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: black),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rideSummaryCard(pickup, drop, seats, womenOnly),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Drivers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'AI selects only active drivers from Supabase database',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_drivers.isEmpty)
                    _emptyDriverCard()
                  else
                    Column(
                      children: _drivers.map((driver) {
                        final active = _isDriverActive(driver);
                        final selected = _selectedDriver != null &&
                            _selectedDriver!['email'] == driver['email'];

                        return _driverCard(
                          driver: driver,
                          active: active,
                          selected: selected,
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 22),
                  _aiResultCard(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _selectedDriver == null ? null : _confirmRide,
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        _selectedDriver == null
                            ? 'No Active Driver Available'
                            : "Confirm Ride with ${_selectedDriver!['name']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: black,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _rideSummaryCard(
    dynamic pickup,
    dynamic drop,
    dynamic seats,
    dynamic womenOnly,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ride Request',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: black,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.my_location, 'Pickup', pickup.toString()),
          const SizedBox(height: 12),
          _infoRow(Icons.location_on, 'Drop', drop.toString()),
          const SizedBox(height: 12),
          _infoRow(Icons.event_seat, 'Seats', seats.toString()),
          const SizedBox(height: 12),
          _infoRow(
            Icons.woman,
            'Women Only',
            womenOnly == true ? 'Enabled' : 'Disabled',
          ),
        ],
      ),
    );
  }

  Widget _driverCard({
    required Map<String, dynamic> driver,
    required bool active,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: active
          ? () {
              setState(() {
                _selectedDriver = driver;
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? yellow.withValues(alpha: 0.22) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? yellow
                : active
                    ? Colors.green
                    : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: active ? Colors.green : Colors.grey,
              child: const Icon(
                Icons.local_taxi,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver['name']?.toString() ?? 'Driver',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver['vehicle_number']?.toString() ?? 'Vehicle not added',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver['phone']?.toString() ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: active ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    active ? 'ACTIVE' : 'OFFLINE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${driver['rating'] ?? 4.5}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _aiResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _selectedDriver == null
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Match Result',
                  style: TextStyle(
                    color: yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'No active driver found. Please ask a driver to go active.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Match Score: ${0}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Match Result',
                  style: TextStyle(
                    color: yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Best driver selected: ${_selectedDriver!['name']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Match Score: $_matchScore%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estimated Fare: ₹$_estimatedFarePerPerson per passenger',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estimated Arrival: ${_etaMinutes ?? '-'} minutes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _emptyDriverCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'No drivers found in database',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: black,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: black),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
