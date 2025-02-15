import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../../models/player.dart';
import '../../constants/app_colors.dart';
import '../../models/match_result_data.dart';

class MatchSimulationPage extends StatefulWidget {
  final Map<String, Player> teamPlayers;
  final String teamName;

  const MatchSimulationPage({
    super.key,
    required this.teamPlayers,
    required this.teamName,
  });

  @override
  State<MatchSimulationPage> createState() => _MatchSimulationPageState();
}

class _MatchSimulationPageState extends State<MatchSimulationPage> {
  late Map<String, PlayerStats> playerStats;
  late MatchResult matchResult;
  bool isSimulating = true;

  @override
  void initState() {
    super.initState();
    _simulateMatch();
  }

  void _simulateMatch() {
    final random = Random();
    playerStats = {};
    int teamScore = 0;
    int opponentScore = random.nextInt(4); // 0-3 goals for opponent

    // Initialize stats for each player
    for (var entry in widget.teamPlayers.entries) {
      playerStats[entry.key] = PlayerStats();
    }

    // Simulate goals and assists
    int totalGoals = random.nextInt(5); // 0-4 goals for team
    teamScore = totalGoals;

    for (int i = 0; i < totalGoals; i++) {
      // Select random scorer from forwards or midfielders
      var possibleScorers = widget.teamPlayers.entries
          .where((e) => e.value.position == 'FW' || e.value.position == 'MF')
          .toList();
      if (possibleScorers.isNotEmpty) {
        var scorer = possibleScorers[random.nextInt(possibleScorers.length)];
        playerStats[scorer.key]!.goals++;

        // Select random assister excluding scorer
        var possibleAssisters = widget.teamPlayers.entries
            .where((e) => e.key != scorer.key)
            .toList();
        if (possibleAssisters.isNotEmpty) {
          var assister = possibleAssisters[random.nextInt(possibleAssisters.length)];
          playerStats[assister.key]!.assists++;
        }
      }
    }

    // Simulate cards
    for (var entry in widget.teamPlayers.entries) {
      if (random.nextDouble() < 0.1) { // 10% chance of yellow card
        playerStats[entry.key]!.yellowCards++;
      }
      if (random.nextDouble() < 0.02) { // 2% chance of red card
        playerStats[entry.key]!.redCards++;
      }
    }

    // Check for clean sheet
    bool isCleanSheet = opponentScore == 0;
    if (isCleanSheet) {
      for (var entry in widget.teamPlayers.entries) {
        if (entry.value.position == 'GK' || entry.value.position == 'DF') {
          playerStats[entry.key]!.cleanSheet = true;
        }
      }
    }

    // Calculate total points
    int totalPoints = 0;
    playerStats.forEach((_, stats) {
      totalPoints += stats.calculatePoints();
    });

    matchResult = MatchResult(
      teamScore: teamScore,
      opponentScore: opponentScore,
      totalPoints: totalPoints,
    );

    // Simulate for 2 seconds before showing results
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isSimulating = false;
        });
      }
    });
  }

  Future<void> _saveMatchResult() async {
    try {
      final List<PlayerMatchStats> playerMatchStats = [];
      
      widget.teamPlayers.forEach((key, player) {
        final stats = playerStats[key]!;
        playerMatchStats.add(PlayerMatchStats(
          playerName: player.name,
          position: player.position,
          goals: stats.goals,
          assists: stats.assists,
          yellowCards: stats.yellowCards,
          redCards: stats.redCards,
          cleanSheet: stats.cleanSheet,
          points: stats.calculatePoints(),
        ));
      });

      await FirebaseFirestore.instance.collection('match_results').add({
        'teamName': widget.teamName,
        'teamScore': matchResult.teamScore,
        'opponentScore': matchResult.opponentScore,
        'totalPoints': matchResult.totalPoints,
        'playedAt': Timestamp.now(),
        'playerStats': playerMatchStats.map((stat) => stat.toMap()).toList(),
      });
    } catch (e) {
      print('Error saving match result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroun.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isSimulating
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Simulating Match...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Match Result Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Match Result',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.teamName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '${matchResult.teamScore} - ${matchResult.opponentScore}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Opponent',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Total Points: ${matchResult.totalPoints}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Player Stats Section
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.teamPlayers.length,
                        itemBuilder: (context, index) {
                          final entry = widget.teamPlayers.entries.elementAt(index);
                          final player = entry.value;
                          final stats = playerStats[entry.key]!;
                          final points = stats.calculatePoints();

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: Colors.black45,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(player.kitImageUrl),
                              ),
                              title: Text(
                                player.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Goals: ${stats.goals} | Assists: ${stats.assists} | YC: ${stats.yellowCards} | RC: ${stats.redCards}${stats.cleanSheet ? ' | Clean Sheet' : ''}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '+$points',
                                  style: TextStyle(
                                    color: AppColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Continue Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveMatchResult();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Return to Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class PlayerStats {
  int goals = 0;
  int assists = 0;
  int yellowCards = 0;
  int redCards = 0;
  bool cleanSheet = false;

  int calculatePoints() {
    return (goals * 5) +
        (assists * 3) +
        (cleanSheet ? 4 : 0) +
        (yellowCards * -2) +
        (redCards * -5);
  }
}

class MatchResult {
  final int teamScore;
  final int opponentScore;
  final int totalPoints;

  MatchResult({
    required this.teamScore,
    required this.opponentScore,
    required this.totalPoints,
  });
}
