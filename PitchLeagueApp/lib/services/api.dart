import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../types/games.dart';
import '../types/league.dart';
import '../types/league_team_detail.dart';
import '../types/team.dart';
import '../types/user.dart';
import '../types/field.dart';

Future<void> registerUser(CreateUser createUser) async {
  final response = await http.post(
    Uri.parse('http://localhost:3002/api/user/create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
        'email': createUser.email,
        'phone': createUser.phone,
        'name': createUser.name,
        'surname': createUser.surname,
        'username': createUser.username,
        'password': createUser.password,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print('Kullanıcı başarıyla eklendi');
  } else {
    throw Exception('Kullanıcı eklenemedi: ${response.body}');
  }
}

Future<void> updateProfile(User user) async {
  final url = Uri.parse('http://localhost:3002/api/user/me');
  final token = await _getToken(); // Token'ı al
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Gerekirse kullanıcı token'ı burada ekleyin
    },
    body: jsonEncode({
      'email': user.email,
      'phone': user.phone,
      'name': user.name,
      'surname': user.surname,
      'username': user.username,
      'role': user.role,
    }),
  );

  if (response.statusCode == 200) {
    // Başarılı güncelleme
    print('Profil başarıyla güncellendi');
  } else {
    // Hata durumları
    throw Exception('Profil güncellenemedi: ${response.body}');
  }
}

Future<List<Games>> fetchGames(int userID) async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/gameParts/$userID'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => Games.fromJson(json)).toList();
    } else {
      throw Exception('Games data is not a list or key is missing');
    }
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception('Error fetching games: ${response.statusCode}');
  }
}

Future<List<Team>> fetchTeams() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/teams'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => Team.fromJson(json)).toList();
    } else {
      throw Exception('Teams data is not a list or key is missing');
    }
  } else {
    throw Exception('Failed to load teams');
  }
}

Future<LeagueTeamDetail> fetchTeamDetail(int id) async {
  final token = await _getToken();
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/leaguesTeam/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    if (jsonMap.containsKey('data') && jsonMap['data'] is Map<String, dynamic>) {
      return LeagueTeamDetail.fromJson(jsonMap['data']);
    } else {
      throw Exception('Team detail data is not a valid JSON object or key is missing');
    }
  } else {
    throw Exception('Failed to load team detail');
  }
}

Future<int> getMyUserID() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/user/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir nesne olarak içerdiğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is Map<String, dynamic>) {
      final userData = jsonMap['data'] as Map<String, dynamic>;

      // Kullanıcı ID'sini döndür
      if (userData.containsKey('id') && userData['id'] is int) {
        return userData['id'] as int;
      } else {
        throw Exception('User ID is missing or not an integer');
      }
    } else {
      throw Exception('User data is not a valid JSON object or key is missing');
    }
  } else {
    throw Exception('Failed to load user');
  }
}


Future<User> fetchUserMe() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/user/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir nesne olarak içerdiğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is Map<String, dynamic>) {
      return User.fromJson(jsonMap['data']);
    } else {
      throw Exception('User data is not a valid JSON object or key is missing');
    }
  } else {
    throw Exception('Failed to load user');
  }

}

Future<List<Field>> fetchFields() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/fields'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => Field.fromJson(json)).toList();
    } else {
      throw Exception('Fields data is not a list or key is missing');
    }
  } else {
    throw Exception('Failed to load teams');
  }
}

Future<List<League>> fetchLeagues() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/leagues'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => League.fromJson(json)).toList();
    } else {
      throw Exception('League data is not a list or key is missing');
    }
  } else {
    throw Exception('Failed to load leagues');
  }
}

Future<List<Map<String, dynamic>>> fetchLeagueTeamDetails(int leagueId) async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/leaguesTeams/$leagueId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json['data'];

    // Sadece takım ismi ve puanı içeren bir liste oluşturun
    List<Map<String, dynamic>> teamsWithPoints = data.map((e) => {
      'teamName': e['Team']['Name'],
      'points': e['Points'],
    }).toList();

    // Puanlara göre azalan sırayla sıralayın
    teamsWithPoints.sort((a, b) => b['points'].compareTo(a['points']));

    return teamsWithPoints;
  } else {
    throw Exception('Failed to load league team details');
  }
}

Future<String> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token') ?? '';
}
