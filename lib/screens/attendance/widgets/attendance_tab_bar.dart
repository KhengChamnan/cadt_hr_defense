import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AttendanceTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const AttendanceTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m, vertical: PalmSpacings.m),
      child: Row(
        children: [
          Expanded(child: _buildTabItem('All', 0)),
          const SizedBox(width: PalmSpacings.s),
          Expanded(child: _buildTabItem('Weekly', 1)),
          const SizedBox(width: PalmSpacings.s),
          Expanded(child: _buildTabItem('Monthly', 2)),
          const SizedBox(width: PalmSpacings.s),
          Expanded(child: _buildTabItem('Yearly', 3)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF2C5282),
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          border: isSelected 
              ? Border.all(color: PalmColors.white, width: 2) 
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: PalmTextStyles.button.copyWith(
              color: isSelected ? const Color(0xFF4F71DE) : PalmColors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
} 