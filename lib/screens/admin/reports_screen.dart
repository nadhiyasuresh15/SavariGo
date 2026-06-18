// screens/admin/reports_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _monthly = [
    {'month': 'Aug', 'rides': 120, 'revenue': 7200},
    {'month': 'Sep', 'rides': 145, 'revenue': 8700},
    {'month': 'Oct', 'rides': 180, 'revenue': 10800},
    {'month': 'Nov', 'rides': 210, 'revenue': 12600},
    {'month': 'Dec', 'rides': 265, 'revenue': 15900},
    {'month': 'Jan', 'rides': 310, 'revenue': 18600},
  ];

  static const _zones = [
    {'zone': 'Tambaram→Guindy', 'rides': 142},
    {'zone': 'T Nagar→Velachery', 'rides': 118},
    {'zone': 'Koyambedu→Porur', 'rides': 96},
    {'zone': 'Chromepet→Saidapet', 'rides': 83},
    {'zone': 'Adyar→Egmore', 'rides': 71},
  ];

  @override
  Widget build(BuildContext context) {
    final totalRides = _monthly.fold<int>(0, (s, m) => s + (m['rides'] as int));
    final totalRevenue =
        _monthly.fold<int>(0, (s, m) => s + (m['revenue'] as int));
    final maxRides =
        _monthly.map((m) => m['rides'] as int).reduce((a, b) => a > b ? a : b);
    final maxZone =
        _zones.map((z) => z['rides'] as int).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('📈 Reports & Analytics')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _sumCard(
                    '🚖',
                    'Total Rides\n(6 mo)',
                    '$totalRides',
                    AppColors.yellow,
                  ),
                  const SizedBox(width: 8),
                  _sumCard(
                    '💰',
                    'Revenue',
                    '₹${_formatNum(totalRevenue)}',
                    AppColors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _sumCard('🧍', 'Users', '72', AppColors.blue),
                  const SizedBox(width: 8),
                  _sumCard('🤖', 'AI Matches', '826', AppColors.pink),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📊 Monthly Rides',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _monthly.map((m) {
                            final h = ((m['rides'] as int) / maxRides * 140)
                                .toDouble();

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${m['rides']}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  width: 28,
                                  height: h,
                                  decoration: const BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m['month'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💰 Monthly Revenue (₹)',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._monthly.map((m) {
                        final w = (m['revenue'] as int) /
                            (totalRevenue / _monthly.length);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  m['month'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: w.clamp(0.0, 1.5) / 1.5,
                                    minHeight: 14,
                                    backgroundColor: AppColors.lightGrey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      AppColors.green,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${_formatNum(m['revenue'] as int)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📍 Top Chennai Pooling Zones',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._zones.map(
                        (z) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    z['zone'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${z['rides']} rides',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (z['rides'] as int) / maxZone,
                                  minHeight: 10,
                                  backgroundColor: AppColors.lightGrey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🚖 Ride Type Breakdown',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final item in [
                        {
                          'label': 'Shared Pool',
                          'pct': 74,
                          'color': AppColors.yellow,
                        },
                        {
                          'label': 'Women-Only',
                          'pct': 18,
                          'color': AppColors.pink,
                        },
                        {
                          'label': 'Private Ride',
                          'pct': 8,
                          'color': AppColors.grey,
                        },
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  item['label'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (item['pct'] as int) / 100,
                                    minHeight: 16,
                                    backgroundColor: AppColors.lightGrey,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      item['color'] as Color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item['pct']}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: item['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sumCard(String icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatNum(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
