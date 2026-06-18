// screens/driver/driver_profile_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Driver Profile'), backgroundColor: AppColors.black,
          foregroundColor: AppColors.yellow),
      body: SingleChildScrollView(child: Column(children: [
        // Header
        Container(
          color: AppColors.black,
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const CircleAvatar(radius: 40, backgroundColor: AppColors.yellow,
                child: Text('R', style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.black))),
            const SizedBox(height: 10),
            const Text('Ravi Auto', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.yellow)),
            const Text('driver@savarigo.com', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _badge('✅ Verified', AppColors.green),
              const SizedBox(width: 8),
              _badge('⭐ Trust: 92', AppColors.yellow),
            ]),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
            for (final row in [
              ['Vehicle Number', 'TN-01-AB-1234'],
              ['License Number', 'TN0120230001'],
              ['Verification',   '✅ Verified'],
              ['Trust Score',    '92/100'],
              ['Status',         '🟢 Online'],
            ])
              Padding(padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(row[0], style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  Text(row[1], style: const TextStyle(fontWeight: FontWeight.w700)),
                ])),
          ]))),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
            },
            icon: const Icon(Icons.logout, color: AppColors.red),
            label: const Text('Logout', style: TextStyle(color: AppColors.red)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.red),
                minimumSize: const Size(double.infinity, 48)),
          ),
        ])),
      ])),
    );
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5))),
    child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
  );
}
