// screens/passenger/safety_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/safety_service.dart';
import '../../services/auth_service.dart';
import '../../utils/helpers.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});
  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  bool _sosSent = false;

  Future<void> _triggerSOS() async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('🚨 Send SOS?'),
      content: const Text('This will alert your emergency contact and the SavariGo safety team.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
          child: const Text('Send SOS'),
        ),
      ],
    ));
    if (confirm != true) return;
    final user = AuthService.currentUser;
    await SafetyService.triggerSOS(
      userId:           user?['id'] ?? 'demo',
      location:         'Current GPS Location',
      emergencyContact: '9800000099',
    );
    setState(() => _sosSent = true);
    if (mounted) Helpers.showSnack(context, '🚨 SOS Sent! Paathukaapu! Help is on the way.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          backgroundColor: AppColors.black,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('🛡️ Safety Center', style: TextStyle(color: AppColors.white)),
            centerTitle: true,
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          // Big SOS button
          GestureDetector(
            onTap: _triggerSOS,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 160, height: 160,
              decoration: BoxDecoration(
                color: _sosSent ? const Color(0xFFB71C1C) : AppColors.red,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: AppColors.red.withValues(alpha: 0.5),
                  blurRadius: 20, spreadRadius: 4,
                )],
              ),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🚨', style: TextStyle(fontSize: 44)),
                const Text('SOS', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                Text(_sosSent ? 'SENT' : 'EMERGENCY',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ])),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Tap to send emergency alert to your trusted contact',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 20),

          // Safety features list
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Safety Features', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 10),
            for (final f in [
              {'icon': '📍', 'title': 'Share Live Location',   'desc': 'Share your ride with trusted contacts', 'route': null},
              {'icon': '🔐', 'title': 'Ride OTP Verification', 'desc': 'Driver must enter OTP before starting', 'route': null},
              {'icon': '✅', 'title': 'Driver Verification',    'desc': 'All drivers are background-checked',    'route': null},
              {'icon': '👁️', 'title': 'Guardian Mode',          'desc': 'Live tracking shared with guardian',   'route': null},
              {'icon': '👩', 'title': 'Women-Only Mode',        'desc': 'Female-only safe pooling',             'route': AppRoutes.womenOnly},
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(f['icon']!, style: const TextStyle(fontSize: 24)),
                title: Text(f['title']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text(f['desc']!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                trailing: f['route'] != null ? const Icon(Icons.chevron_right, color: AppColors.grey) : null,
                onTap: f['route'] != null ? () => Navigator.pushNamed(context, f['route']!) : null,
              ),
          ]))),
          const SizedBox(height: 10),

          // Helplines
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Emergency Helplines', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 10),
            for (final h in [
              ['Police',           '100'],
              ['Women Helpline',   '1091'],
              ['Ambulance',        '108'],
              ['SavariGo Support', '1800-XXX-XXXX'],
            ])
              Padding(padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(h[0], style: const TextStyle(fontSize: 14)),
                  Text(h[1], style: const TextStyle(
                      fontWeight: FontWeight.w900, color: AppColors.red, fontSize: 15)),
                ]),
              ),
          ]))),
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }
}
