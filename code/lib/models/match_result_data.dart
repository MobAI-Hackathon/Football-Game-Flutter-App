import 'package:cloud_firestore/cloud_firestore.dart';

class MatchResultData {
  final String id;
  final String teamName;
  final int teamScore;
  final int opponentScore;
  final int totalPoints;
  final DateTime playedAt;
  final List<PlayerMatchStats> playerStats;

  MatchResultData({
    required this.id,
    required this.teamName,
    required this.teamScore,
    required this.opponentScore,
    required this.totalPoints,
    required this.playedAt,
    required this.playerStats,
  });

  factory MatchResultData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchResultData(
      id: doc.id,
      teamName: data['teamName'] ?? '',
      teamScore: data['teamScore'] ?? 0,
      opponentScore: data['opponentScore'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      playedAt: (data['playedAt'] as Timestamp).toDate(),
      playerStats: (data['playerStats'] as List)
          .map((stat) => PlayerMatchStats.fromMap(stat))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamName': teamName,
      'teamScore': teamScore,
      'opponentScore': opponentScore,
      'totalPoints': totalPoints,
      'playedAt': Timestamp.fromDate(playedAt),
      'playerStats': playerStats.map((stat) => stat.toMap()).toList(),
    };
  }
}

class PlayerMatchStats {
  final String playerName;
  final String position;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final bool cleanSheet;
  final int points;

  PlayerMatchStats({
    required this.playerName,
    required this.position,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.cleanSheet,
    required this.points,
  });

  factory PlayerMatchStats.fromMap(Map<String, dynamic> map) {
    return PlayerMatchStats(
      playerName: map['playerName'] ?? '',
      position: map['position'] ?? '',
      goals: map['goals'] ?? 0,
      assists: map['assists'] ?? 0,
      yellowCards: map['yellowCards'] ?? 0,
      redCards: map['redCards'] ?? 0,
      cleanSheet: map['cleanSheet'] ?? false,
      points: map['points'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'position': position,
      'goals': goals,
      'assists': assists,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'cleanSheet': cleanSheet,
      'points': points,
    };
  }
}
