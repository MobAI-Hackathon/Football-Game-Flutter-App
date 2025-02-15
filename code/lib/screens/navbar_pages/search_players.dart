import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../constants/app_colors.dart';
import '../../services/player_service.dart';
import '../navbar_pages/player_details_page.dart';

class HomePage extends StatefulWidget {
  final String requiredPosition;

  const HomePage({
    super.key,
    this.requiredPosition = 'ALL',  // Add default value
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedPosition = 'Forwards';
  Map<String, List<Player>> playersByPosition = {};
  bool isLoading = true;
  String searchQuery = '';  // Add search query

  // Add filtered players getter
  List<Player> get filteredPlayers {
    final players = playersByPosition[selectedPosition] ?? [];
    if (searchQuery.isEmpty) return players;
    
    return players.where((player) =>
      player.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      player.club.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    playersByPosition = await PlayerService.getPlayersByPosition();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Players',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.navbarColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Add Search Bar
                Container(
                  color: AppColors.darkGreenColor,
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search players or clubs...',
                      hintStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: AppColors.darkGreenColor.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.greenColor),
                      ),
                    ),
                  ),
                ),
                // Position filter list
                Container(
                  height: 60,
                  color: AppColors.darkGreenColor,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      for (String position in playersByPosition.keys)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              position,
                              style: TextStyle(
                                color: selectedPosition == position
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            selected: selectedPosition == position,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedPosition = position;
                              });
                            },
                            backgroundColor: AppColors.darkGreenColor,
                            selectedColor: AppColors.greenColor,
                          ),
                        ),
                    ],
                  ),
                ),
                // Players list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      return GestureDetector(
                        onTap: () async {
                          final selectedPlayer = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerDetailsPage(
                                player: player,
                              ),
                            ),
                          );
                          if (selectedPlayer != null) {
                            Navigator.pop(context, selectedPlayer);
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          color: AppColors.darkGreenColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          player.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        player.position,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        player.club,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '£${player.price}M',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                if (player.kitImageUrl.isNotEmpty)
                                  Image.network(
                                    player.kitImageUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain,
                                  )
                                else
                                  Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white70,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
