// models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String role;
  final DateTime? createdAt;

  const UserModel({
    required this.id, required this.name, required this.email,
    required this.phone, required this.gender, required this.role,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    id: m['id'] ?? '', name: m['name'] ?? '', email: m['email'] ?? '',
    phone: m['phone'] ?? '', gender: m['gender'] ?? '',
    role: m['role'] ?? 'passenger',
    createdAt: m['created_at'] != null ? DateTime.tryParse(m['created_at']) : null,
  );
}
