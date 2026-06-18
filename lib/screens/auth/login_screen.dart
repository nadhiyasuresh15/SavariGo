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
  final TextEditingController _driverCodeController = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  bool _hidePassword = true;

  String _selectedRole = 'passenger';

  static const Color yellow = Color(0xFFFFCC00);
  static const Color black = Color(0xFF1A1A1A);
  static const Color bg = Color(0xFFF5F5F5);

  static const String driverCode = 'DRIVER123';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _driverCodeController.dispose();
    super.dispose();
  }

  String _roleTitle(String role) {
    if (role == 'passenger') return 'Passenger';
    if (role == 'driver') return 'Driver';
    return 'Admin';
  }

  IconData _roleIcon(String role) {
    if (role == 'passenger') return Icons.person;
    if (role == 'driver') return Icons.local_taxi;
    return Icons.admin_panel_settings;
  }

  String _routeForRole(String role) {
    if (role == 'driver') {
      return '/driver/dashboard';
    } else if (role == 'admin') {
      return '/admin/dashboard';
    } else {
      return '/passenger/book-ride';
    }
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
    final code = _driverCodeController.text.trim();

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

    if (!_isLogin && _selectedRole == 'driver' && code != driverCode) {
      _showMessage('Invalid driver registration code', error: true);
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

      _showMessage('${_roleTitle(_selectedRole)} login successful');

      Navigator.pushReplacementNamed(
        context,
        _routeForRole(_selectedRole),
      );
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
    final role = _selectedRole;

    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'role': role,
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
            'role': role,
          });
        } catch (_) {}
      }

      if (!mounted) return;

      _showMessage('${_roleTitle(role)} registration successful');

      Navigator.pushReplacementNamed(
        context,
        _routeForRole(role),
      );
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
                    'AI-Based Shared Auto-Rickshaw Pooling System\nfor Passenger, Driver and Admin Users',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 36),

                  const Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      FeatureChip(icon: Icons.person, text: 'Passenger Booking'),
                      FeatureChip(icon: Icons.local_taxi, text: 'Driver Panel'),
                      FeatureChip(icon: Icons.admin_panel_settings, text: 'Admin Panel'),
                      FeatureChip(icon: Icons.groups, text: 'AI Pool Matching'),
                      FeatureChip(icon: Icons.location_on, text: 'GPS Tracking'),
                      FeatureChip(icon: Icons.sos, text: 'SOS Safety'),
                    ],
                  ),

                  const Spacer(),

                  const Text(
                    'One platform for passengers, drivers and administrators.',
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
                  width: 460,
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
                            ? 'Login as Passenger, Driver or Admin'
                            : 'Register as Passenger or Driver',
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

                      const SizedBox(height: 22),

                      _roleDropdown(),

                      const SizedBox(height: 14),

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

                      if (!_isLogin && _selectedRole == 'driver') ...[
                        const SizedBox(height: 14),
                        _inputField(
                          controller: _driverCodeController,
                          label: 'Driver Registration Code',
                          hint: 'Enter DRIVER123',
                          icon: Icons.key,
                        ),
                      ],

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
                                      ? 'Login as ${_roleTitle(_selectedRole)}'
                                      : 'Register as ${_roleTitle(_selectedRole)}',
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
                            if (!_isLogin && _selectedRole == 'admin') {
                              _selectedRole = 'passenger';
                            }
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
                          color: yellow.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _isLogin
                              ? 'Admin is a fixed account. Only Passenger and Driver can register.'
                              : _selectedRole == 'passenger'
                                  ? 'Passenger can book rides and track shared autos.'
                                  : 'Driver registration code for demo: DRIVER123',
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

  Widget _roleDropdown() {
    final items = _isLogin
        ? const [
            DropdownMenuItem(
              value: 'passenger',
              child: Text('Passenger / User'),
            ),
            DropdownMenuItem(
              value: 'driver',
              child: Text('Driver'),
            ),
            DropdownMenuItem(
              value: 'admin',
              child: Text('Admin'),
            ),
          ]
        : const [
            DropdownMenuItem(
              value: 'passenger',
              child: Text('Passenger / User'),
            ),
            DropdownMenuItem(
              value: 'driver',
              child: Text('Driver'),
            ),
          ];

    return DropdownButtonFormField<String>(
      initialValue: _selectedRole,
      decoration: InputDecoration(
        labelText: _isLogin ? 'Login Role' : 'Register Role',
        prefixIcon: Icon(_roleIcon(_selectedRole)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      items: items,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedRole = value;
          _driverCodeController.clear();
        });
      },
    );
  }

  Widget _toggleButton(String text, bool loginValue) {
    final selected = _isLogin == loginValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLogin = loginValue;
            if (!_isLogin && _selectedRole == 'admin') {
              _selectedRole = 'passenger';
            }
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
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1A1A1A)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}