import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getStats() async {
    final matchResults = await _firestore
        .collection('match_results')
        .where('userId', isEqualTo: user?.uid)
        .get();

    int totalMatches = matchResults.docs.length;
    int totalPoints = 0;
    int wins = 0;
    int draws = 0;
    int losses = 0;

    for (var doc in matchResults.docs) {
      final data = doc.data();
      totalPoints += data['totalPoints'] as int;
      
      int teamScore = data['teamScore'] as int;
      int opponentScore = data['opponentScore'] as int;
      
      if (teamScore > opponentScore) wins++;
      else if (teamScore == opponentScore) draws++;
      else losses++;
    }

    return {
      'totalMatches': totalMatches,
      'totalPoints': totalPoints,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'winRate': totalMatches > 0 ? (wins / totalMatches * 100).toStringAsFixed(1) : '0',
    };
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          user?.photoURL ?? 
                          'https://example.com/default-avatar.png',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.displayName ?? 'Football Manager',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Section
                FutureBuilder<Map<String, dynamic>>(
                  future: _getStats(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final stats = snapshot.data!;
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Manager Statistics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Matches', '${stats['totalMatches']}'),
                              _buildStatItem('Points', '${stats['totalPoints']}'),
                              _buildStatItem('Win Rate', '${stats['winRate']}%'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Wins', '${stats['wins']}', color: Colors.green),
                              _buildStatItem('Draws', '${stats['draws']}', color: Colors.orange),
                              _buildStatItem('Losses', '${stats['losses']}', color: Colors.red),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Settings Section
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Implement edit profile
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () {
                          // TODO: Implement notifications
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
