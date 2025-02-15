import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'navbar_pages/generate_team.dart';

class MatchParametersPage extends StatefulWidget {
  const MatchParametersPage({super.key});

  @override
  State<MatchParametersPage> createState() => _MatchParametersPageState();
}

class _MatchParametersPageState extends State<MatchParametersPage> {
  String selectedFormation = '4-3-3';
  final teamNameController = TextEditingController();

  final List<String> formations = [
    '4-3-3',
    '4-4-2',
    '3-5-2',
    '5-3-2',
  ];

  @override
  Widget build(BuildContext context) {
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
          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Match Parameters',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Team Name Input with white background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: teamNameController,
                        style: TextStyle(color: AppColors.darkGreenColor),
                        decoration: InputDecoration(
                          labelText: 'Team Name',
                          labelStyle: TextStyle(color: AppColors.darkGreenColor),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greenColor),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Formation Dropdown with white background
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedFormation,
                          dropdownColor: Colors.white,
                          style: TextStyle(color: AppColors.darkGreenColor),
                          items: formations.map((String formation) {
                            return DropdownMenuItem<String>(
                              value: formation,
                              child: Text(formation),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedFormation = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Continue Button with white background
                    ElevatedButton(
                      onPressed: () {
                        if (teamNameController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenerateTeam(
                                teamName: teamNameController.text,
                                formation: selectedFormation,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.darkGreenColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
