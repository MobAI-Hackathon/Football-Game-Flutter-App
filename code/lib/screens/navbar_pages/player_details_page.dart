import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../constants/app_colors.dart';

class PlayerDetailsPage extends StatelessWidget {
  final Player player;

  const PlayerDetailsPage({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkGreenColor, // Change scaffold background
      appBar: AppBar(
        backgroundColor: AppColors.darkGreenColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // Top section with player info
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side - Player details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Centered name
                          Center(
                            child: Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Left-aligned details
                          _buildDetailRow('Position:', player.position),
                          const SizedBox(height: 8),
                          _buildDetailRow('Club:', player.club),
                          const SizedBox(height: 8),
                          _buildDetailRow('Price:', '£${player.price}M'),
                        ],
                      ),
                    ),
                    // Right side - Player image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: player.kitImageUrl.isNotEmpty
                            ? Image.network(
                                player.kitImageUrl,
                                fit: BoxFit.contain,
                              )
                            : const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: AppColors.darkGreenColor,  // Add this to ensure full green background
                ),
              ),
            ],
          ),
          // Bottom section with Polygon and button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Polygon image
                Image.asset(
                  'assets/images/Polygon.png',  // Changed from .jpg to .png
                  width: size.width,
                  fit: BoxFit.contain,
                ),
                // Add Player button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppColors.darkGreenColor,  // Change to green background
                  child: ElevatedButton(
                    onPressed: () {
                      // Return to search page with selected player
                      Navigator.pop(context, player);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add Player',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
