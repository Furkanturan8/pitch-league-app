import 'package:flutter/material.dart';
import '../services/api.dart';

class LeagueTeamDetailScreen extends StatefulWidget {
  final int leagueId;

  const LeagueTeamDetailScreen({Key? key, required this.leagueId}) : super(key: key);

  @override
  _LeagueTeamDetailScreenState createState() => _LeagueTeamDetailScreenState();
}

class _LeagueTeamDetailScreenState extends State<LeagueTeamDetailScreen> {
  late Future<List<Map<String, dynamic>>> _teamsWithPointsFuture;

  @override
  void initState() {
    super.initState();
    _teamsWithPointsFuture = fetchLeagueTeamDetails(widget.leagueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lig Takım Detayları'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _teamsWithPointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teamsWithPoints = snapshot.data!;
            if (teamsWithPoints.isEmpty) {
              return Center(child: Text('No team details found'));
            }
            return ListView.builder(
              itemCount: teamsWithPoints.length,
              itemBuilder: (context, index) {
                final team = teamsWithPoints[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          team['teamName'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Puan: ${team['points']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
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
