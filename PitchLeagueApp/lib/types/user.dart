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

class CreateUser {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final String password;

  CreateUser({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory CreateUser.fromJson(Map<String, dynamic> json) {
    return CreateUser(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }
}