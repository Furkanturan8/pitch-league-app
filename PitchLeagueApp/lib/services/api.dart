import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pitch_league/screens/team_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../types/league.dart';
import '../types/league_team_detail.dart';
import '../types/team.dart';
import '../types/user.dart';
import '../types/field.dart';

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
    Uri.parse('http://localhost:3002/api/leaguesTeams/1'),
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
