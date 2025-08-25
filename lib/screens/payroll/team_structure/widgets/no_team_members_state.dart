import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// Empty state widget displayed when there are no team members
/// 
/// This widget shows:
/// - Descriptive icon
/// - Title and subtitle explaining the empty state
/// - Consistent styling with Palm HR theme
class NoTeamMembersState extends StatelessWidget {
  /// Creates a no team members empty state widget
  const NoTeamMembersState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1 - Icon indicating empty state
          Icon(
            Icons.people_outline,
            size: 64,
            color: PalmColors.greyDark,
          ),
          
          const SizedBox(height: PalmSpacings.l),
          
          // 2 - Main title
          Text(
            'No Team Members',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.textLight,
            ),
          ),
          
          const SizedBox(height: PalmSpacings.xs),
          
          // 3 - Descriptive subtitle
          Text(
            'This member doesn\'t have any direct reports.',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 