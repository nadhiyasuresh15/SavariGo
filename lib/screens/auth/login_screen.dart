// screens/auth/login_screen.dart
// SavariGo - Login Screen

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'passenger@savarigo.com');
  final _passCtrl  = TextEditingController(text: '123456');
  bool _loading    = false;
  String _userType = 'passenger'; // passenger | driver

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final res = await AuthService.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    setState(() => _loading = false);
    if (!mounted) return;
    if (res['success'] == true) {
      final role = res['user']?['role'] ?? 'passenger';
      if (role == 'driver') {
        Navigator.pushReplacementNamed(context, AppRoutes.driverDashboard);
      } else if (role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.passengerHome);
      }
    } else {
      Helpers.showSnack(context, res['error'] ?? 'Login failed', error: true);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose(); _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          // Yellow header
          Container(
            width: double.infinity,
            color: AppColors.yellow,
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 28),
            child: Column(children: [
              Image.asset('assets/images/logo.png', width: 110, height: 110),
              const SizedBox(height: 10),
              const Text('Vanakkam! 🙏', style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.black)),
              const Text('Login to SavariGo', style: TextStyle(
                  fontSize: 13, color: AppColors.black)),
            ]),
          ),

          Padding(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [
            // Toggle passenger / driver
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.yellow, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                _toggleBtn('🧍 Passenger', 'passenger'),
                _toggleBtn('🚖 Driver', 'driver'),
              ]),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'Email', hint: 'your@email.com',
              controller: _emailCtrl,
              keyboard: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.email,
            ),
            const SizedBox(height: 14),

            CustomTextField(
              label: 'Password', hint: '••••••',
              controller: _passCtrl,
              obscure: true,
              prefixIcon: Icons.lock_outline,
              validator: Validators.password,
            ),
            const SizedBox(height: 12),

            // Demo hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Demo: passenger@savarigo.com / 123456\n'
                'Driver: driver@savarigo.com / 123456\n'
                'Admin: admin@savarigo.com / admin123',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            CustomButton(label: 'Login 🚖', onPressed: _login, loading: _loading),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text('New to SavariGo? Register here',
                style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
            ),
          ]))),
        ]),
      ),
    );
  }

  Widget _toggleBtn(String label, String type) {
    final active = _userType == type;
    return Expanded(child: GestureDetector(
      onTap: () {
        setState(() {
          _userType = type;
          _emailCtrl.text = type == 'driver' ? 'driver@savarigo.com' : 'passenger@savarigo.com';
          _passCtrl.text  = '123456';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700,
              color: active ? AppColors.black : AppColors.textMuted)),
      ),
    ));
  }
}
