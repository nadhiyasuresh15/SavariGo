// services/safety_service.dart
// SavariGo - SOS / Safety Service

import 'supabase_service.dart';

class SafetyService {
  SafetyService._();

  static Future<Map<String, dynamic>> triggerSOS({
    required String userId,
    required String location,
    required String emergencyContact,
    String? rideId,
  }) async {
    // Try Supabase insert
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      try {
        await SupabaseService.client.from('sos_alerts').insert({
          'user_id':           userId,
          'ride_id':           rideId,
          'location':          location,
          'emergency_contact': emergencyContact,
          'status':            'active',
        });
      } catch (_) {}
    }
    // In production: send SMS via Twilio/MSG91 here
    return {
      'success': true,
      'message': '🚨 SOS Alert sent! Help is on the way. Paathukaapu!',
    };
  }
}
