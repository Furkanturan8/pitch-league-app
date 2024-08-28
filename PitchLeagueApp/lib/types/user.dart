class User {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final String role;
  final int teamID;

  User({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.teamID,
  });

// Profil güncelleme işlemlerinde teamID'yi hariç tutarak güncellenmiş bir User oluştur
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  // Kullanıcı bilgilerini almak için kullanılır
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      teamID: json['team_id'],
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

class ListUser {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final int teamID;

  ListUser({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.teamID,
  });

  // Profil güncelleme işlemlerinde teamID'yi hariç tutarak güncellenmiş bir ListUser oluştur
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  // Kullanıcı bilgilerini almak için kullanılır
  factory ListUser.fromJson(Map<String, dynamic> json) {
    return ListUser(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      teamID: json['team_id'],
    );
  }
}
