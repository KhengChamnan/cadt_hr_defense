import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color statusBarColor;
  final double height;
  
  const SimpleAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF2C5282),
    this.statusBarColor = Colors.black,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    
    return Column(
      children: [
        // Status bar area
        Container(
          color: statusBarColor,
          height: MediaQuery.of(context).padding.top,
          width: double.infinity,
        ),
        // App bar content
        Container(
          height: height,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
} 