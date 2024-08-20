class Team {
  final int id;
  final String name;
  final int captainId;
  final Captain captain;

  Team({
    required this.id,
    required this.name,
    required this.captainId,
    required this.captain,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['ID'],
      name: json['Name'],
      captainId: json['CaptainID'],
      captain: Captain.fromJson(json['Captain']),
    );
  }
}

class Captain {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final int role;

  Captain({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory Captain.fromJson(Map<String, dynamic> json) {
    return Captain(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
