// models/match_model.dart
class MatchModel {
  final String rideId;
  final int matchScore;
  final String matchedPassengerName;
  final int farePerPerson;
  final int savings;

  const MatchModel({
    required this.rideId, required this.matchScore,
    required this.matchedPassengerName, required this.farePerPerson,
    required this.savings,
  });
}
