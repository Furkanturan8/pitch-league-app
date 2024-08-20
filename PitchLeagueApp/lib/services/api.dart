import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

Future<String> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token') ?? '';
}