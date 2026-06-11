// services/ride_service.dart
// SavariGo - Ride Booking & Management Service

import 'supabase_service.dart';

class RideService {
  RideService._();

  static Future<Map<String, dynamic>> bookRide({
    required String passengerId,
    required String pickupLocation,
    required String dropLocation,
    required bool womenOnly,
    required int seatsRequired,
    required int totalFare,
    required int farePerPerson,
  }) async {
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      try {
        final data = await SupabaseService.client.from('rides').insert({
          'passenger_id':    passengerId,
          'pickup_location': pickupLocation,
          'drop_location':   dropLocation,
          'women_only':      womenOnly,
          'status':          'searching',
          'total_fare':      totalFare,
          'fare_per_person': farePerPerson,
          'seats_required':  seatsRequired,
          'ride_type':       'shared',
          'ride_time':       DateTime.now().toIso8601String(),
        }).select().single();
        return {'success': true, 'ride': data};
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    }
    // Demo mode
    return {'success': true, 'ride': {'id': 'demo-ride-001', 'status': 'searching'}};
  }

  static Future<List<Map<String, dynamic>>> getRideHistory(String passengerId) async {
    if (SupabaseService.supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL') {
      try {
        final data = await SupabaseService.client
            .from('rides')
            .select()
            .eq('passenger_id', passengerId)
            .order('created_at', ascending: false);
        return List<Map<String, dynamic>>.from(data);
      } catch (_) {}
    }
    return _sampleHistory;
  }

  static final List<Map<String, dynamic>> _sampleHistory = [
    {'pickup_location':'Tambaram',  'drop_location':'Guindy',     'fare_per_person':60, 'status':'completed', 'women_only':false, 'created_at':'2024-01-15'},
    {'pickup_location':'T Nagar',   'drop_location':'Velachery',  'fare_per_person':55, 'status':'completed', 'women_only':true,  'created_at':'2024-01-14'},
    {'pickup_location':'Koyambedu', 'drop_location':'Porur',      'fare_per_person':40, 'status':'completed', 'women_only':false, 'created_at':'2024-01-13'},
    {'pickup_location':'Adyar',     'drop_location':'Egmore',     'fare_per_person':70, 'status':'cancelled', 'women_only':false, 'created_at':'2024-01-12'},
  ];
}
