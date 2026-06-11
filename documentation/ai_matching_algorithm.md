# 🤖 SavariGo Flutter — AI Matching Algorithm

## Overview

SavariGo uses a **rule-based AI scoring algorithm** written in Dart to match passengers sharing auto-rickshaw rides. A compatibility score (0–100) is calculated for any two ride requests. Scores ≥ 70 are shown as valid pool matches.

## File Location
```
lib/services/ai_matching_service.dart
```

## Scoring Breakdown (100 points total)

| Criterion | Max Points | Logic |
|---|---|---|
| Pickup location similarity | 25 | Haversine distance between pickup GPS points |
| Drop location similarity | 25 | Haversine distance between drop GPS points |
| Travel time similarity | 20 | Difference in requested ride times |
| Gender / Women-Only compatibility | 20 | Checks women_only preference and gender |
| Seat availability | 10 | Total seats must not exceed 3 (auto capacity) |

## Scoring Rules

### Pickup Similarity (0–25 pts)
```dart
if (distance <= 0.3 km) → 25 pts  // Same stop
if (distance <= 0.5 km) → 20 pts  // Very close
if (distance <= 1.0 km) → 10 pts  // Acceptable
if (distance >  1.0 km) →  0 pts  // Too far
```

### Drop Similarity (0–25 pts)
```dart
if (distance <= 0.5 km) → 25 pts
if (distance <= 1.0 km) → 20 pts
if (distance <= 2.0 km) → 10 pts
if (distance >  2.0 km) →  0 pts
```

### Time Similarity (0–20 pts)
```dart
if (diff ≤  5 min) → 20 pts  // Same time window
if (diff ≤ 10 min) → 15 pts
if (diff ≤ 15 min) → 10 pts
if (diff ≤ 20 min) →  5 pts
if (diff >  20 min) →  0 pts
```

### Gender / Women-Only Compatibility (0–20 pts)
```dart
if (either ride has womenOnly = true):
    both must be female → 20 pts
    else                → 0 pts  // NEVER match
else:
    no restriction      → 20 pts
```

### Seat Availability (0–10 pts)
```dart
if (seats1 + seats2 <= 3) → 10 pts  // Auto fits all
else                       →  0 pts  // Overcrowded
```

## Match Decision
- Score ≥ 70 → ✅ Good Pool Match — shown to passengers
- Score 50–69 → ⚠️ Partial Match
- Score < 50 → ❌ No Match — search continues

## Dart Implementation (Key Method)
```dart
static MatchResult findBestMatch({
  required String pickupLocation,
  required String dropLocation,
  required bool womenOnly,
  required String gender,
  required int seatsRequired,
  int totalFare = 150,
})
```

## Example Output
```json
{
  "matchScore": 92,
  "matchedPassengerName": "Nadhiya R",
  "estimatedFarePerPerson": 45,
  "savings": 90,
  "message": "Pool match found! Score: 92/100 🎉"
}
```

## Distance Formula (Haversine)
Used to calculate real-world distance between two GPS coordinates:
```dart
static double _distance(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0; // Earth radius in km
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a = sin(dLat/2)*sin(dLat/2) +
      cos(lat1*pi/180)*cos(lat2*pi/180)*sin(dLng/2)*sin(dLng/2);
  return r * 2 * atan2(sqrt(a), sqrt(1-a));
}
```
