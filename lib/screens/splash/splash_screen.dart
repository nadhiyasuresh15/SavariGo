// screens/splash/splash_screen.dart
// SavariGo - Animated Splash Screen

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _scale = Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Animated Logo
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Image.asset('assets/images/logo.png', width: 180, height: 180),
            ),
          ),
          const SizedBox(height: 24),
          // App tagline
          FadeTransition(
            opacity: _fade,
            child: Column(children: [
              const Text('Share the Ride, Save the City 🚖🌿',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black)),
              const SizedBox(height: 6),
              Text('Vanakkam! 🙏', style: TextStyle(
                  fontSize: 14, color: AppColors.black.withValues(alpha: 0.6))),
            ]),
          ),
          const SizedBox(height: 50),
          // Loading dots
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _dot(AppColors.black), const SizedBox(width: 8),
            _dot(AppColors.green), const SizedBox(width: 8),
            _dot(AppColors.black),
          ]),
        ]),
      ),
    );
  }

  Widget _dot(Color c) => Container(
    width: 10, height: 10,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
}
