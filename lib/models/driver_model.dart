// models/driver_model.dart
class DriverModel {
  final String id;
  final String userId;
  final String vehicleNumber;
  final String licenseNumber;
  final String verificationStatus;
  final int trustScore;
  final String availabilityStatus;

  const DriverModel({
    required this.id, required this.userId, required this.vehicleNumber,
    required this.licenseNumber, required this.verificationStatus,
    required this.trustScore, required this.availabilityStatus,
  });

  factory DriverModel.fromMap(Map<String, dynamic> m) => DriverModel(
    id: m['id'] ?? '', userId: m['user_id'] ?? '',
    vehicleNumber: m['vehicle_number'] ?? '', licenseNumber: m['license_number'] ?? '',
    verificationStatus: m['verification_status'] ?? 'pending',
    trustScore: m['trust_score'] ?? 0, availabilityStatus: m['availability_status'] ?? 'offline',
  );
}
