// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String salt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.salt,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? salt,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      salt: salt ?? this.salt,
    );
  }
}
