// screens/admin/manage_rides_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ManageRidesScreen extends StatelessWidget {
  const ManageRidesScreen({super.key});

  static const _rides = [
    {'pickup':'Tambaram',  'drop':'Guindy',     'type':'shared','women':false,'status':'completed',   'fare':60},
    {'pickup':'T Nagar',   'drop':'Velachery',  'type':'shared','women':true, 'status':'completed',   'fare':55},
    {'pickup':'Koyambedu', 'drop':'Anna Nagar', 'type':'shared','women':true, 'status':'in_progress', 'fare':45},
    {'pickup':'Chromepet', 'drop':'Saidapet',   'type':'shared','women':false,'status':'searching',   'fare':75},
    {'pickup':'Adyar',     'drop':'Egmore',     'type':'shared','women':true, 'status':'completed',   'fare':50},
  ];

  Color _sc(String s) {
    switch(s) { case 'completed': return AppColors.green; case 'in_progress': return AppColors.orange;
      case 'searching': return AppColors.blue; default: return AppColors.textMuted; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📋 Manage Rides')),
      backgroundColor: AppColors.background,
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          _chip('Total',      '${_rides.length}',                                                AppColors.black),
          _chip('Completed',  '${_rides.where((r) => r['status']=="completed").length}',        AppColors.green),
          _chip('Active',     '${_rides.where((r) => r['status']=="in_progress").length}',      AppColors.orange),
          _chip('👩 Women',   '${_rides.where((r) => r['women']==true).length}',                AppColors.pink),
        ]),
        const SizedBox(height: 12),
        ..._rides.map((r) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(width: 8, height: 48,
                decoration: BoxDecoration(color: _sc(r['status'] as String),
                    borderRadius: BorderRadius.circular(4))),
            title: Text('${r['pickup']} → ${r['drop']}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: _sc(r['status'] as String).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(r['status'] as String, style: TextStyle(
                    color: _sc(r['status'] as String), fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              if (r['women'] == true) ...[
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.lightPink, borderRadius: BorderRadius.circular(6)),
                  child: const Text('👩', style: TextStyle(fontSize: 11))),
              ],
            ]),
            trailing: Text('₹${r['fare']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.green)),
          ),
        )),
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
