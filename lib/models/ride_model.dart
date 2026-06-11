// models/ride_model.dart
class RideModel {
  final String id;
  final String pickupLocation;
  final String dropLocation;
  final String status;
  final bool womenOnly;
  final int farePerPerson;
  final int totalFare;
  final int seatsRequired;
  final String rideType;
  final DateTime? createdAt;

  const RideModel({
    required this.id, required this.pickupLocation, required this.dropLocation,
    required this.status, required this.womenOnly, required this.farePerPerson,
    required this.totalFare, required this.seatsRequired, required this.rideType,
    this.createdAt,
  });

  factory RideModel.fromMap(Map<String, dynamic> m) => RideModel(
    id:              m['id'] ?? '',
    pickupLocation:  m['pickup_location'] ?? '',
    dropLocation:    m['drop_location'] ?? '',
    status:          m['status'] ?? 'searching',
    womenOnly:       m['women_only'] ?? false,
    farePerPerson:   (m['fare_per_person'] ?? 0).toInt(),
    totalFare:       (m['total_fare'] ?? 0).toInt(),
    seatsRequired:   m['seats_required'] ?? 1,
    rideType:        m['ride_type'] ?? 'shared',
    createdAt:       m['created_at'] != null ? DateTime.tryParse(m['created_at']) : null,
  );
}
