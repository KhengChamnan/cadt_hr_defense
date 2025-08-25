import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String position;
  final String department;
  final String id;
  final String date;
  final String avatarPath;

  const ProfileCard({
    super.key,
    required this.name,
    required this.position,
    required this.department,
    required this.id,
    required this.date,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const Spacer(),
          _buildUserAvatar(),
        ],
      ),
    );
  }
  
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.how_to_reg, name),
        const SizedBox(height: 10),
        _buildInfoRow(Icons.badge, position),
        const SizedBox(height: 10),
        _buildInfoRow(Icons.business, department),
      ],
    );
  }
  
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF3C4045),
          ),
        ),
      ],
    );
  }
  
  Widget _buildUserAvatar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildIdBadge(),
        const SizedBox(height: 10),
        _buildAvatarImage(),
        const SizedBox(height: 10),
        _buildDateText(),
      ],
    );
  }
  
  Widget _buildIdBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        id,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF3C4045),
        ),
      ),
    );
  }
  
  Widget _buildAvatarImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.asset(
        avatarPath,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }
  
  Widget _buildDateText() {
    return Text(
      date,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
} 