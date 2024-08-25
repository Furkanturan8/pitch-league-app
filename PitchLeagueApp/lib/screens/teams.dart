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
  List<Team> _allTeams = [];
  List<Team> _filteredTeams = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTeams();
    _searchController.addListener(_filterTeams); // Arama işlemi için listener ekliyoruz
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void loadTeams() {
    setState(() {
      _teamsFuture = fetchTeams();
    });
    _teamsFuture.then((teams) {
      setState(() {
        _allTeams = teams;
        _filteredTeams = teams;
      });
    });
  }

  void _filterTeams() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeams = _allTeams.where((team) {
        final teamName = team.name.toLowerCase();
        return teamName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takımlar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Takım Ara',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Team>>(
              future: _teamsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (_filteredTeams.isEmpty) {
                    return Center(child: Text('No teams found'));
                  }
                  return ListView.builder(
                    itemCount: _filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = _filteredTeams[index];
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
          ),
        ],
      ),
    );
  }
}
