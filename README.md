# Football Game App

## Overview
This is a Flutter-based mobile application that allows users to create their own **Algerian dream team** using **Premier League players**. The app integrates with **Firebase Firestore** to fetch and display player data from various clubs.

## Features
- 📸 **Dynamic UI**: Engaging visuals with a welcome screen and smooth navigation.
- ⚽ **Build Your Team**: Select players based on their positions from Firestore.
- 📡 **Real-time Data**: Fetch player data from Firebase Firestore.
- 🌎 **User-Friendly Interface**: Developed using Flutter and Material Design principles.

---

## 📂 Project Structure
```
/football-game-app
│-- /lib
│   │-- /auth
│   │   ├── landing_page.dart
│   │-- /models
│   │   ├── player.dart
│   │-- /screens
│   │   ├── welcome_page.dart
│   │-- /services
│   │   ├── player_service.dart
│   ├── main.dart
│-- /assets/images
│   ├── Soccer_player_action_on_the_stadium.png
│-- /pubspec.yaml
│-- README.md
```

---

## 🔧 Installation & Setup

### Prerequisites
- Install **Flutter**: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Install **Firebase CLI**: [Firebase Setup](https://firebase.google.com/docs/cli)
- Ensure you have an active **Firebase project** with Firestore enabled.

### Steps
1. **Clone the repository**:
   ```sh
   git clone https://github.com/yourusername/football-game-app.git
   cd football-game-app
   ```

2. **Install dependencies**:
   ```sh
   flutter pub get
   ```

3. **Configure Firebase**:
   - Add your `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) inside the `/android/app/` and `/ios/Runner/` directories respectively.
   - Enable Firestore in Firebase Console.

4. **Run the app**:
   ```sh
   flutter run
   ```

---

## 🏗️ Technologies Used
- **Flutter** (Dart)
- **Firebase Firestore** (Database)
- **Material Design** (UI Components)

---

## 📜 Code Snippets
### Example: Fetching Players from Firestore
```dart
static Future<Map<String, List<Player>>> getPlayersByPosition() async {
  final Map<String, List<Player>> playersByPosition = {};
  try {
    final snapshot = await FirebaseFirestore.instance.collection('clubs').get();
    for (var doc in snapshot.docs) {
      final clubData = doc.data() as Map<String, dynamic>?;
      if (clubData == null || !clubData.containsKey('players')) continue;

      final List<dynamic> players = clubData['players'] ?? [];
      for (var playerData in players.cast<Map<String, dynamic>>()) {
        final player = Player.fromJson(playerData, doc.id, clubData['kit_image_url']);
        playersByPosition.putIfAbsent(player.position, () => []);
        playersByPosition[player.position]!.add(player);
      }
    }
  } catch (e) {
    debugPrint("Error fetching players: $e");
  }
  return playersByPosition;
}
```

---

## 🛠️ Future Enhancements
- 🏆 Implement **user authentication** (Google Sign-in / Email login)
- 📊 Add **real-time stats** for players
- 🔄 Implement **pagination** for Firestore queries
- 🌍 Support for **multiple leagues & teams**

---


🚀 Happy Coding! 🎉

