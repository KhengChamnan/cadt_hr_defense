import 'package:flutter/material.dart';

class ProfileNote extends StatelessWidget {
  final String text;
  
  const ProfileNote({
    super.key,
    this.text = 'Note: Personal Information is automatically filled from your profile.',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      ),
    );
  }
} 