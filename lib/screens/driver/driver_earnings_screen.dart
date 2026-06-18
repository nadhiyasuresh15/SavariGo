// screens/driver/driver_earnings_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  static const _history = [
    {'date': 'Today',        'rides': 3, 'earned': 480},
    {'date': 'Yesterday',    'rides': 5, 'earned': 750},
    {'date': 'Mon, Jan 15',  'rides': 4, 'earned': 600},
    {'date': 'Sun, Jan 14',  'rides': 6, 'earned': 870},
    {'date': 'Sat, Jan 13',  'rides': 7, 'earned': 980},
  ];

  @override
  Widget build(BuildContext context) {
    final weekTotal = _history.fold<int>(0, (s, d) => s + (d['earned'] as int));
    final weekRides = _history.fold<int>(0, (s, d) => s + (d['rides'] as int));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        const SliverAppBar(
          pinned: true, backgroundColor: AppColors.black, expandedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('💰 Driver Earnings', style: TextStyle(color: AppColors.yellow)),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          // Summary row
          Row(children: [
            _sumCard('📈', 'This Week',  '₹$weekTotal', AppColors.green),
            const SizedBox(width: 8),
            _sumCard('🚖', 'Total Rides', '$weekRides', AppColors.yellow),
            const SizedBox(width: 8),
            _sumCard('🏅', 'Trust Score', '92 ⭐',      AppColors.blue),
          ]),
          const SizedBox(height: 16),

          // Daily breakdown
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Daily Earnings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            ..._history.map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d['date'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('${d['rides']} rides', style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
                ]),
                Text('₹${d['earned']}', style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.green)),
              ]),
            )),
          ]))),
          const SizedBox(height: 12),

          // Eco impact
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGreen, borderRadius: BorderRadius.circular(14),
              border: const Border(left: BorderSide(color: AppColors.green, width: 4)),
            ),
            child: const Column(children: [
              Text('🌿 Eco Impact This Week', style: TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.green, fontSize: 15)),
              SizedBox(height: 6),
              Text('25 shared rides', style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.green)),
              SizedBox(height: 4),
              Text('You helped reduce CO₂ emissions for Chennai! Thank you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.green)),
            ]),
          ),
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }

  Widget _sumCard(String icon, String label, String value, Color color) => Expanded(child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
    ),
    child: Column(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          textAlign: TextAlign.center),
    ]),
  ));
}
