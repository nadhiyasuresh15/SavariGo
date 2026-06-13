import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../constants/app_colors.dart';

class BookRideScreen extends StatefulWidget {
  const BookRideScreen({super.key});

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _dropController = TextEditingController();

  LatLng? _pickupLatLng;
  LatLng? _dropLatLng;

  String _pickupText = 'Tap Locate Me';
  String _dropText = 'Enter destination';
  bool _loadingLocation = false;
  bool _searching = false;
  bool _womenOnly = false;
  int _seats = 1;

  final LatLng _chennaiCenter = const LatLng(13.0827, 80.2707);

  final List<Map<String, dynamic>> _recentPlaces = [
    {
      'name': 'Poonamallee Bus Stand',
      'address': 'Poonamallee, Chennai, Tamil Nadu',
      'lat': 13.0473,
      'lng': 80.0945,
    },
    {
      'name': 'Saveetha Medical College',
      'address': 'Saveetha Nagar, Thandalam, Chennai',
      'lat': 13.0285,
      'lng': 80.0169,
    },
    {
      'name': 'GRT Jewellers - Poonamallee',
      'address': 'Poonamallee High Road, Chennai',
      'lat': 13.0478,
      'lng': 80.0962,
    },
    {
      'name': 'EVP Carnival Cinemas',
      'address': 'Chembarambakkam, Chennai',
      'lat': 13.0345,
      'lng': 80.0737,
    },
    {
      'name': 'Guindy',
      'address': 'Guindy, Chennai, Tamil Nadu',
      'lat': 13.0108,
      'lng': 80.2206,
    },
    {
      'name': 'Tambaram',
      'address': 'Tambaram, Chennai, Tamil Nadu',
      'lat': 12.9249,
      'lng': 80.1000,
    },
    {
      'name': 'T Nagar',
      'address': 'T Nagar, Chennai, Tamil Nadu',
      'lat': 13.0418,
      'lng': 80.2341,
    },
    {
      'name': 'Anna Nagar',
      'address': 'Anna Nagar, Chennai, Tamil Nadu',
      'lat': 13.0850,
      'lng': 80.2101,
    },
    {
      'name': 'Vadapalani',
      'address': 'Vadapalani, Chennai, Tamil Nadu',
      'lat': 13.0524,
      'lng': 80.2122,
    },
    {
      'name': 'Porur',
      'address': 'Porur, Chennai, Tamil Nadu',
      'lat': 13.0382,
      'lng': 80.1565,
    },
  ];

  List<Map<String, dynamic>> _searchResults = [];

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
  }

  Future<void> _locateMe() async {
    setState(() {
      _loadingLocation = true;
      _pickupText = 'Getting your current location...';
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          _pickupText = 'Location service is OFF. Using Chennai default';
          _pickupLatLng = _chennaiCenter;
          _loadingLocation = false;
        });
        _mapController.move(_chennaiCenter, 13);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _pickupText = 'Permission denied. Using Chennai default location';
          _pickupLatLng = _chennaiCenter;
          _loadingLocation = false;
        });
        _mapController.move(_chennaiCenter, 13);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userPoint = LatLng(position.latitude, position.longitude);

      setState(() {
        _pickupLatLng = userPoint;
        _pickupText =
            'My Current Location (${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)})';
        _loadingLocation = false;
      });

      _mapController.move(userPoint, 14);
    } catch (e) {
      setState(() {
        _pickupText = 'Unable to get location. Using Chennai default';
        _pickupLatLng = _chennaiCenter;
        _loadingLocation = false;
      });
      _mapController.move(_chennaiCenter, 13);
    }
  }

  Future<void> _searchDropLocation(String query) async {
    if (query.trim().length < 3) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searching = true;
    });

    try {
      final encodedQuery = Uri.encodeComponent('$query Chennai Tamil Nadu');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=6&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'SavariGo Flutter Web Project',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          _searchResults = data.map<Map<String, dynamic>>((item) {
            final displayName = item['display_name'] ?? '';
            return {
              'name': item['name'] ??
                  displayName.toString().split(',').first,
              'address': displayName,
              'lat': double.parse(item['lat']),
              'lng': double.parse(item['lon']),
            };
          }).toList();
          _searching = false;
        });
      } else {
        setState(() {
          _searching = false;
        });
      }
    } catch (e) {
      setState(() {
        _searching = false;
      });
    }
  }

  void _selectDropPlace(Map<String, dynamic> place) {
    final point = LatLng(place['lat'], place['lng']);

    setState(() {
      _dropLatLng = point;
      _dropText = place['name'];
      _dropController.text = place['name'];
      _searchResults = [];
    });

    _mapController.move(point, 14);
  }

  void _findAIMatch() {
    if (_pickupLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tap Locate Me for pickup')),
      );
      return;
    }

    if (_dropLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search and select drop location')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/passenger/ai-match',
      arguments: {
        'pickup': _pickupText,
        'drop': _dropText,
        'seats': _seats,
        'womenOnly': _womenOnly,
        'pickupLat': _pickupLatLng!.latitude,
        'pickupLng': _pickupLatLng!.longitude,
        'dropLat': _dropLatLng!.latitude,
        'dropLng': _dropLatLng!.longitude,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      if (_pickupLatLng != null)
        Marker(
          point: _pickupLatLng!,
          width: 100,
          height: 80,
          child: _mapMarker(
            icon: Icons.my_location,
            color: Colors.green,
            label: 'Pickup',
          ),
        ),
      if (_dropLatLng != null)
        Marker(
          point: _dropLatLng!,
          width: 100,
          height: 80,
          child: _mapMarker(
            icon: Icons.flag,
            color: Colors.red,
            label: 'Drop',
          ),
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Shared Auto 🚕'),
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _locationBox(),
                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '📍 Pickup Location',
                      style: TextStyle(
                        color: Colors.pink.shade600,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loadingLocation ? null : _locateMe,
                      icon: _loadingLocation
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(
                        _loadingLocation ? 'Locating...' : 'Locate Me',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.black,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '🎯 Drop Location',
                      style: TextStyle(
                        color: Colors.pink.shade600,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _dropController,
                    onChanged: _searchDropLocation,
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _dropController.clear();
                                setState(() {
                                  _searchResults = [];
                                  _dropLatLng = null;
                                  _dropText = 'Enter destination';
                                });
                              },
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (_searchResults.isNotEmpty)
                    _placesList(_searchResults)
                  else
                    _placesList(_recentPlaces),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Seats Required',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [1, 2, 3].map((seat) {
                      final selected = _seats == seat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(
                            '$seat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  selected ? AppColors.black : Colors.black87,
                            ),
                          ),
                          selected: selected,
                          selectedColor: AppColors.yellow,
                          onSelected: (_) {
                            setState(() {
                              _seats = seat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    value: _womenOnly,
                    onChanged: (value) {
                      setState(() {
                        _womenOnly = value;
                      });
                    },
                    title: const Text(
                      '👩 Women-Only Mode',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    activeColor: AppColors.yellow,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pickupLatLng != null && _dropLatLng != null
                          ? _findAIMatch
                          : null,
                      icon: const Icon(Icons.smart_toy),
                      label: const Text('Find AI Pool Match 🤖'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.black,
                        disabledBackgroundColor: Colors.grey.shade300,
                        minimumSize: const Size(double.infinity, 52),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 18, 18, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              clipBehavior: Clip.antiAlias,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _chennaiCenter,
                  initialZoom: 11.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.savarigo.app',
                  ),
                  if (_pickupLatLng != null && _dropLatLng != null)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [_pickupLatLng!, _dropLatLng!],
                          strokeWidth: 5,
                          color: AppColors.yellow,
                        ),
                      ],
                    ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 6, backgroundColor: Colors.green),
              const SizedBox(width: 12),
              const Text(
                'Pickup:',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _pickupText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const CircleAvatar(radius: 6, backgroundColor: Colors.red),
              const SizedBox(width: 12),
              const Text(
                'Drop:',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _dropText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placesList(List<Map<String, dynamic>> places) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: places.map((place) {
          return ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text(
              place['name'],
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              place['address'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.add),
            onTap: () => _selectDropPlace(place),
          );
        }).toList(),
      ),
    );
  }

  Widget _mapMarker({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5),
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
}