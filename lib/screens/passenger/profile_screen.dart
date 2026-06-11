// screens/passenger/profile_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser ?? {};
    final name   = user['name'] ?? 'Passenger';
    final email  = user['email'] ?? '';
    final gender = user['gender'] ?? 'male';
    final pts    = user['green_points'] ?? 30;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.yellow,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.yellow,
              child: SafeArea(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 40, height: 40),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 36, backgroundColor: AppColors.black,
                    child: Text(name[0].toUpperCase(), style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.yellow)),
                  ),
                  const SizedBox(height: 8),
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(email, style: const TextStyle(fontSize: 12, color: AppColors.black)),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('🧍 Passenger', style: const TextStyle(
                        color: AppColors.yellow, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ],
              )),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          // Stats row
          Row(children: [
            _statCard('🚖', 'Total Rides',   '8'),
            const SizedBox(width: 8),
            _statCard('🌿', 'Green Points', '$pts'),
            const SizedBox(width: 8),
            _statCard('💰', 'Total Saved',  '₹720'),
          ]),
          const SizedBox(height: 14),

          // Details
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Personal Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            for (final row in [
              ['Full Name',  name],
              ['Email',      email],
              ['Phone',      user['phone'] ?? '9876543210'],
              ['Gender',     gender],
              ['Language',   'Tamil / English'],
            ])
              Padding(padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(row[0], style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  Text(row[1], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ]),
              ),
          ]))),
          const SizedBox(height: 8),

          // Menu
          Card(child: Column(children: [
            for (final item in [
              {'icon': '👩', 'label': 'Women-Only Mode', 'route': AppRoutes.womenOnly},
              {'icon': '🛡️', 'label': 'Safety & SOS',    'route': AppRoutes.safety},
              {'icon': '📋', 'label': 'Ride History',    'route': AppRoutes.rideHistory},
              {'icon': '⭐', 'label': 'Feedback',         'route': AppRoutes.feedback},
            ])
              ListTile(
                leading: Text(item['icon']!, style: const TextStyle(fontSize: 22)),
                title: Text(item['label']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
                onTap: () => Navigator.pushNamed(context, item['route']!),
              ),
          ])),
          const SizedBox(height: 8),

          // Green points
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
              border: const Border(left: BorderSide(color: AppColors.green, width: 4)),
            ),
            child: Column(children: [
              const Text('🌿 Green Ride Points', style: TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.green, fontSize: 15)),
              Text('$pts Points', style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.green)),
              const Text('You\'ve shared rides and helped reduce Chennai\'s traffic!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.green)),
            ]),
          ),
          const SizedBox(height: 14),

          OutlinedButton.icon(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              }
            },
            icon: const Icon(Icons.logout, color: AppColors.red),
            label: const Text('Logout', style: TextStyle(color: AppColors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.red),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }

  Widget _statCard(String icon, String label, String value) => Expanded(child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
    ),
    child: Column(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          textAlign: TextAlign.center),
    ]),
  ));
}
