import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/team.dart';
import 'team_detail.dart'; // Yeni ekranın import edilmesi

class TeamsScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const TeamsScreen({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  TeamsScreenState createState() => TeamsScreenState();
}

class TeamsScreenState extends State<TeamsScreen> {
  late Future<List<Team>> _teamsFuture;

  @override
  void initState() {
    super.initState();
    loadTeams(); // API'den takımları al
  }

  void loadTeams() {
    setState(() {
      _teamsFuture = fetchTeams(); // API'den veriyi yeniden al
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takımlar'),
      ),
      body: FutureBuilder<List<Team>>(
        future: _teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teams = snapshot.data!;
            if (teams.isEmpty) {
              return Center(child: Text('No teams found'));
            }
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      team.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Takım Kaptanı: ${team.captain.Name} ${team.captain.Surname} \nBoş adam kapasitesi: ${team.capacity}',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TeamDetailScreen(teamId: team.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
