import 'package:flutter/material.dart';
import '../../models/team_info.dart';
import '../../constants/app_colors.dart';
import 'search_players.dart';  // Add this import
import '../../models/player.dart';
import 'match_generation_page.dart';

class GenerateTeam extends StatefulWidget {  // Rename and convert to StatefulWidget
  final String teamName;
  final String formation;

  const GenerateTeam({
    super.key,
    required this.teamName,
    required this.formation,
  });

  @override
  State<GenerateTeam> createState() => _GenerateTeamState();
}

class _GenerateTeamState extends State<GenerateTeam> {
  // Change to store players with unique position IDs
  Map<String, Player> selectedPlayers = {};
  double budgetLeft = 100.0;  // Initialize budget to 100M

  // Add method to generate unique position key
  String _getPositionKey(int rowIndex, int columnIndex, int playerType) {
    return '$rowIndex-$columnIndex-${_getPositionName(playerType)}';
  }

  // Add method to update budget
  void updateBudget(Player? player, bool isAdding) {
    setState(() {
      if (player != null) {
        if (isAdding) {
          budgetLeft -= player.price;
        } else {
          budgetLeft += player.price;
        }
      }
    });
  }

  List<List<int>> _getFormationLayout() {
    List<List<int>> formation;
    switch (widget.formation) {
      case '4-3-3':
        formation = [
          List.filled(3, 2), // Forwards
          List.filled(3, 1), // Midfielders
          List.filled(4, 0), // Defenders
          [3], // Goalkeeper at the end
        ];
        break;
      case '4-4-2':
        formation = [
          List.filled(2, 2), // Forwards
          List.filled(4, 1), // Midfielders
          List.filled(4, 0), // Defenders
          [3], // Goalkeeper at the end
        ];
        break;
      case '3-5-2':
        formation = [
          List.filled(2, 2), // Forwards
          List.filled(5, 1), // Midfielders
          List.filled(3, 0), // Defenders
          [3], // Goalkeeper at the end
        ];
        break;
      case '5-3-2':
        formation = [
          List.filled(2, 2), // Forwards
          List.filled(3, 1), // Midfielders
          List.filled(5, 0), // Defenders
          [3], // Goalkeeper at the end
        ];
        break;
      default:
        formation = [
          List.filled(3, 2),
          List.filled(3, 1),
          List.filled(4, 0),
          [3], // Goalkeeper at the end
        ];
    }
    return formation;
  }

  String _getPositionName(int positionType) {
    switch (positionType) {
      case 0:
        return 'DEF';
      case 1:
        return 'MID';
      case 2:
        return 'FWD';
      case 3:
        return 'GK';
      default:
        return '';
    }
  }

  Widget _buildPlayerIcon(String positionKey, int playerType) {
    final player = selectedPlayers[positionKey];
    return GestureDetector(
      onTap: () async {
        if (player != null) {
          updateBudget(player, false);
        }
        
        final selectedPlayer = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              requiredPosition: _getPositionName(playerType),  // Pass the correct position
            ),
          ),
        );
        
        if (selectedPlayer != null) {
          // Check if we have enough budget
          if (budgetLeft >= selectedPlayer.price) {
            setState(() {
              selectedPlayers[positionKey] = selectedPlayer;
              updateBudget(selectedPlayer, true);
            });
          } else {
            // Show error message if not enough budget
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Not enough budget to add ${selectedPlayer.name}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: SizedBox(
        height: 35,
        width: 35,
        child: player?.kitImageUrl.isNotEmpty == true
            ? Image.network(
                player!.kitImageUrl,
                fit: BoxFit.contain,
              )
            : Image.asset(
                'assets/images/Vector.png',
                fit: BoxFit.contain,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamInfo = TeamInfo(
      budgetLeft: budgetLeft,  // Use the actual budget
      numberOfPlayers: selectedPlayers.length,  // Use actual number of players
      formation: widget.formation,
    );

    final formationLayout = _getFormationLayout();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Doing sport concept.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Team info overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
              decoration: BoxDecoration(
                color: AppColors.darkGreenColor.withOpacity(0.9),
              ),
              child: Column(
                children: [
                  Text(
                    'Budget left: £${teamInfo.budgetLeft}M',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Number of Players: ${teamInfo.numberOfPlayers}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Formation: ${teamInfo.formation}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Formation layout
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,  // Remove the conditional bottom spacing
            child: Padding(  // Added this Padding widget
              padding: const EdgeInsets.only(bottom: 120.0, left: 35.0, right: 35.0, top: 30.0),  // Increased from 40.0 to 80.0
              child: Column(
                children: [
                  for (int rowIndex = 0; rowIndex < formationLayout.length; rowIndex++)  // Changed from reverse to forward iteration
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int columnIndex = 0; columnIndex < formationLayout[rowIndex].length; columnIndex++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Reduced vertical padding
                                child: Column(  // Removed Container wrapper
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildPlayerIcon(
                                      _getPositionKey(rowIndex, columnIndex, formationLayout[rowIndex][columnIndex]),
                                      formationLayout[rowIndex][columnIndex],
                                    ),
                                    const SizedBox(height: 4), // Reduced from 8 to 4
                                    Text(
                                      _getPositionName(formationLayout[rowIndex][columnIndex]),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Generate Match Button - Overlay on top without affecting layout
          if (selectedPlayers.length == 11)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchGenerationPage(
                          teamPlayers: selectedPlayers,
                          teamName: widget.teamName,
                          formation: widget.formation,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Generate Match',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}