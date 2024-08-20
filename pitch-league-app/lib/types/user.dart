// lib/types/models.dart

class User {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final String role;

  User({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
