// screens/passenger/women_only_mode_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';

class WomenOnlyModeScreen extends StatefulWidget {
  const WomenOnlyModeScreen({super.key});
  @override
  State<WomenOnlyModeScreen> createState() => _WomenOnlyModeScreenState();
}

class _WomenOnlyModeScreenState extends State<WomenOnlyModeScreen> {
  bool _womenOnly    = false;
  bool _guardianMode = false;
  bool _otpVerify    = true;

  void _toggleWomenOnly(bool val) {
    setState(() => _womenOnly = val);
    if (val) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('👩 Pengal Mattum Mode ON! You will only be matched with female passengers.'),
        backgroundColor: AppColors.pink,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppColors.pink,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.pink, Color(0xFFAD1457)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              child: const SafeArea(child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👩', style: TextStyle(fontSize: 44)),
                  SizedBox(height: 8),
                  Text('Pengal Mattum Mode', style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text('Women-Only Safe Pooling', style: TextStyle(
                      fontSize: 13, color: Colors.white70)),
                  Text('பெண்கள் மட்டும் பயணம்', style: TextStyle(
                      fontSize: 12, color: Colors.white60)),
                ],
              ))),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [

          // Main toggle
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🛡️ Women-Only Mode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Match only with female passengers', style: TextStyle(
                  color: AppColors.textMuted, fontSize: 12)),
            ])),
            Switch(value: _womenOnly, onChanged: _toggleWomenOnly,
                activeThumbColor: AppColors.pink),
          ]))),

          if (_womenOnly) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
              ),
              child: const Row(children: [
                Icon(Icons.check_circle, color: AppColors.green),
                SizedBox(width: 8),
                Text('✅ Women-Only Mode Active · Paathukaapu!',
                    style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
              ]),
            ),

            const SizedBox(height: 14),
            const Align(alignment: Alignment.centerLeft,
                child: Text('Safety Features', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
            const SizedBox(height: 8),

            // Guardian mode toggle
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('👁️ Guardian Mode', style: TextStyle(fontWeight: FontWeight.w700)),
                const Text('Share live ride with trusted contact',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              Switch(value: _guardianMode, onChanged: (v) => setState(() => _guardianMode = v),
                  activeThumbColor: AppColors.pink),
            ]))),

            // OTP toggle
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🔐 Ride OTP Verification', style: TextStyle(fontWeight: FontWeight.w700)),
                const Text('Driver must enter OTP to start ride',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              Switch(value: _otpVerify, onChanged: (v) => setState(() => _otpVerify = v),
                  activeThumbColor: AppColors.pink),
            ]))),

            // Feature list
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('How Women-Only Mode Works', style: TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.pink)),
              const SizedBox(height: 10),
              for (final f in [
                '👩 Matched only with verified female passengers',
                '🚖 Only verified, background-checked drivers',
                '🔐 OTP required before driver starts ride',
                '📍 Real-time location shared with trusted contact',
                '🚨 SOS button always visible during ride',
                '👁️ Guardian Mode: Live tracking shared',
                '📱 Auto-alert emergency contact on SOS',
              ])
                Padding(padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(f, style: const TextStyle(fontSize: 13))),
            ]))),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.safety),
              icon: const Icon(Icons.warning_rounded),
              label: const Text('SOS Emergency Button 🚨'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],

          if (!_womenOnly) ...[
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('About Pengal Mattum Mode', style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.pink)),
              const SizedBox(height: 10),
              const Text(
                'Enable this mode for a safer travel experience.\n\n'
                'When enabled, you will only be pooled with other female passengers '
                'and only verified drivers will be assigned to your rides.\n\n'
                'Additional safety features like Guardian Mode, OTP verification, '
                'and SOS alerts will be activated automatically.',
                style: TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.6),
              ),
            ]))),
          ],
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }
}
