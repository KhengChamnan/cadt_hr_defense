import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/team/team_member.dart';

/// Custom app bar for the team structure screen
/// 
/// This widget provides:
/// - Consistent styling with Palm HR theme
/// - Back navigation functionality
/// - View toggle popup menu (grid/list)
/// - Contextual team information display
/// - Professional appearance
class TeamStructureAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback for back navigation
  final VoidCallback? onBackPressed;
  
  /// Whether currently in grid view mode
  final bool isGridView;
  
  /// Callback for view mode toggle
  final Function(String)? onViewModeToggle;
  
  /// Current team member being displayed
  final TeamMember? currentTeamMember;
  
  /// Whether this is the root/main team view
  final bool isRootLevel;
  
  /// Breadcrumb path for navigation context
  final List<TeamMember>? breadcrumbPath;
  
  /// Creates a team structure app bar widget
  const TeamStructureAppBar({
    Key? key,
    this.onBackPressed,
    required this.isGridView,
    this.onViewModeToggle,
    this.currentTeamMember,
    this.isRootLevel = true,
    this.breadcrumbPath,
  }) : super(key: key);

  /// Get the appropriate title based on current context
  String _getTitle() {
    if (isRootLevel || currentTeamMember == null) {
      return "Team Structure";
    }
    
    // Show team leader's name with "Team" suffix
    return "${currentTeamMember!.name}'s Team";
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: PalmColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        _getTitle(),
        style: PalmTextStyles.title.copyWith(color: Colors.white),
      ),
      actions: [
        // 1 - View toggle menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.view_module, color: Colors.white),
          onSelected: onViewModeToggle,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'grid',
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view,
                    color: isGridView ? PalmColors.primary : PalmColors.greyDark,
                  ),
                  const SizedBox(width: PalmSpacings.xs),
                  Text(
                    'Grid View',
                    style: TextStyle(
                      color: isGridView ? PalmColors.primary : PalmColors.textNormal,
                      fontWeight: isGridView ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'list',
              child: Row(
                children: [
                  Icon(
                    Icons.list,
                    color: !isGridView ? PalmColors.primary : PalmColors.greyDark,
                  ),
                  const SizedBox(width: PalmSpacings.xs),
                  Text(
                    'List View',
                    style: TextStyle(
                      color: !isGridView ? PalmColors.primary : PalmColors.textNormal,
                      fontWeight: !isGridView ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 