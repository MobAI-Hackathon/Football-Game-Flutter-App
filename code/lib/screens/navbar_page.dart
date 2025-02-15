import 'package:flutter/material.dart';
import 'navbar_pages/search_players.dart';
import 'team_creation/create_team_page.dart';
import 'navbar_pages/save_page.dart';
import 'navbar_pages/profile_page.dart';
import '../constants/app_colors.dart';

class NavbarPage extends StatefulWidget {
  final String? email;
  
  const NavbarPage({super.key, this.email});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;

  // List of pages to display
  late final List<Widget> _pages = [
    const HomePage(requiredPosition: 'ALL'),  // Add required parameter
    CreateTeamPage(),
    const SavePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.navbarColor,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          indicatorColor: AppColors.greenColor,
          surfaceTintColor: Colors.transparent,
          height: 65,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.create_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.create, color: Colors.white),
              label: 'Create Team',
            ),
            NavigationDestination(
              icon: Icon(Icons.save_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.save, color: Colors.white),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white70),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
