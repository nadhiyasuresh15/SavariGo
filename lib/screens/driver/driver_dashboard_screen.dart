// screens/driver/driver_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/app_drawer.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});
  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _online = false;

  static const _requests = [
    {'passenger': 'Arjun Kumar',  'pickup': 'Tambaram',  'drop': 'Guindy',     'fare': 60,  'seats': 1, 'score': 92, 'women': false},
    {'passenger': 'Priya Sharma', 'pickup': 'T Nagar',   'drop': 'Velachery',  'fare': 55,  'seats': 1, 'score': 85, 'women': true},
    {'passenger': 'Karthik S',    'pickup': 'Koyambedu', 'drop': 'Anna Nagar', 'fare': 40,  'seats': 2, 'score': 78, 'women': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.black,
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                Image.asset('assets/images/logo.png', width: 44, height: 44),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Vanakkam, Ravi! 🙏',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.yellow)),
                  const Text('TN-01-AB-1234 · ✅ Verified',
                      style: TextStyle(fontSize: 11, color: Colors.white54)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _online ? AppColors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('⭐ 92', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ]),
            )),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          // Online toggle
          Card(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_online ? '🟢 You are ONLINE' : '🔴 You are OFFLINE',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                Text(_online ? 'Receiving ride requests' : 'Go online to receive rides',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              Switch(value: _online, onChanged: (v) => setState(() => _online = v),
                  activeThumbColor: AppColors.green),
            ]),
          )),
          const SizedBox(height: 12),

          // Earnings summary
          Row(children: [
            _earningCard('💰', "Today's", '₹480'),
            const SizedBox(width: 8),
            _earningCard('📈', 'This Week', '₹2,850'),
            const SizedBox(width: 8),
            _earningCard('🚖', 'Rides', '8'),
          ]),
          const SizedBox(height: 14),

          if (_online) ...[
            const Align(alignment: Alignment.centerLeft,
                child: Text('📥 Incoming Requests', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
            const SizedBox(height: 8),
            ..._requests.map((r) => _requestCard(context, r)),
          ] else
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.circular(14)),
              child: const Column(children: [
                Text('🔴', style: TextStyle(fontSize: 36)),
                SizedBox(height: 8),
                Text('Go online to start receiving ride requests! 🚖',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              ]),
            ),

          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverEarnings),
              icon: const Icon(Icons.bar_chart), label: const Text('Earnings'),
            )),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverProfile),
              icon: const Icon(Icons.person), label: const Text('Profile'),
            )),
          ]),
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }

  Widget _earningCard(String icon, String label, String value) => Expanded(child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
    ),
    child: Column(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          textAlign: TextAlign.center),
    ]),
  ));

  Widget _requestCard(BuildContext ctx, Map r) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: Padding(padding: const EdgeInsets.all(14), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text('🧍 ${r['passenger']}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (r['score'] as int) >= 90 ? AppColors.lightGreen : const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('AI: ${r['score']}', style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 12,
              color: (r['score'] as int) >= 90 ? AppColors.green : const Color(0xFFF57F17))),
        ),
        if (r['women'] == true) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.lightPink, borderRadius: BorderRadius.circular(8)),
            child: const Text('👩 Women', style: TextStyle(
                color: AppColors.pink, fontWeight: FontWeight.w700, fontSize: 11)),
          ),
        ],
      ]),
      const SizedBox(height: 8),
      Text('📍 ${r['pickup']} → ${r['drop']}', style: const TextStyle(fontSize: 13)),
      Text('💵 ₹${r['fare']}/person · ${r['seats']} seat(s)',
          style: const TextStyle(fontSize: 13, color: AppColors.green, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(ctx, AppRoutes.activeRide, arguments: r),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
          child: const Text('✅ Accept'),
        )),
        const SizedBox(width: 10),
        Expanded(child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
          child: const Text('✗ Reject'),
        )),
      ]),
    ])),
  );
}
