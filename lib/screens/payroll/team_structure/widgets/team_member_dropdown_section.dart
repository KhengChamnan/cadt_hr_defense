import 'package:flutter/material.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';
import 'team_member_dropdown.dart';

/// Dropdown section widget for team member selection
/// 
/// This widget provides:
/// - Searchable dropdown for team member selection
/// - Only displays when there are team members available
/// - Callback for member selection
class TeamMemberDropdownSection extends StatelessWidget {
  /// List of team members to display in dropdown
  final List<TeamMember> members;
  
  /// Currently selected member
  final TeamMember? selectedMember;
  
  /// Callback when a member is selected
  final Function(TeamMember?)? onMemberSelected;
  
  /// Creates a team member dropdown section widget
  const TeamMemberDropdownSection({
    Key? key,
    required this.members,
    this.selectedMember,
    this.onMemberSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show dropdown if there are members
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: TeamMemberDropdown(
        members: members,
        selectedMember: selectedMember,
        onChanged: onMemberSelected,
        hintText: 'Select a team member',
        enabled: true,
      ),
    );
  }
} 