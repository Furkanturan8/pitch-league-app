import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/league_team_detail.dart';
import '../types/user.dart';

class TeamDetailScreen extends StatefulWidget {
  final int teamId;

  const TeamDetailScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  _TeamDetailScreenState createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  late Future<LeagueTeamDetail> _teamDetailFuture;
  late Future<User> _userFuture;
  int? _userID; // Kullanıcı ID'sini saklamak için bir değişken

  @override
  void initState() {
    super.initState();
    _teamDetailFuture = fetchTeamDetail(widget.teamId);
    _loadUser(); // Kullanıcı bilgilerini yükle
  }

  Future<void> _loadUser() async {
    try {
      final userID = await getMyUserID(); // API'den kullanıcıyı al

      if (!mounted) return; // Eğer widget artık ağacın bir parçası değilse çık
      setState(() {
        _userID = userID;
      });
    } catch (e) {
      print('Kullanıcı yüklenemedi: $e');
    }
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
                  SizedBox(height: 5),
                  _buildJoinTeamButton(teamDetail.team.capacity),
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

  Widget _buildJoinTeamButton(int capacity) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (capacity == 0) {
            _showCapacityFullDialog();
          } else if (_userID != null) {
            final success = await addUserToTeam(_userID!, widget.teamId);

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Takıma başarıyla katıldınız!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Takıma katılma başarısız! (Zaten bu takımda olabilirsiniz!)')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kullanıcı bilgileri yüklenemedi.')),
            );
          }
        },
        child: Text('Takıma Katıl'),
      ),
    );
  }

  void _showCapacityFullDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kapasite Doldu'),
          content: Text('Bu takım için kapasite doldu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop-up'ı kapat
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
