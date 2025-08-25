import 'package:flutter/material.dart';

class SplashScreenTest extends StatefulWidget {
  const SplashScreenTest({super.key});

  @override
  State<SplashScreenTest> createState() => _SplashScreenTestState();
}

class _SplashScreenTestState extends State<SplashScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color from Figma (dark blue)
      backgroundColor: const Color(0xFF2C5282),
      body: Stack(
        children: [
          // Top blur effect (gold ellipse) - centered using Align, showing only half
          Align(
            alignment: const Alignment(0, -2.2), // Center horizontally, further outside top
            child: Container(
              width: 488.87,
              height: 368.59,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 215, 0, 0.2),
                    blurRadius: 100,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          // Bottom blur effect (gold ellipse) - centered using Align, showing only half
          Align(
            alignment: const Alignment(0, 2.2), // Matching top ellipse's -2.2
            child: Container(
              width: 488.87, // Matching top ellipse's width
              height: 368.59, // Matching top ellipse's height
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 215, 0, 0.2),
                    blurRadius: 100,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          // Additional blur overlay for top - centered using Align, showing only half
          Align(
            alignment: const Alignment(0, -2.0),
            child: Container(
              width: 500,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 215, 0, 0.1),
                    blurRadius: 180,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          // Additional blur overlay for bottom - centered using Align, showing only half
          Align(
            alignment: const Alignment(0, 2.0), // Matching top ellipse's -2.0
            child: Container(
              width: 500, // Already matches top ellipse
              height: 400, // Already matches top ellipse
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 215, 0, 0.1),
                    blurRadius: 180,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/palm_logo.png'),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(300)),
                  ),
                ),
                // Welcome text
                const Text(
                  'Welcome To',
                  style: TextStyle(
                    fontFamily: 'Kokoro',
                    fontSize: 24,
                    color: Color.fromRGBO(255, 215, 0, 0.8),
                  ),
                ),
                // PALM HR text with less space between the two text elements
                const Text(
                  'PALM HR',
                  style: TextStyle(
                    fontFamily: 'Kokoro',
                    fontSize: 40,
                    color: Color.fromRGBO(255, 215, 0, 0.8),
                    shadows: [
                      Shadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Dots
                const Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Text(
                    '. . .',
                    style: TextStyle(
                      fontFamily: 'Kokoro',
                      fontSize: 40,
                      color: Color(0xFFD4AC0D),
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
}