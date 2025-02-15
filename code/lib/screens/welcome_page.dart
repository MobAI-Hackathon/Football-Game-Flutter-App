import 'package:flutter/material.dart';
import 'auth/landing_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Big picture widget
          const Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: Image(
                image: AssetImage('assets/images/Soccer_player_action_on_the_stadium.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Combined title and icon section with single gradient background
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF31511E),
                    Color(0xFF1A1A19),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Create your Algerian dream team using Premier League players.',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 38/32, // lineHeight 38px
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Icon button
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LandingPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_circle_right,
                      size: 64,
                      color: Colors.white,
                    ),
                    tooltip: 'Get Started',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
