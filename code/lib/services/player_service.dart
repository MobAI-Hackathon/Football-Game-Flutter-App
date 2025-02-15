import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayerService {
  static Future<Map<String, List<Player>>> getPlayersByPosition() async {
    final Map<String, List<Player>> playersByPosition = {};
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('clubs').get();

    for (var doc in snapshot.docs) {
      final clubData = doc.data() as Map<String, dynamic>;
      final String clubName = doc.id;
      final String kitImageUrl = clubData['kit_image_url'];
      final List<dynamic> players = clubData['players'];
      for (var playerData in players) {
        final player = Player.fromJson(playerData, clubName, kitImageUrl);
        if (!playersByPosition.containsKey(player.position)) {
          playersByPosition[player.position] = [];
        }
        playersByPosition[player.position]!.add(player);
      }
    }

    return playersByPosition;
  }
}
