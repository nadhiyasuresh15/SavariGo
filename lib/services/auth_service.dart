// services/auth_service.dart
// SavariGo - Authentication Service (Supabase Auth + Demo fallback)

import 'supabase_service.dart';

class AuthService {
  AuthService._();

  // ── Demo credentials for college demo when Supabase is not connected ──
  static const Map<String, Map<String, String>> _demoUsers = {
    'passenger@savarigo.com': {'password': '123456',   'role': 'passenger', 'name': 'Arjun Kumar'},
    'priya@savarigo.com':     {'password': '123456',   'role': 'passenger', 'name': 'Priya Sharma'},
    'driver@savarigo.com':    {'password': '123456',   'role': 'driver',    'name': 'Ravi Auto'},
    'admin@savarigo.com':     {'password': 'admin123', 'role': 'admin',     'name': 'Admin User'},
  };

  static Map<String, dynamic>? _currentDemoUser;

  /// Login — tries Supabase first, falls back to demo credentials
  static Future<Map<String, dynamic>> login(String email, String password) async {
    // Try Supabase Auth first (if credentials are configured)
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      try {
        final response = await SupabaseService.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (response.user != null) {
          // Fetch profile from users table
          final profile = await SupabaseService.client
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();
          return {'success': true, 'user': profile};
        }
      } catch (_) {
        // Fall through to demo login
      }
    }

    // Demo login fallback
    final demo = _demoUsers[email.toLowerCase()];
    if (demo != null && demo['password'] == password) {
      _currentDemoUser = {
        'id':    'demo-${email.hashCode}',
        'email': email,
        'name':  demo['name'],
        'role':  demo['role'],
        'gender': email == 'priya@savarigo.com' ? 'female' : 'male',
        'phone': '9876543210',
        'green_points': 30,
      };
      return {'success': true, 'user': _currentDemoUser};
    }
    return {'success': false, 'error': 'Invalid email or password'};
  }

  /// Register new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String role,
  }) async {
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      try {
        final response = await SupabaseService.auth.signUp(
          email: email,
          password: password,
        );
        if (response.user != null) {
          await SupabaseService.client.from('users').insert({
            'id': response.user!.id,
            'name': name, 'email': email, 'phone': phone,
            'gender': gender, 'role': role,
          });
          if (role == 'passenger') {
            final p = await SupabaseService.client
                .from('passengers').select('id').eq('user_id', response.user!.id).maybeSingle();
            if (p == null) {
              await SupabaseService.client.from('passengers').insert({
                'user_id': response.user!.id,
                'preferred_language': 'Tamil',
                'women_only_enabled': false,
                'green_points': 0,
              });
            }
          }
          return {'success': true, 'message': 'Account created!'};
        }
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    }
    return {'success': true, 'message': 'Demo account created! Use demo login.'};
  }

  /// Get current logged-in user (demo or Supabase)
  static Map<String, dynamic>? get currentUser {
    if (_currentDemoUser != null) return _currentDemoUser;
    final user = SupabaseService.auth.currentUser;
    if (user != null) return {'id': user.id, 'email': user.email};
    return null;
  }

  /// Logout
  static Future<void> logout() async {
    _currentDemoUser = null;
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      await SupabaseService.auth.signOut();
    }
  }
}
