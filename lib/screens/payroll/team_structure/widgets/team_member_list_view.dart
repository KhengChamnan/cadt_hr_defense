import 'package:flutter/material.dart';
import '../../../../models/team/team_member.dart';
import 'team_member_list_tile.dart';

/// List view widget for displaying team members in a list layout
/// 
/// This widget shows:
/// - Team members in a vertical list
/// - Tap functionality for navigation to entity details
/// - Long press for drilling down to team members (if they have children)
/// - Compact view with member details
class TeamMemberListView extends StatelessWidget {
  /// List of team members to display
  final List<TeamMember> members;
  
  /// Callback when a member tile is tapped (for entity details)
  final Function(TeamMember)? onMemberTap;
  
  /// Callback when a member tile is long pressed (for drill down navigation)
  final Function(TeamMember)? onMemberLongPress;
  
  /// Creates a team member list view widget
  const TeamMemberListView({
    Key? key,
    required this.members,
    this.onMemberTap,
    this.onMemberLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return TeamMemberListTile(
          member: member,
          onTap: () => onMemberTap?.call(member),
          onLongPress: member.hasChildren ? () => onMemberLongPress?.call(member) : null,
          showMemberCount: true,
        );
      },
    );
  }
} 