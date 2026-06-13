import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  bool _hidePassword = true;

  static const Color yellow = Color(0xFFFFCC00);
  static const Color black = Color(0xFF1A1A1A);
  static const Color bg = Color(0xFFF5F5F5);

  // After login/register, it will go directly to Book Ride page
  static const String nextRoute = '/passenger/book-ride';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!_isLogin && name.isEmpty) {
      _showMessage('Please enter your full name', error: true);
      return false;
    }

    if (!_isLogin && phone.length < 10) {
      _showMessage('Please enter a valid phone number', error: true);
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Please enter a valid email address', error: true);
      return false;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters', error: true);
      return false;
    }

    return true;
  }

  Future<void> _login() async {
    if (!_validate()) return;

    setState(() => _loading = true);

    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      _showMessage('Login successful');
      Navigator.pushReplacementNamed(context, nextRoute);
    } on AuthException catch (e) {
      _showMessage(e.message, error: true);
    } catch (_) {
      _showMessage('Login failed. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    if (!_validate()) return;

    setState(() => _loading = true);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'role': 'passenger',
        },
      );

      final user = response.user;

      if (user != null) {
        try {
          await _supabase.from('users').upsert({
            'id': user.id,
            'name': name,
            'email': email,
            'phone': phone,
            'role': 'passenger',
          });
        } catch (_) {
          // If table columns are different, ignore for demo.
        }
      }

      if (!mounted) return;

      _showMessage('Registration successful');
      Navigator.pushReplacementNamed(context, nextRoute);
    } on AuthException catch (e) {
      _showMessage(e.message, error: true);
    } catch (_) {
      _showMessage('Registration failed. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _submit() {
    if (_isLogin) {
      _login();
    } else {
      _register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              height: double.infinity,
              color: yellow,
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.local_taxi,
                          color: yellow,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'SavariGo',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: black,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Text(
                    'Share Auto.\nSave Money.\nTravel Safe.',
                    style: TextStyle(
                      fontSize: 46,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'AI-Based Shared Auto-Rickshaw Pooling System\nfor Chennai and Semi-Urban India',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 36),

                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: const [
                      FeatureChip(icon: Icons.groups, text: 'AI Pool Matching'),
                      FeatureChip(icon: Icons.woman, text: 'Women-Only Mode'),
                      FeatureChip(icon: Icons.location_on, text: 'GPS Tracking'),
                      FeatureChip(icon: Icons.payment, text: 'Easy Payment'),
                      FeatureChip(icon: Icons.sos, text: 'SOS Safety'),
                    ],
                  ),

                  const Spacer(),

                  const Text(
                    'Designed for students, office workers and daily passengers.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Container(
                  width: 440,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 22,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.local_taxi,
                              color: black,
                              size: 46,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        _isLogin ? 'Welcome Back!' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _isLogin
                            ? 'Login to book and track your shared auto'
                            : 'Register with your name, email and phone number',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            _toggleButton('Login', true),
                            _toggleButton('Register', false),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (!_isLogin) ...[
                        _inputField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 14),
                        _inputField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter mobile number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                      ],

                      _inputField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'Enter email address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 14),

                      TextField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellow,
                            foregroundColor: black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: black,
                                  ),
                                )
                              : Text(
                                  _isLogin
                                      ? 'Login to SavariGo'
                                      : 'Register Now',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? "New user? Create an account"
                              : "Already registered? Login here",
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: yellow.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _isLogin
                              ? 'Use your registered email and password to continue.'
                              : 'Your name, email and phone number will be saved securely for ride booking.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool loginValue) {
    final selected = _isLogin == loginValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLogin = loginValue;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? yellow : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: black,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Color(0xFF1A1A1A)),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}