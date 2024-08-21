class Team {
  final int id;
  final String name;
  final int capacity;
  final int captainId;
  final Captain captain;

  Team({
    required this.id,
    required this.name,
    required this.capacity,
    required this.captainId,
    required this.captain,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['ID'],
      name: json['Name'],
      capacity: json['Capacity'] , // Varsayılan değer 0 olarak ayarlandı
      captainId: json['CaptainID'],
      captain: Captain.fromJson(json['Captain']),
    );
  }
}

class Captain {
  final String Name;
  final String Surname;
  final String Username;
  final String Phone;

  Captain({
    required this.Name,
    required this.Surname,
    required this.Username,
    required this.Phone
  });

  factory Captain.fromJson(Map<String, dynamic> json) {
    return Captain(
      Name: json['name'],
      Surname: json['surname'],
      Username: json['username'],
      Phone: json['phone'],
    );
  }
}