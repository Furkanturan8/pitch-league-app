import 'games.dart';
import 'league.dart';

class Match {
  final int leagueID;
  final int homeTeamID;
  final int awayTeamID;
  final DateTime matchTime;
  final int homeScore;
  final int awayScore;
  final String status;
  final int gameID;
  final GameDetails game;
  final TeamDetails homeTeam;
  final TeamDetails awayTeam;
  final League league;

  Match({
    required this.leagueID,
    required this.homeTeamID,
    required this.awayTeamID,
    required this.matchTime,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.gameID,
    required this.game,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      leagueID: json['LeagueID'],
      homeTeamID: json['HomeTeamID'],
      awayTeamID: json['AwayTeamID'],
      matchTime: DateTime.parse(json['MatchTime']),
      homeScore: json['HomeScore'],
      awayScore: json['AwayScore'],
      status: json['Status'],
      gameID: json['GameID'],
      game: GameDetails.fromJson(json['Game']),
      homeTeam: TeamDetails.fromJson(json['HomeTeam']),
      awayTeam: TeamDetails.fromJson(json['AwayTeam']),
      league: League.fromJson(json['League']),
    );
  }
}
