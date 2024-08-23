import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/team.dart';
import '../types/user.dart';

class MyTeamScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const MyTeamScreen({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  MyTeamScreenState createState() => MyTeamScreenState();
}

class MyTeamScreenState extends State<MyTeamScreen> {
  late Future<User> _userFuture;
  late Future<List<Team>> _myTeamFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserMe(); // Kullanıcı verilerini yükle
  }

  Future<void> loadMyTeam() async {
    try {
      final user = await _userFuture;
      setState(() {
        _myTeamFuture = fetchMyTeam(user.teamID);
      });
    } catch (e) {
      print('Takım verileri yüklenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takımım'),
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Hata: ${userSnapshot.error}'));
          } else if (userSnapshot.hasData) {
            final user = userSnapshot.data!;
            _myTeamFuture = fetchMyTeam(user.teamID);

            return FutureBuilder<List<Team>>(
              future: _myTeamFuture,
              builder: (context, teamSnapshot) {
                if (teamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (teamSnapshot.hasError) {
                  return Center(child: Text('Hata: ${teamSnapshot.error}'));
                } else if (teamSnapshot.hasData) {
                  final teams = teamSnapshot.data!;
                  if (teams.isEmpty) {
                    return Center(child: Text('Takımın Henüz Yok!'));
                  }
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            team.name,
                            style: TextStyle(fontFamily: 'CustomFont', fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Kaptan: ${team.captain.Name} ${team.captain.Surname}\n'
                            'Kaptanın Telefonu: ${team.captain.Phone}\n'
                            'Eksik oyuncu sayısı: ${team.capacity}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Veri bulunamadı'));
                }
              },
            );
          } else {
            return Center(child: Text('Kullanıcı verisi bulunamadı'));
          }
        },
      ),
    );
  }
}
