import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/safety_button.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  int _stage = 0;
  Timer? _timer;

  LatLng? _userLocation;
  bool _locationLoading = true;
  String _locationMessage = 'Getting your current location...';

  LatLng _pickup = const LatLng(12.9249, 80.1000); // Tambaram fallback
  LatLng _driver = const LatLng(12.9249, 80.1000); // fallback to pickup
  LatLng _drop = const LatLng(13.0108, 80.2206); // Guindy fallback
  String _pickupLabel = 'Your Current Location';
  String _dropLabel = 'Drop Location';
  String _rideDriverName = 'Ravi Auto';
  bool _routeInitialized = false;

  double? _doubleValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString());
  }

  LatLng _computeDriverLocation(LatLng pickup, LatLng drop) {
    return LatLng(
      pickup.latitude + (drop.latitude - pickup.latitude) * 0.18,
      pickup.longitude + (drop.longitude - pickup.longitude) * 0.18,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_routeInitialized) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      final pickupLat = _doubleValue(args['pickupLat']);
      final pickupLng = _doubleValue(args['pickupLng']);
      final dropLat = _doubleValue(args['dropLat']);
      final dropLng = _doubleValue(args['dropLng']);

      if (pickupLat != null && pickupLng != null) {
        _pickup = LatLng(pickupLat, pickupLng);
      }
      if (dropLat != null && dropLng != null) {
        _drop = LatLng(dropLat, dropLng);
      }

      if (args['pickup'] is String) {
        _pickupLabel = args['pickup'] as String;
      }
      if (args['drop'] is String) {
        _dropLabel = args['drop'] as String;
      }

      if (args['driver'] is Map) {
        _rideDriverName =
            (args['driver'] as Map)['name']?.toString() ?? _rideDriverName;
      }

      _driver = _computeDriverLocation(_pickup, _drop);
    }

    _routeInitialized = true;
  }

  static const List<String> _stages = [
    'Driver is on the way...',
    'Driver arrived at pickup! 📍',
    'Ride in progress... 🚖',
    'Ride Completed! 🎉',
  ];

  static const List<String> _icons = [
    '🔍',
    '📍',
    '🚖',
    '✅',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      if (_stage < _stages.length - 1) {
        setState(() {
          _stage++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          _locationLoading = false;
          _locationMessage = 'Location service is OFF. Showing default pickup.';
          _userLocation = _pickup;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationLoading = false;
          _locationMessage =
              'Location permission denied. Showing default pickup.';
          _userLocation = _pickup;
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _locationLoading = false;
        _locationMessage =
            'Your Location: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      setState(() {
        _locationLoading = false;
        _locationMessage = 'Unable to fetch GPS. Showing default pickup.';
        _userLocation = _pickup;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showPaymentDialog() {
    String selectedPayment = 'UPI';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Complete Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Amount to Pay: ₹45',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    title: const Text('UPI Payment'),
                    value: 'UPI',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPayment = value ?? 'UPI';
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Card Payment'),
                    value: 'Card',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPayment = value ?? 'Card';
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Cash to Driver'),
                    value: 'Cash',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPayment = value ?? 'Cash';
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showPaymentSuccess(selectedPayment);
                  },
                  child: const Text('Pay Now'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPaymentSuccess(String method) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful 🎉'),
        content: Text(
          'Payment of ₹45 completed using $method.\n\nTransaction ID: SG${DateTime.now().millisecondsSinceEpoch}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.feedback);
            },
            child: const Text('Give Feedback'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng currentCenter = _userLocation ?? _pickup;

    final List<Marker> markers = [
      Marker(
        point: currentCenter,
        width: 90,
        height: 80,
        child: _mapMarker(
          icon: Icons.my_location,
          color: Colors.blue,
          label: 'You',
        ),
      ),
      Marker(
        point: _pickup,
        width: 100,
        height: 80,
        child: _mapMarker(
          icon: Icons.location_on,
          color: AppColors.green,
          label: 'Pickup',
        ),
      ),
      Marker(
        point: _driver,
        width: 110,
        height: 80,
        child: _mapMarker(
          icon: Icons.local_taxi,
          color: AppColors.yellow,
          label: 'Driver',
          iconColor: AppColors.black,
        ),
      ),
      Marker(
        point: _drop,
        width: 100,
        height: 80,
        child: _mapMarker(
          icon: Icons.flag,
          color: AppColors.red,
          label: 'Drop',
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Ride Tracking'),
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: currentCenter,
                    initialZoom: 12.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.savarigo.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [_pickup, _driver, _drop],
                          strokeWidth: 5,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⏱️ ETA: 8 min',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: SafetySOSButton(
                    small: true,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.safety);
                    },
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _locationLoading
                          ? '📍 Getting current location...'
                          : '📍 $_locationMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${_icons[_stage]} ${_stages[_stage]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _stages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _stage ? 26 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: index <= _stage
                                ? AppColors.yellow
                                : AppColors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 23,
                            backgroundColor: AppColors.yellow,
                            child: Text(
                              'R',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_rideDriverName ⭐ 4.9',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'TN-01-AB-1234 · Verified Driver',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Pickup: $_pickupLabel → Drop: $_dropLabel',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: AppColors.yellow.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'OTP\n4521',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _infoBox('Fare', '₹45', Colors.blue.shade100),
                        const SizedBox(width: 10),
                        _infoBox('Trust Score', '92%', Colors.green.shade100),
                        const SizedBox(width: 10),
                        _infoBox('Seats', '3/4', Colors.orange.shade100),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.safety);
                            },
                            icon: const Icon(
                              Icons.warning_rounded,
                              color: AppColors.red,
                            ),
                            label: const Text(
                              'SOS',
                              style: TextStyle(color: AppColors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.red),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showPaymentDialog,
                            icon: const Icon(Icons.payment),
                            label: const Text('Pay'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapMarker({
    required IconData icon,
    required Color color,
    required String label,
    Color iconColor = Colors.white,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
