import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/match_result_data.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  String _getMatchResult(int teamScore, int opponentScore) {
    if (teamScore > opponentScore) return 'Victory';
    if (teamScore < opponentScore) return 'Defeat';
    return 'Draw';
  }

  Color _getResultColor(String result) {
    switch (result) {
      case 'Victory':
        return Colors.green;
      case 'Defeat':
        return Colors.red;
      default:
        return Colors.orange;
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
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkGreenColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Match History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('match_results')
                        .orderBy('playedAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      int totalMatches = snapshot.data!.docs.length;
                      int totalPoints = snapshot.data!.docs
                          .map((doc) => (doc.data() as Map)['totalPoints'] as int)
                          .fold(0, (sum, points) => sum + points);
                      
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Matches', totalMatches.toString()),
                          _buildStat('Total Points', totalPoints.toString()),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Match List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('match_results')
                    .orderBy('playedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No matches played yet',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final matchResult = MatchResultData.fromFirestore(
                        snapshot.data!.docs[index],
                      );
                      final result = _getMatchResult(
                        matchResult.teamScore,
                        matchResult.opponentScore,
                      );
                      final resultColor = _getResultColor(result);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ExpansionTile(
                            backgroundColor: Colors.black87,
                            collapsedBackgroundColor: Colors.black87,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: resultColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        result,
                                        style: TextStyle(
                                          color: resultColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      DateFormat('MMM dd, HH:mm')
                                          .format(matchResult.playedAt),
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        matchResult.teamName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${matchResult.teamScore} - ${matchResult.opponentScore}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Opponent',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.greenColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '+${matchResult.totalPoints} Points',
                                      style: TextStyle(
                                        color: AppColors.greenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              // Player Performance List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: matchResult.playerStats.length,
                                itemBuilder: (context, index) {
                                  final stat = matchResult.playerStats[index];
                                  return ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    title: Text(
                                      stat.playerName,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      [
                                        if (stat.goals > 0) '⚽ ${stat.goals}',
                                        if (stat.assists > 0) '👟 ${stat.assists}',
                                        if (stat.yellowCards > 0) '🟨 ${stat.yellowCards}',
                                        if (stat.redCards > 0) '🟥 ${stat.redCards}',
                                        if (stat.cleanSheet) '🛡️ CS',
                                      ].join(' '),
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '+${stat.points}',
                                        style: TextStyle(
                                          color: AppColors.greenColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
