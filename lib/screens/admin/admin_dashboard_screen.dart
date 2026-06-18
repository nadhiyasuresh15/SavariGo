// screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/dashboard_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 32, height: 32),
            const SizedBox(width: 8),
            const Text('SavariGo Admin'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.adminLogin),
          ),
        ],
      ),
      drawer: _AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📊 Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const Text(
                'Welcome back, Admin! · SavariGo Chennai Operations',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              DashboardCard(
                icon: '🧍',
                label: 'Total Passengers',
                value: '9',
                color: AppColors.yellow,
                sub: 'Registered users',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.manageUsers),
              ),
              const SizedBox(height: 10),
              DashboardCard(
                icon: '🚖',
                label: 'Total Drivers',
                value: '2',
                color: AppColors.black,
                sub: 'On platform',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.manageDrivers),
              ),
              const SizedBox(height: 10),
              DashboardCard(
                icon: '📋',
                label: 'Total Rides',
                value: '5',
                color: AppColors.green,
                sub: 'All time',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.manageRides),
              ),
              const SizedBox(height: 10),
              const DashboardCard(
                icon: '✅',
                label: 'Completed Rides',
                value: '3',
                color: AppColors.green,
                sub: 'Successfully done',
              ),
              const SizedBox(height: 10),
              DashboardCard(
                icon: '🚨',
                label: 'SOS Alerts',
                value: '1',
                color: AppColors.red,
                sub: 'Total alerts',
                onTap: () => Navigator.pushNamed(context, AppRoutes.sosAlerts),
              ),
              const SizedBox(height: 16),
              const Text(
                '📍 Top Chennai Zones Today',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final z in [
                    ['Tambaram→Guindy', '18', AppColors.yellow],
                    ['T Nagar→Velachery', '14', AppColors.green],
                    ['Koyambedu→Porur', '11', AppColors.pink],
                    ['Chromepet→Saidapet', '9', AppColors.blue],
                    ['Adyar→Egmore', '8', AppColors.orange],
                  ])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: (z[2] as Color).withValues(alpha: 0.12),
                        border: Border.all(color: z[2] as Color, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            z[0] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${z[1]} rides',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: z[2] as Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            color: AppColors.black,
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', width: 44, height: 44),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SavariGo',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Admin Panel',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _tile(context, '📊', 'Dashboard', AppRoutes.adminDashboard),
                _tile(context, '🧍', 'Passengers', AppRoutes.manageUsers),
                _tile(context, '🚖', 'Drivers', AppRoutes.manageDrivers),
                _tile(context, '📋', 'Rides', AppRoutes.manageRides),
                _tile(context, '🚨', 'SOS Alerts', AppRoutes.sosAlerts),
                _tile(context, '📈', 'Reports', AppRoutes.reports),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.red),
            ),
            onTap: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.adminLogin),
          ),
        ],
      ),
    );
  }

  ListTile _tile(
    BuildContext ctx,
    String icon,
    String label,
    String route,
  ) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}
