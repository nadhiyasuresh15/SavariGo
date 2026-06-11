// screens/admin/manage_users_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  static const _users = [
    {'name':'Arjun Kumar',  'email':'passenger@savarigo.com','gender':'Male',  'pts':30,'role':'passenger'},
    {'name':'Priya Sharma', 'email':'priya@savarigo.com',    'gender':'Female','pts':50,'role':'passenger'},
    {'name':'Nadhiya R',    'email':'nadhiya@savarigo.com',  'gender':'Female','pts':20,'role':'passenger'},
    {'name':'Karthik S',    'email':'karthik@savarigo.com',  'gender':'Male',  'pts':10,'role':'passenger'},
    {'name':'Lakshmi Devi', 'email':'lakshmi@savarigo.com',  'gender':'Female','pts':40,'role':'passenger'},
    {'name':'Kavitha M',    'email':'kavitha@savarigo.com',  'gender':'Female','pts':25,'role':'passenger'},
  ];

  @override
  Widget build(BuildContext context) {
    final female = _users.where((u) => u['gender'] == 'Female').length;
    return Scaffold(
      appBar: AppBar(title: const Text('🧍 Manage Passengers')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
        Row(children: [
          _chip('Total', '${_users.length}', AppColors.yellow),
          const SizedBox(width: 8),
          _chip('👩 Female', '$female', AppColors.pink),
          const SizedBox(width: 8),
          _chip('👨 Male', '${_users.length - female}', AppColors.blue),
        ]),
        const SizedBox(height: 12),
        ..._users.map((u) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: u['gender'] == 'Female' ? AppColors.lightPink : AppColors.lightGrey,
              child: Text((u['name'] as String)[0], style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: u['gender'] == 'Female' ? AppColors.pink : AppColors.black)),
            ),
            title: Text(u['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(u['email'] as String),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: u['gender'] == 'Female' ? AppColors.lightPink : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(u['gender'] as String, style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: u['gender'] == 'Female' ? AppColors.pink : AppColors.black)),
              ),
              const SizedBox(height: 3),
              Text('🌿 ${u['pts']} pts', style: const TextStyle(
                  fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w600)),
            ]),
          ),
        )),
      ]))),
    );
  }

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: TextStyle(fontSize: 12, color: color)),
      const SizedBox(width: 6),
      Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 16)),
    ]),
  );
}
