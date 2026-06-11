// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  String _gender   = 'male';
  String _role     = 'passenger';
  bool _loading    = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final res = await AuthService.register(
      name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(), phone: _phoneCtrl.text.trim(),
      gender: _gender, role: _role,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (res['success'] == true) {
      Helpers.showSnack(context, 'Account created! Please login.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Helpers.showSnack(context, res['error'] ?? 'Registration failed', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(child: Column(children: [
        Container(
          width: double.infinity, color: AppColors.yellow,
          padding: const EdgeInsets.fromLTRB(0, 56, 0, 24),
          child: Column(children: [
            Image.asset('assets/images/logo.png', width: 80, height: 80),
            const SizedBox(height: 8),
            const Text('Create Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const Text('Join SavariGo — Share Auto, Save More!',
                style: TextStyle(fontSize: 12, color: AppColors.black)),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [
          CustomTextField(label: 'Full Name *', hint: 'e.g. Arjun Kumar',
              controller: _nameCtrl, prefixIcon: Icons.person_outline,
              validator: (v) => Validators.required(v, 'Name')),
          const SizedBox(height: 14),
          CustomTextField(label: 'Email *', hint: 'your@email.com',
              controller: _emailCtrl, keyboard: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined, validator: Validators.email),
          const SizedBox(height: 14),
          CustomTextField(label: 'Phone', hint: '9876543210',
              controller: _phoneCtrl, keyboard: TextInputType.phone,
              prefixIcon: Icons.phone_outlined, validator: Validators.phone),
          const SizedBox(height: 14),
          CustomTextField(label: 'Password *', hint: 'Min 6 characters',
              controller: _passCtrl, obscure: true,
              prefixIcon: Icons.lock_outline, validator: Validators.password),
          const SizedBox(height: 16),

          // Gender selector
          Align(alignment: Alignment.centerLeft,
              child: const Text('Gender', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final g in ['male', 'female', 'other'])
              ChoiceChip(
                label: Text(g == 'male' ? '👨 Male' : g == 'female' ? '👩 Female' : '⚧ Other'),
                selected: _gender == g, onSelected: (_) => setState(() => _gender = g),
                selectedColor: AppColors.yellow,
              ),
          ]),
          const SizedBox(height: 14),

          // Role selector
          Align(alignment: Alignment.centerLeft,
              child: const Text('I am a...', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final r in ['passenger', 'driver'])
              ChoiceChip(
                label: Text(r == 'passenger' ? '🧍 Passenger' : '🚖 Driver'),
                selected: _role == r, onSelected: (_) => setState(() => _role = r),
                selectedColor: AppColors.yellow,
              ),
          ]),
          const SizedBox(height: 14),

          // Women-only notice
          if (_gender == 'female')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(10),
                border: Border(left: const BorderSide(color: AppColors.pink, width: 4)),
              ),
              child: const Text('👩 Pengal mattum mode available after login\nWomen-Only pooling mode will be enabled for you.',
                  style: TextStyle(fontSize: 12, color: AppColors.pink)),
            ),
          const SizedBox(height: 22),

          CustomButton(label: 'Create Account 🚀', onPressed: _register, loading: _loading),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('Already have an account? Login',
                style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
          ),
        ]))),
      ])),
    );
  }
}
