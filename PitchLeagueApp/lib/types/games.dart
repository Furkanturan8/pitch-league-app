
class Games {
  final int gameID;
  final int userID;
  final int teamID;
  final GameDetails game;
  final TeamDetails team;
  final UserDetails user;

  Games({
    required this.gameID,
    required this.userID,
    required this.teamID,
    required this.game,
    required this.team,
    required this.user,
  });

  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      gameID: json['GameID'],
      userID: json['UserID'],
      teamID: json['TeamID'],
      game: GameDetails.fromJson(json['Game']),
      team: TeamDetails.fromJson(json['Team']),
      user: UserDetails.fromJson(json['User']),
    );
  }
}

class GameDetails {
  final int fieldId;
  final int hostId;
  final DateTime startTime;
  final DateTime endTime;
  final int maxPlayers;
  final String status;
  final HostDetails host;
  final FieldDetails field;

  GameDetails({
    required this.fieldId,
    required this.hostId,
    required this.startTime,
    required this.endTime,
    required this.maxPlayers,
    required this.status,
    required this.host,
    required this.field,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      fieldId: json['field_id'],
      hostId: json['host_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      maxPlayers: json['max_players'],
      status: json['status'],
      host: HostDetails.fromJson(json['host']),
      field: FieldDetails.fromJson(json['field']),
    );
  }
}

class HostDetails {
  final String name;
  final String surname;
  final String username;
  final String phone;

  HostDetails({
    required this.name,
    required this.surname,
    required this.username,
    required this.phone,
  });

  factory HostDetails.fromJson(Map<String, dynamic> json) {
    return HostDetails(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      phone: json['phone'],
    );
  }
}

class FieldDetails {
  final int id;
  final String name;
  final String location;
  final double pricePerHour;
  final int capacity;
  final bool available;

  FieldDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerHour,
    required this.capacity,
    required this.available,
  });

  factory FieldDetails.fromJson(Map<String, dynamic> json) {
    return FieldDetails(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      pricePerHour: json['price_per_hour'].toDouble(),
      capacity: json['capacity'],
      available: json['available'],
    );
  }
}

class TeamDetails {
  final int id;
  final String name;
  final int capacity;
  final int captainID;
  final HostDetails captain;

  TeamDetails({
    required this.id,
    required this.name,
    required this.capacity,
    required this.captainID,
    required this.captain,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      id: json['ID'],
      name: json['Name'],
      capacity: json['Capacity'],
      captainID: json['CaptainID'],
      captain: HostDetails.fromJson(json['Captain']),
    );
  }
}

class UserDetails {
  final String name;
  final String surname;
  final String username;
  final String phone;

  UserDetails({
    required this.name,
    required this.surname,
    required this.username,
    required this.phone,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      phone: json['phone'],
    );
  }
}
