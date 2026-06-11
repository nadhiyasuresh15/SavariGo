// models/passenger_model.dart
class PassengerModel {
  final String id;
  final String userId;
  final String preferredLanguage;
  final bool womenOnlyEnabled;
  final String? trustedContact;
  final int greenPoints;

  const PassengerModel({
    required this.id, required this.userId, required this.preferredLanguage,
    required this.womenOnlyEnabled, this.trustedContact, required this.greenPoints,
  });

  factory PassengerModel.fromMap(Map<String, dynamic> m) => PassengerModel(
    id: m['id'] ?? '', userId: m['user_id'] ?? '',
    preferredLanguage: m['preferred_language'] ?? 'Tamil',
    womenOnlyEnabled: m['women_only_enabled'] ?? false,
    trustedContact: m['trusted_contact'],
    greenPoints: m['green_points'] ?? 0,
  );
}
