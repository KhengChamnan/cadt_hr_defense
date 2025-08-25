import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// Section header widget for the team members section
/// 
/// This widget shows:
/// - Section title with member count
/// - Current view mode indicator (grid/list)
/// - Consistent styling with Palm HR theme
class TeamMembersSectionHeader extends StatelessWidget {
  /// Number of team members
  final int memberCount;
  
  /// Whether currently in grid view mode
  final bool isGridView;
  
  /// Creates a team members section header widget
  const TeamMembersSectionHeader({
    Key? key,
    required this.memberCount,
    required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1 - Section title with count
          Text(
            'Team Members ($memberCount)',
            style: PalmTextStyles.subheading.copyWith(
              color: PalmColors.textNormal,
            ),
          ),
          
          // 2 - View mode indicator
          Icon(
            isGridView ? Icons.grid_view : Icons.list,
            color: PalmColors.iconNormal,
            size: PalmIcons.size,
          ),
        ],
      ),
    );
  }
} 