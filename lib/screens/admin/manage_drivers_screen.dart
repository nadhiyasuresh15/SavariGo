// screens/admin/manage_drivers_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ManageDriversScreen extends StatelessWidget {
  const ManageDriversScreen({super.key});

  static const _drivers = [
    {'name':'Ravi Auto', 'vehicle':'TN-01-AB-1234','license':'TN0120230001','status':'verified', 'trust':92,'avail':'online'},
    {'name':'Murugan S', 'vehicle':'TN-02-CD-5678','license':'TN0220230002','status':'verified', 'trust':88,'avail':'online'},
    {'name':'Selvam K',  'vehicle':'TN-03-EF-9012','license':'TN0320230003','status':'pending',  'trust':0, 'avail':'offline'},
  ];

  Color _statusColor(String s) {
    switch(s) { case 'verified': return AppColors.green; case 'pending': return AppColors.orange; default: return AppColors.red; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚖 Manage Drivers')),
      backgroundColor: AppColors.background,
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Row(children: [
          _chip('Verified', '${_drivers.where((d) => d['status']=='verified').length}', AppColors.green),
          const SizedBox(width: 8),
          _chip('Pending',  '${_drivers.where((d) => d['status']=='pending').length}',  AppColors.orange),
          const SizedBox(width: 8),
          _chip('Online',   '${_drivers.where((d) => d['avail']=='online').length}',    AppColors.yellow),
        ]),
        const SizedBox(height: 12),
        ..._drivers.map((d) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(padding: const EdgeInsets.all(14), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: AppColors.yellow,
                  child: Text((d['name'] as String)[0],
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.black))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(d['vehicle'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(d['status'] as String).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(d['status'] as String, style: TextStyle(
                      color: _statusColor(d['status'] as String),
                      fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                const SizedBox(height: 4),
                Text('⭐ ${d['trust']}/100', style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.yellow)),
              ]),
            ]),
          ])),
        )),
      ]),
    );
  }

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4))),
    child: Text('$label: $value', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
  );
}
