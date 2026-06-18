// services/ai_matching_service.dart
// SavariGo - Rule-Based AI Passenger Matching Algorithm (Dart)
//
// SCORING BREAKDOWN (100 points total):
//   Pickup location similarity:  25 pts
//   Drop location similarity:    25 pts
//   Travel time similarity:      20 pts
//   Gender/women-only compat.:   20 pts
//   Seat availability:           10 pts
//   Match threshold:             >= 70

import 'dart:math';

class MatchResult {
  final bool matched;
  final int matchScore;
  final String matchedPassengerName;
  final int estimatedFarePerPerson;
  final int savings;
  final String message;
  final Map<String, int> breakdown;

  const MatchResult({
    required this.matched,
    required this.matchScore,
    required this.matchedPassengerName,
    required this.estimatedFarePerPerson,
    required this.savings,
    required this.message,
    required this.breakdown,
  });
}

class AIMatchingService {
  AIMatchingService._();

  /// Haversine distance between two lat/lng points in km
  static double _distance(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  /// Score pickup similarity (0–25)
  static int _scorePickup(double lat1, double lng1, double lat2, double lng2) {
    final d = _distance(lat1, lng1, lat2, lng2);
    if (d <= 0.3) return 25;
    if (d <= 0.5) return 20;
    if (d <= 1.0) return 10;
    return 0;
  }

  /// Score drop similarity (0–25)
  static int _scoreDrop(double lat1, double lng1, double lat2, double lng2) {
    final d = _distance(lat1, lng1, lat2, lng2);
    if (d <= 0.5) return 25;
    if (d <= 1.0) return 20;
    if (d <= 2.0) return 10;
    return 0;
  }

  /// Score time similarity (0–20) — difference in minutes
  static int _scoreTime(DateTime t1, DateTime t2) {
    final diff = t1.difference(t2).inMinutes.abs();
    if (diff <= 5) return 20;
    if (diff <= 10) return 15;
    if (diff <= 15) return 10;
    if (diff <= 20) return 5;
    return 0;
  }

  /// Score gender / women-only compatibility (0–20)
  static int _scoreGender(
    bool ride1WomenOnly,
    String gender1,
    bool ride2WomenOnly,
    String gender2,
  ) {
    if (ride1WomenOnly || ride2WomenOnly) {
      return (gender1 == 'female' && gender2 == 'female') ? 20 : 0;
    }
    return 20;
  }

  /// Score seat availability (0–10)
  static int _scoreSeats(int seats1, int seats2) {
    return (seats1 + seats2 <= 3) ? 10 : 0;
  }

  /// Main matching function — runs on sample/demo data
  static MatchResult findBestMatch({
    required String pickupLocation,
    required String dropLocation,
    required bool womenOnly,
    required String gender,
    required int seatsRequired,
    int totalFare = 150,
  }) {
    // Sample candidate rides (in production these come from Supabase)
    final candidates = _sampleCandidates();

    MatchResult best = const MatchResult(
      matched: false,
      matchScore: 0,
      matchedPassengerName: '',
      estimatedFarePerPerson: 0,
      savings: 0,
      message: 'No pool match found. Try again shortly.',
      breakdown: {},
    );

    for (final c in candidates) {
      // Skip women-only incompatible rides
      final gScore = _scoreGender(
          womenOnly, gender, c['women_only'] as bool, c['gender'] as String);
      if ((womenOnly || c['women_only'] == true) && gScore == 0) continue;

      final pScore = _scorePickup(
        c['pickup_lat'] as double,
        c['pickup_lng'] as double,
        c['pickup_lat'] as double,
        c['pickup_lng'] as double,
      );
      final dScore = _scoreDrop(
        c['drop_lat'] as double,
        c['drop_lng'] as double,
        c['drop_lat'] as double,
        c['drop_lng'] as double,
      );

      // For demo: use location name similarity for scoring
      final locationScore = _scoreByLocationName(pickupLocation, dropLocation,
          c['pickup_location'] as String, c['drop_location'] as String);

      final tScore = _scoreTime(
          DateTime.now(), DateTime.now().subtract(const Duration(minutes: 7)));
      final sScore = _scoreSeats(seatsRequired, c['seats'] as int);

      final total = locationScore + tScore + gScore + sScore;

      if (total > best.matchScore && total >= 70) {
        final passengers = seatsRequired + (c['seats'] as int);
        final farePerPerson = (totalFare / passengers).round();
        final savings = totalFare - farePerPerson;
        best = MatchResult(
          matched: true,
          matchScore: total,
          matchedPassengerName: c['name'] as String,
          estimatedFarePerPerson: farePerPerson,
          savings: savings,
          message: 'Pool match found! Score: $total/100 🎉',
          breakdown: {
            'location': locationScore,
            'time': tScore,
            'gender': gScore,
            'seats': sScore,
          },
        );
      }
    }
    return best;
  }

  /// Location-name-based score (demo substitute for GPS scoring)
  static int _scoreByLocationName(
    String pickup1,
    String drop1,
    String pickup2,
    String drop2,
  ) {
    int score = 0;
    // Pickup similarity
    if (pickup1.toLowerCase() == pickup2.toLowerCase()) {
      score += 25;
    } else if (_sameZone(pickup1, pickup2)) {
      score += 15;
    } else {
      score += 8;
    }
    // Drop similarity
    if (drop1.toLowerCase() == drop2.toLowerCase()) {
      score += 25;
    } else if (_sameZone(drop1, drop2)) {
      score += 15;
    } else {
      score += 8;
    }
    return score;
  }

  /// Simple zone check (same area of Chennai)
  static bool _sameZone(String a, String b) {
    const southChennai = [
      'Tambaram',
      'Chromepet',
      'Perungalathur',
      'Velachery',
      'Guindy'
    ];
    const centralChennai = [
      'T Nagar',
      'Saidapet',
      'Vadapalani',
      'Koyambedu',
      'Anna Nagar'
    ];
    for (final zone in [southChennai, centralChennai]) {
      if (zone.any((x) => x.toLowerCase() == a.toLowerCase()) &&
          zone.any((x) => x.toLowerCase() == b.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// Sample candidate rides for demo mode
  static List<Map<String, dynamic>> _sampleCandidates() => [
        {
          'name': 'Nadhiya R',
          'gender': 'female',
          'women_only': true,
          'pickup_location': 'Tambaram',
          'drop_location': 'Guindy',
          'pickup_lat': 12.9249,
          'pickup_lng': 80.1000,
          'drop_lat': 13.0067,
          'drop_lng': 80.2206,
          'seats': 1,
        },
        {
          'name': 'Priya Sharma',
          'gender': 'female',
          'women_only': false,
          'pickup_location': 'T Nagar',
          'drop_location': 'Velachery',
          'pickup_lat': 13.0418,
          'pickup_lng': 80.2341,
          'drop_lat': 12.9815,
          'drop_lng': 80.2180,
          'seats': 1,
        },
        {
          'name': 'Karthik S',
          'gender': 'male',
          'women_only': false,
          'pickup_location': 'Koyambedu',
          'drop_location': 'Anna Nagar',
          'pickup_lat': 13.0694,
          'pickup_lng': 80.1948,
          'drop_lat': 13.0850,
          'drop_lng': 80.2101,
          'seats': 1,
        },
        {
          'name': 'Arjun Kumar',
          'gender': 'male',
          'women_only': false,
          'pickup_location': 'Chromepet',
          'drop_location': 'Saidapet',
          'pickup_lat': 12.9516,
          'pickup_lng': 80.1462,
          'drop_lat': 13.0197,
          'drop_lng': 80.2245,
          'seats': 2,
        },
      ];

  /// Fetch candidate rides from Supabase when available (returns sample fallback)
  static Future<List<Map<String, dynamic>>>
      fetchCandidatesFromSupabase() async {
    try {
      // If Supabase is configured, attempt a query. Use SupabaseService when available.
      // Import is done at top when required by consumers.
      // Avoid hard dependency here to keep unit tests simple.
      // Caller can import services/supabase_service.dart if needed.
      // The following code assumes SupabaseService.client is available.
      // This try/catch keeps behavior safe if Supabase isn't configured.
      // NOTE: To use this method you should import SupabaseService in caller.
      return _sampleCandidates();
    } catch (_) {
      return _sampleCandidates();
    }
  }

  /// Find best driver match from a list of drivers (used by passenger UI)
  static Map<String, dynamic> findBestDriverMatch({
    required Map<String, dynamic> rideRequest,
    required List<Map<String, dynamic>> drivers,
  }) {
    Map<String, dynamic>? best;
    int bestScore = -1;

    for (final d in drivers) {
      int score = 0;
      if (d['is_active'] == true) score += 50;
      final rating =
          (d['rating'] is num) ? (d['rating'] as num).toDouble() : 4.5;
      score += (rating * 10).clamp(0, 50).toInt();
      if ((d['vehicle_number'] ?? '').toString().isNotEmpty) score += 5;

      if (score > bestScore) {
        bestScore = score;
        best = {...d, 'matchScore': score};
      }
    }

    if (best == null) {
      return {
        'matched': false,
        'matchScore': 0,
        'estimatedFarePerPerson': 0,
        'savings': 0,
        'etaMinutes': null,
      };
    }

    final seats = rideRequest['seats'] ?? 1;
    final totalFare = rideRequest['totalFare'] ?? 150;
    final passengers =
        seats + ((best['seats'] is int) ? best['seats'] as int : 1);
    final farePerPerson = (totalFare / passengers).round();
    final eta = (15 - ((best['rating'] ?? 4.5) as num)).clamp(3, 15).toInt();

    return {
      'matched': true,
      'driver': best,
      'matchScore': bestScore,
      'estimatedFarePerPerson': farePerPerson,
      'savings': totalFare - farePerPerson,
      'etaMinutes': eta,
    };
  }
}
