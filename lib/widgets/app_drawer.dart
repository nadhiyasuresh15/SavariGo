// widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final isDriver = user?['role'] == 'driver';

    return Drawer(
      child: Column(children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
          color: AppColors.yellow,
          child: Row(children: [
            Image.asset('assets/images/logo.png', width: 48, height: 48),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?['name'] ?? 'Passenger',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Text(user?['email'] ?? '', style: const TextStyle(fontSize: 12)),
            ])),
          ]),
        ),

        // Menu items
        Expanded(child: ListView(padding: EdgeInsets.zero, children: [
          if (!isDriver) ...[
            _item(context, '🏠', 'Home',          AppRoutes.passengerHome),
            _item(context, '🚖', 'Book Ride',      AppRoutes.bookRide),
            _item(context, '📋', 'Ride History',   AppRoutes.rideHistory),
            _item(context, '👩', 'Women-Only Mode',AppRoutes.womenOnly),
            _item(context, '🌿', 'Green Points',   AppRoutes.profile),
            _item(context, '🛡️', 'Safety / SOS',   AppRoutes.safety),
            _item(context, '⭐', 'Feedback',        AppRoutes.feedback),
            _item(context, '👤', 'Profile',         AppRoutes.profile),
          ] else ...[
            _item(context, '📊', 'Dashboard',      AppRoutes.driverDashboard),
            _item(context, '💰', 'Earnings',        AppRoutes.driverEarnings),
            _item(context, '👤', 'Driver Profile', AppRoutes.driverProfile),
          ],
          const Divider(),
          _item(context, '🔐', 'Admin Panel', AppRoutes.adminLogin),
        ])),

        // Logout
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.red),
          title: const Text('Logout', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600)),
          onTap: () async {
            await AuthService.logout();
            if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
          },
        ),
        const SizedBox(height: 12),
      ]),
    );
  }

  ListTile _item(BuildContext ctx, String icon, String label, String route) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () { Navigator.pop(ctx); Navigator.pushNamed(ctx, route); },
    );
  }
}
