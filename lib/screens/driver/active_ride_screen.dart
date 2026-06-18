// screens/driver/active_ride_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});
  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  int _stage = 0; // 0=accepted, 1=picked_up, 2=completed
  static const _stages = ['Drive to Pickup 📍', 'Ride in Progress 🚖', 'Ride Completed! 🎉'];
  static const _btns   = ['Passenger Picked Up ✅', 'Complete Ride 🏁', 'Done'];

  void _next() {
    if (_stage < 1) { setState(() => _stage++); return; }
    if (_stage == 1) {
      setState(() => _stage++);
      showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
        title: const Text('Ride Completed! 🎉'),
        content: const Text('Great job!\nFare collected: ₹60\n+10 Green Points awarded to passenger.'),
        actions: [TextButton(
          onPressed: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, AppRoutes.driverDashboard); },
          child: const Text('Back to Dashboard'),
        )],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        // Fake map
        Expanded(child: Container(
          color: const Color(0xFFE8F0E9),
          child: Stack(children: [
            CustomPaint(painter: _GridPainter(), child: Container()),
            Center(child: Text(
              _stage == 0 ? '🔍\nNavigating to pickup...' : '🚖\nRide in progress...',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.textMuted),
            )),
            Positioned(top: 16, left: 16, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(20)),
              child: const Text('⏱️ ETA: 5 min',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            )),
            Positioned(top: 16, right: 16, child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.safety),
              child: Container(width: 48, height: 48,
                decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                child: const Center(child: Text('🚨', style: TextStyle(fontSize: 20)))),
            )),
          ]),
        )),

        // Status card
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_stages[_stage], style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            for (final row in [
              ['Passenger', args['passenger'] ?? 'Arjun Kumar'],
              ['Pickup',    args['pickup'] ?? 'Tambaram'],
              ['Drop',      args['drop'] ?? 'Guindy'],
              ['Fare',      '₹${args['fare'] ?? 60}'],
            ])
              Padding(padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(row[0], style: const TextStyle(color: AppColors.textMuted)),
                  Text(row[1], style: const TextStyle(fontWeight: FontWeight.w700)),
                ])),
            const SizedBox(height: 14),
            if (_stage < 2) ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: Text(_btns[_stage]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFD0DDD0)..strokeWidth = 0.5;
    for (double x = 0; x < size.width;  x += 40) {
      canvas.drawLine(Offset(x,0), Offset(x,size.height), p);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0,y), Offset(size.width,y), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
