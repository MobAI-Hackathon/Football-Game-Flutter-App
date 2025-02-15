import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/player.dart';
import '../match/match_simulation_page.dart';  // Add this import

class MatchGenerationPage extends StatelessWidget {
  final Map<String, Player> teamPlayers;
  final String teamName;
  final String formation;

  const MatchGenerationPage({
    super.key,
    required this.teamPlayers,
    required this.teamName,
    required this.formation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,  // Changed from darkGreenColor
      appBar: AppBar(
        title: Text(teamName),
        backgroundColor: AppColors.navbarColor,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroun.png'),  // Changed background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Team Information Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black26,  // Changed from darkGreenColor to semi-transparent black
                child: Column(
                  children: [
                    Text(
                      teamName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Formation: $formation',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Players List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (var player in teamPlayers.values)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.darkGreenColor,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(player.kitImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${player.position} • ${player.club}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              '£${player.price}M',
                              style: const TextStyle(
                                color: AppColors.greenColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Start Match Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchSimulationPage(
                          teamPlayers: teamPlayers,
                          teamName: teamName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Start Match',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
