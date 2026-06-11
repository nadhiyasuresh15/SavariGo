// widgets/safety_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SafetySOSButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool small;

  const SafetySOSButton({super.key, required this.onPressed, this.small = false});

  @override
  Widget build(BuildContext context) {
    final size = small ? 44.0 : 60.0;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: AppColors.red.withValues(alpha: 0.4),
            blurRadius: 12, spreadRadius: 2,
          )],
        ),
        child: Center(child: Text(
          small ? '🚨' : '🚨\nSOS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white, fontWeight: FontWeight.w900,
            fontSize: small ? 16 : 13, height: 1.2,
          ),
        )),
      ),
    );
  }
}
