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
          // Top blur effect (gold ellipse)
          Positioned(
            top: -188,
            left: -30,
            child: Container(
              width: 489,
              height: 369,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 215, 0, 0.2),
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
          // Bottom blur effect (gold ellipse)
          Positioned(
            bottom: -189,
            left: -15,
            child: Container(
              width: 491,
              height: 299,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 215, 0, 0.2),
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
                const SizedBox(height: 20),
                // Welcome text
                const Text(
                  'Welcome To',
                  style: TextStyle(
                    fontFamily: 'Kokoro',
                    fontSize: 24,
                    color: Color.fromRGBO(255, 215, 0, 0.8),
                  ),
                ),
                // PALM HR text
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
                const SizedBox(height: 200),
                // Dots
                const Text(
                  '. . .',
                  style: TextStyle(
                    fontFamily: 'Kokoro',
                    fontSize: 40,
                    color: Color(0xFFD4AC0D),
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