// screens/passenger/passenger_home_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_text.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/safety_button.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(slivers: [
        // Yellow App Bar with logo
        SliverAppBar(
          expandedHeight: 110,
          pinned: true,
          backgroundColor: AppColors.yellow,
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                Image.asset('assets/images/logo.png', width: 48, height: 48),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(AppText.vanakkam, style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.black)),
                  Text(AppText.rideReady, style: const TextStyle(
                      fontSize: 12, color: AppColors.black)),
                ])),
                SafetySOSButton(small: true,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.safety)),
              ]),
            )),
          ),
        ),

        SliverToBoxAdapter(child: Column(children: [
          // Women-Only Banner
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.womenOnly),
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(12),
                border: const Border(left: BorderSide(color: AppColors.pink, width: 4)),
              ),
              child: Row(children: [
                const Text('👩', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pengal Mattum Mode', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.pink)),
                  Text('Women-Only Safe Pooling → Tap to enable',
                      style: TextStyle(fontSize: 11, color: AppColors.pink)),
                ])),
                const Icon(Icons.chevron_right, color: AppColors.pink),
              ]),
            ),
          ),

          // Booking Card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(padding: const EdgeInsets.all(16), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Book a Shared Auto 🚖',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              _locationRow(context, Icons.radio_button_checked, AppColors.green, 'Pickup location', true),
              Container(height: 12, width: 1.5, margin: const EdgeInsets.only(left: 19),
                  color: AppColors.grey),
              _locationRow(context, Icons.location_on, AppColors.red, 'Drop location', false),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.bookRide),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Find AI Pool Match 🤖'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ])),
          ),

          // Quick Locations
          Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('📍 Popular Chennai Locations',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(height: 36, child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppText.chennaiLocations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.bookRide,
                      arguments: {'pickup': AppText.chennaiLocations[i]}),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Text(AppText.chennaiLocations[i],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              )),
            ]),
          ),

          // Feature Grid
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('✨ Features', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1,
              children: [
                _featureCard(context, '🤖', 'AI Pool\nMatch',    AppRoutes.aiPoolMatch),
                _featureCard(context, '👩', 'Women\nOnly',       AppRoutes.womenOnly),
                _featureCard(context, '📋', 'Ride\nHistory',     AppRoutes.rideHistory),
                _featureCard(context, '🌿', 'Green\nPoints',     AppRoutes.profile),
                _featureCard(context, '🚨', 'Safety\n/ SOS',     AppRoutes.safety),
                _featureCard(context, '⭐', 'Feedback',          AppRoutes.feedback),
              ],
            ),
          ])),

          // Green points banner
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
              border: const Border(left: BorderSide(color: AppColors.green, width: 4)),
            ),
            child: Column(children: [
              const Text('🌿 Your Green Ride Points: 30',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.green)),
              const SizedBox(height: 4),
              Text('Share rides, earn points, protect Chennai!',
                  style: TextStyle(fontSize: 12, color: AppColors.green.withValues(alpha: 0.8))),
            ]),
          ),
          const SizedBox(height: 20),
        ])),
      ]),
    );
  }

  Widget _locationRow(BuildContext ctx, IconData icon, Color c, String hint, bool isPickup) {
    return Row(children: [
      Icon(icon, color: c, size: 18),
      const SizedBox(width: 10),
      Expanded(child: GestureDetector(
        onTap: () => Navigator.pushNamed(ctx, AppRoutes.bookRide),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(hint, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ),
      )),
    ]);
  }

  Widget _featureCard(BuildContext ctx, String emoji, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}
