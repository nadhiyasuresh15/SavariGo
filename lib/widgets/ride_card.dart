// widgets/ride_card.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RideCard extends StatelessWidget {
  final String pickup;
  final String drop;
  final int farePerPerson;
  final String status;
  final bool womenOnly;
  final bool isShared;
  final String? date;

  const RideCard({
    super.key, required this.pickup, required this.drop,
    required this.farePerPerson, required this.status,
    this.womenOnly = false, this.isShared = true, this.date,
  });

  Color get _statusColor {
    switch (status) {
      case 'completed':   return AppColors.green;
      case 'in_progress': return AppColors.orange;
      case 'searching':   return AppColors.blue;
      case 'cancelled':   return AppColors.red;
      default:            return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.radio_button_checked, color: AppColors.green, size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(pickup, style: const TextStyle(fontWeight: FontWeight.w700))),
              ]),
              Container(margin: const EdgeInsets.only(left: 6), width: 1, height: 12,
                  color: AppColors.grey),
              Row(children: [
                const Icon(Icons.location_on, color: AppColors.red, size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(drop, style: const TextStyle(fontWeight: FontWeight.w700))),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('₹$farePerPerson', style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.black)),
              const Text('/person', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(status, style: TextStyle(
                  color: _statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            if (womenOnly) Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('👩 Women', style: TextStyle(
                  color: AppColors.pink, fontWeight: FontWeight.w700, fontSize: 11)),
            ),
            if (isShared) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🌿 +10 pts', style: TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 11)),
              ),
            ],
            if (date != null) ...[
              const Spacer(),
              Text(date!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ]),
        ]),
      ),
    );
  }
}
