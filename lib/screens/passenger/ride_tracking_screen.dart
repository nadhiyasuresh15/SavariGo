import 'dart:async';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Web Map Demo UI
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapGridPainter(),
                    ),
                  ),

                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RoutePainter(),
                    ),
                  ),

                  // Pickup
                  Positioned(
                    left: 45,
                    bottom: 70,
                    child: _mapPin(
                      title: 'Pickup',
                      place: 'Tambaram',
                      color: AppColors.green,
                      icon: Icons.location_on,
                    ),
                  ),

                  // Driver
                  AnimatedPositioned(
                    duration: const Duration(seconds: 2),
                    left: _stage < 2 ? 150 : 230,
                    top: _stage < 2 ? 150 : 95,
                    child: _driverPin(),
                  ),

                  // Drop
                  Positioned(
                    right: 50,
                    top: 55,
                    child: _mapPin(
                      title: 'Drop',
                      place: 'Guindy',
                      color: AppColors.red,
                      icon: Icons.flag,
                    ),
                  ),

                  // ETA chip
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.78),
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

                  // SOS button
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

                  // Web demo label
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Simulated Web Map View · Future: Google Maps Live GPS',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Status Card
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${_icons[_stage]} ${_stages[_stage]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Progress dots
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

                  const SizedBox(height: 16),

                  // Driver details
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
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

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ravi Auto ⭐ 4.9',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'TN-01-AB-1234 · Verified Driver',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Pickup: Tambaram  →  Drop: Guindy',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.yellow.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'OTP\n4521',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _infoBox('Fare', '₹45', Colors.blue.shade100),
                      const SizedBox(width: 10),
                      _infoBox('Trust Score', '92%', Colors.green.shade100),
                      const SizedBox(width: 10),
                      _infoBox('Seats', '3/4', Colors.orange.shade100),
                    ],
                  ),

                  const Spacer(),

                  if (_stage == _stages.length - 1)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.feedback);
                      },
                      icon: const Icon(Icons.star),
                      label: const Text('Rate Your Ride'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.black,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                            label: const Text('Share Ride'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 46),
                            ),
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
                              minimumSize: const Size(double.infinity, 46),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin({
    required String title,
    required String place,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            '$title\n$place',
            textAlign: TextAlign.center,
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

  Widget _driverPin() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.yellow,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_taxi,
            color: AppColors.black,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Driver\nRavi Auto',
            textAlign: TextAlign.center,
            style: TextStyle(
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
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

// Fake map grid painter for web demo
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD0DDD0)
      ..strokeWidth = 0.7;

    for (double x = 0; x < size.width; x += 45) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += 45) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final road1 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.55,
        size.width * 0.95,
        size.height * 0.18,
      );

    final road2 = Path()
      ..moveTo(size.width * 0.10, size.height * 0.25)
      ..lineTo(size.width * 0.90, size.height * 0.85);

    canvas.drawPath(road1, roadPaint);
    canvas.drawPath(road2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Yellow route painter
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.yellow
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.55,
        size.width * 0.88,
        size.height * 0.22,
      );

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}