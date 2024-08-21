import 'package:pitch_league/types/team.dart';

import 'league.dart';

class LeagueTeamDetail {
  final int leagueID;
  final int teamID;
  final int points;
  final int rank;
  final League league;
  final Team team;

  LeagueTeamDetail({
    required this.leagueID,
    required this.teamID,
    required this.points,
    required this.rank,
    required this.league,
    required this.team,
  });

  factory LeagueTeamDetail.fromJson(Map<String, dynamic> json) {
    return LeagueTeamDetail(
      leagueID: json['LeagueID'] ?? 0,
      teamID: json['TeamID'] ?? 0,
      points: json['Points'] ?? 0,
      rank: json['Rank'] ?? 0,
      league: League.fromJson(json['League'] ?? {}),
      team: Team.fromJson(json['Team'] ?? {}),
    );
  }
}
