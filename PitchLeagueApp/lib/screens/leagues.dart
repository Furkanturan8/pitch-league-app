import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/league.dart';
import 'league_detail.dart';

class LeaguesScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const LeaguesScreen({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  LeaguesScreenState createState() => LeaguesScreenState();
}

class LeaguesScreenState extends State<LeaguesScreen> {
  late Future<List<League>> _leaguesFuture;

  @override
  void initState() {
    super.initState();
    loadLeagues();
  }

  void loadLeagues() {
    setState(() {
      _leaguesFuture = fetchLeagues() as Future<List<League>>;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ligler'),
      ),
      body: FutureBuilder<List<League>>(
        future: _leaguesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final leagues = snapshot.data!;
            if (leagues.isEmpty) {
              return Center(child: Text('No leagues found'));
            }
            return ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Detay sayfasına geçiş yap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueTeamDetailScreen(leagueId: league.id),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            league.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  league.location,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Başlangıç: ${_formatDate(league.startDateTime)} \nBitiş: ${_formatDate(league.endDateTime)}',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
