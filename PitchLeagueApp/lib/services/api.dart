import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pitch_league/types/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../types/match.dart';
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
    body: jsonEncode(user.toUpdateJson()),
  );

  if (response.statusCode == 200) {
    // Başarılı güncelleme
    print('Profil başarıyla güncellendi');
  } else {
    // Hata durumları
    throw Exception('Profil güncellenemedi: ${response.body}');
  }
}

Future<List<ListUser>> fetchAllUsers() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/users'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);

    // 'data' anahtarının veriyi bir liste olarak içerdiğini kontrol et
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      final List<dynamic> userDataList = jsonMap['data'] as List<dynamic>;

      // Listeyi ListUser nesnelerine dönüştür
      final List<ListUser> users = userDataList.map((userJson) {
        return ListUser.fromJson(userJson as Map<String, dynamic>);
      }).toList();

      return users;
    } else {
      throw Exception('User data is not a valid JSON list or key is missing');
    }
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List<Message>> fetchUserConversations() async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/teams'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );
 throw Exception('Konuşma daveti gönderilemedi: ${response.body}');
}

Future<void> inviteUser(String from, String to) async {
  final url = Uri.parse('http://localhost:3002/api/invite');
  final token = await _getToken(); // Token'ı al
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Gerekirse kullanıcı token'ı burada ekleyin
    },
    body: jsonEncode({
      'inviter': from,
      'invitee': to,
    }),
  );

  if (response.statusCode == 200) {
    // Başarılı güncelleme
    print('Kullanıcıya konuşma daveti gönderildi!');
  } else {
    // Hata durumları
    throw Exception('Konuşma daveti gönderilemedi: ${response.body}');
  }
}


Future<List<Match>> fetchMatches(int userID) async {
  final token = await _getToken(); // Token'ı al

  // İlk olarak gameParts API'sine istek at
  final gamePartsResponse = await http.get(
    Uri.parse('http://localhost:3002/api/gameParts/$userID'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (gamePartsResponse.statusCode == 200) {
    Map<String, dynamic> gamePartsJson = jsonDecode(gamePartsResponse.body);

    // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
    if (gamePartsJson.containsKey('data') && gamePartsJson['data'] is Map<String, dynamic>) {
      Map<String, dynamic> dataMap = gamePartsJson['data'];

      // gameID'yi al
      int gameID = dataMap['GameID'];

      // Şimdi matches API'sine istek at
      final matchesResponse = await http.get(
        Uri.parse('http://localhost:3002/api/matches/$gameID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (matchesResponse.statusCode == 200) {
        Map<String, dynamic> matchesJson = jsonDecode(matchesResponse.body);

        // 'data' anahtarının veriyi bir liste olarak içerip içermediğini kontrol et
        if (matchesJson.containsKey('data') && matchesJson['data'] is Map<String, dynamic>) {
          Map<String, dynamic> matchDataMap = matchesJson['data'];

          // Eğer 'data' tek bir maç nesnesiyse, bunu bir listeye ekleyin
          return [Match.fromJson(matchDataMap)];
        } else {
          throw Exception('Matches data is not a list or key is missing');
        }
      } else if (matchesResponse.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error fetching matches: ${matchesResponse.statusCode}');
      }
    } else {
      throw Exception('GameParts data is not a map or key is missing');
    }
  } else if (gamePartsResponse.statusCode == 404) {
    return [];
  } else {
    throw Exception('Error fetching game parts: ${gamePartsResponse.statusCode}');
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

Future<bool> addUserToTeam(int userId, int teamId) async {
  final token = await _getToken(); // Token'ı al
  final String apiUrl = 'http://localhost:3002/api/teams/$teamId/join/$userId';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        'userID': userId,
        'teamID': teamId,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Başarı durumunda true döndür
    } else {
      print('Failed to add user to team. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false; // Başarısızlık durumunda false döndür
    }
  } catch (e) {
    print('Error: $e');
    return false; // Hata durumunda false döndür
  }
}

Future<List<Team>> fetchMyTeam(int teamID) async {
  final token = await _getToken(); // Token'ı al
  final response = await http.get(
    Uri.parse('http://localhost:3002/api/teams/$teamID'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    if (jsonMap.containsKey('data') && jsonMap['data'] is Map<String, dynamic>) {
      Map<String, dynamic> dataMap = jsonMap['data'];
      // Eğer 'data' tek bir oyun nesnesiyse, bunu bir listeye ekleyin
      return [Team.fromJson(dataMap)];
    } else {
      throw Exception('Team data is not a list or key is missing');
    }
  } else {
    throw Exception('Failed to load team');
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
