// screens/admin/sos_alerts_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SOSAlertsScreen extends StatelessWidget {
  const SOSAlertsScreen({super.key});

  static const _alerts = [
    {'user':'Nadhiya R',  'location':'Koyambedu Bus Stand', 'contact':'9800000099','status':'resolved','time':'2024-01-13 14:22'},
    {'user':'Priya S',    'location':'T Nagar Signal',      'contact':'9800000088','status':'active',  'time':'2024-01-15 09:45'},
  ];

  @override
  Widget build(BuildContext context) {
    final active = _alerts.where((a) => a['status'] == 'active').length;
    return Scaffold(
      appBar: AppBar(title: const Text('🚨 SOS Alerts'), backgroundColor: active > 0 ? AppColors.red : null,
          foregroundColor: active > 0 ? Colors.white : null),
      backgroundColor: AppColors.background,
      body: ListView(padding: const EdgeInsets.all(14), children: [
        if (active > 0)
          Container(
            padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Text('🚨', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$active ACTIVE SOS ALERT${active > 1 ? 'S' : ''}!',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                const Text('Immediate attention required!',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
        Row(children: [
          _chip('Total',    '${_alerts.length}', AppColors.black),
          const SizedBox(width: 8),
          _chip('Active',   '$active',           AppColors.red),
          const SizedBox(width: 8),
          _chip('Resolved', '${_alerts.length - active}', AppColors.green),
        ]),
        const SizedBox(height: 12),
        ..._alerts.map((a) {
          final isActive = a['status'] == 'active';
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(padding: const EdgeInsets.all(14), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: isActive ? AppColors.red : AppColors.lightGreen,
                    child: Text((a['user'] as String)[0], style: TextStyle(
                        fontWeight: FontWeight.w900, color: isActive ? Colors.white : AppColors.green))),
                const SizedBox(width: 10),
                Expanded(child: Text(a['user'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isActive ? AppColors.red : AppColors.green).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text((a['status'] as String).toUpperCase(), style: TextStyle(
                      color: isActive ? AppColors.red : AppColors.green,
                      fontWeight: FontWeight.w800, fontSize: 11)),
                ),
              ]),
              const SizedBox(height: 8),
              Text('📍 ${a['location']}', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('📞 Emergency: ${a['contact']}', style: const TextStyle(
                  fontSize: 12, color: AppColors.textMuted)),
              Text('🕐 ${a['time']}', style: const TextStyle(
                  fontSize: 11, color: AppColors.textMuted)),
            ])),
          );
        }),
      ]),
    );
  }

  Widget _chip(String l, String v, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.3))),
    child: Text('$l: $v', style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12)),
  );
}
