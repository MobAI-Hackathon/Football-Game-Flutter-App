# Football Game App

## Overview
This is a Flutter-based mobile application that allows users to create their own **Algerian dream team** using **Premier League players**. The app integrates with **Firebase Firestore** to fetch and display player data from various clubs.

---

## Implemented Features

- **User Onboarding:**
  - **Welcome Screen:** A visually engaging welcome screen with a full-screen background image and a call-to-action button to start using the app.
  - **Landing Page:** An authentication landing page that provides options for login, sign up, and Google Sign-In integration.

- **Authentication:**
  - **Email/Password Login & Sign Up:** Secure user authentication with Firebase.
  - **Google Sign-In:** Seamless authentication using Google accounts.
  
- **Team Management:**
  - **Team Creation:** Users can create a new team by setting match parameters (team name and formation) through the **Match Parameters Page**.
  - **Player Selection:** Browse and filter available players by position and search criteria. 
    - **HomePage:** Displays available players fetched from Firestore.
    - **Player Details Page:** Detailed view of a player's information with an option to add the player to the team.
  - **Team Generation:** Users can generate a team based on the selected formation and available budget.
  - **Saved Teams:** Manage saved teams, including viewing details, editing, and deleting teams on the **Create Team Page**.

- **Match Simulation:**
  - **Match Generation & Simulation:** Simulate a football match based on the selected team, with randomized events such as goals, assists, and cards.
  - **Match Result:** Display detailed match results, including individual player performance and overall team statistics.
  - **Match History:** Save and view past match results along with aggregated statistics on the **Save Page**.

- **User Profile & Stats:**
  - **Profile Page:** View user profile details including display name, email, and a profile picture (with a default image fallback).
  - **Manager Statistics:** Display aggregated statistics such as total matches played, total points earned, wins, draws, losses, and win rate.

- **Backend Integration:**
  - **Firestore Integration:** Fetch player data from Firestore using the `PlayerService`, and store match results.
  - **Firebase Core Initialization:** Proper Firebase initialization to ensure smooth operation across the app.

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

