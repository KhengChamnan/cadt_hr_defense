import 'package:flutter/material.dart';

class AttendanceHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onDateTap;

  const AttendanceHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.onDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      color: const Color(0xFFD4AC0D), // Gold color from Figma
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          // Make date section tappable
          InkWell(
            onTap: onDateTap,
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
