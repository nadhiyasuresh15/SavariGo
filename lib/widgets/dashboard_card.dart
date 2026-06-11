// widgets/dashboard_card.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DashboardCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final String? sub;
  final VoidCallback? onTap;

  const DashboardCard({super.key,
    required this.icon, required this.label,
    required this.value, required this.color,
    this.sub, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: color, width: 5)),
          boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8, offset: const Offset(0, 2),
          )],
        ),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.black, height: 1.1)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            if (sub != null) Text(sub!, style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ])),
          if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.grey),
        ]),
      ),
    );
  }
}
