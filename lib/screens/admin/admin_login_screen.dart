// screens/admin/admin_login_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@savarigo.com');
  final _passCtrl  = TextEditingController(text: 'admin123');
  bool _loading    = false;

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _loading = false);
      if (_emailCtrl.text == 'admin@savarigo.com' && _passCtrl.text == 'admin123') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid credentials. Use admin@savarigo.com / admin123'),
          backgroundColor: AppColors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(child: SingleChildScrollView(child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)],
        ),
        child: Form(key: _formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/images/logo.png', width: 90, height: 90),
          const SizedBox(height: 12),
          const Text('SavariGo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const Text('Admin Panel · Vanakkam 🙏',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 24),

          CustomTextField(label: 'Admin Email', hint: 'admin@savarigo.com',
              controller: _emailCtrl, prefixIcon: Icons.admin_panel_settings,
              keyboard: TextInputType.emailAddress, validator: Validators.email),
          const SizedBox(height: 14),
          CustomTextField(label: 'Password', hint: '••••••',
              controller: _passCtrl, obscure: true,
              prefixIcon: Icons.lock_outline, validator: Validators.password),
          const SizedBox(height: 12),

          Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(8)),
            child: const Text('Demo: admin@savarigo.com / admin123',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          CustomButton(label: 'Login to Admin Panel 🚀', onPressed: _login, loading: _loading),
        ])),
      ))),
    );
  }
}
