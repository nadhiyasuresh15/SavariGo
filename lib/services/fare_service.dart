// services/fare_service.dart
// SavariGo - Fare Calculation Logic

class FareResult {
  final int totalFare;
  final int farePerPerson;
  final int savings;
  final int savingsPercent;
  final int numPassengers;
  final double distanceKm;
  final bool isPeakHour;

  const FareResult({
    required this.totalFare,
    required this.farePerPerson,
    required this.savings,
    required this.savingsPercent,
    required this.numPassengers,
    required this.distanceKm,
    required this.isPeakHour,
  });
}

class FareService {
  FareService._();

  static const int baseFare     = 30;   // ₹ for first 1.5 km
  static const double baseKm    = 1.5;  // km covered by base fare
  static const int perKmRate    = 15;   // ₹ per km after base
  static const double peakMult  = 1.2;  // 20% peak surge

  /// Check if current time is peak hour
  static bool get isPeakHour {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
    final isWeekday = weekday >= 1 && weekday <= 5;
    return isWeekday && ((hour >= 8 && hour <= 10) || (hour >= 17 && hour <= 20));
  }

  /// Calculate total fare for a given distance
  static int calculateTotal(double distanceKm) {
    int fare = baseFare;
    if (distanceKm > baseKm) {
      fare += ((distanceKm - baseKm) * perKmRate).round();
    }
    if (isPeakHour) fare = (fare * peakMult).round();
    return fare;
  }

  /// Full fare calculation with splitting
  static FareResult calculate(double distanceKm, int numPassengers) {
    final total = calculateTotal(distanceKm);
    final perPerson = (total / numPassengers).round();
    final savings = total - perPerson;
    final pct = ((savings / total) * 100).round();
    return FareResult(
      totalFare:      total,
      farePerPerson:  perPerson,
      savings:        savings,
      savingsPercent: pct,
      numPassengers:  numPassengers,
      distanceKm:     distanceKm,
      isPeakHour:     isPeakHour,
    );
  }
}
