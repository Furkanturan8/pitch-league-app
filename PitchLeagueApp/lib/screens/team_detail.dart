import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/league_team_detail.dart';

class TeamDetailScreen extends StatefulWidget {
  final int teamId;

  const TeamDetailScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  _TeamDetailScreenState createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  late Future<LeagueTeamDetail> _teamDetailFuture;

  @override
  void initState() {
    super.initState();
    _teamDetailFuture = fetchTeamDetail(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takım Detayları'),
      ),
      body: FutureBuilder<LeagueTeamDetail>(
        future: _teamDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teamDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailInfo('Takım Adı', teamDetail.team.name),
                  _buildDetailInfo('Kaptan', '${teamDetail.team.captain.Name} ${teamDetail.team.captain.Surname}'),
                  _buildDetailInfo('Kaptanın Telefonu', teamDetail.team.captain.Phone),
                  _buildDetailInfo('Lig', teamDetail.league.name),
                  _buildDetailInfo('Takımın Ligdeki Sıralaması', teamDetail.rank.toString()),
                  _buildDetailInfo('Takımın Kalan Oyuncu Kapasitesi', teamDetail.team.capacity.toString()),
                ],
              ),
            );
          } else {
            return Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }

  Widget _buildDetailInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 16),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
