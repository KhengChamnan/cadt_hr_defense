import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';

/// A dropdown widget for selecting team members in the team structure screen
/// 
/// This widget provides:
/// - Searchable dropdown functionality
/// - Team member profile pictures in dropdown items
/// - Custom Palm HR styling
/// - Callback for member selection
class TeamMemberDropdown extends StatefulWidget {
  /// List of team members to display in dropdown
  final List<TeamMember> members;
  
  /// Currently selected member
  final TeamMember? selectedMember;
  
  /// Callback when a member is selected
  final Function(TeamMember?)? onChanged;
  
  /// Hint text for the dropdown
  final String hintText;
  
  /// Whether the dropdown is enabled
  final bool enabled;
  
  /// Creates a team member dropdown widget
  const TeamMemberDropdown({
    Key? key,
    required this.members,
    this.selectedMember,
    this.onChanged,
    this.hintText = 'Select a member',
    this.enabled = true,
  }) : super(key: key);

  @override
  State<TeamMemberDropdown> createState() => _TeamMemberDropdownState();
}

class _TeamMemberDropdownState extends State<TeamMemberDropdown> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<TeamMember> _filteredMembers = [];

  @override
  void initState() {
    super.initState();
    _filteredMembers = widget.members;
  }

  @override
  void didUpdateWidget(TeamMemberDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.members != widget.members) {
      _filteredMembers = widget.members;
    }
  }

  void _filterMembers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = widget.members;
      } else {
        _filteredMembers = widget.members
            .where((member) =>
                member.name.toLowerCase().contains(query.toLowerCase()) ||
                (member.position?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _searchController.clear();
        _filteredMembers = widget.members;
      }
    });
  }

  void _selectMember(TeamMember? member) {
    setState(() {
      _isExpanded = false;
      _searchController.clear();
      _filteredMembers = widget.members;
    });
    widget.onChanged?.call(member);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1 - Main dropdown trigger
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PalmSpacings.m,
              vertical: PalmSpacings.s,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isExpanded 
                    ? PalmColors.primary 
                    : PalmColors.greyLight,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              color: widget.enabled ? Colors.white : PalmColors.greyLight.withOpacity(0.3),
            ),
            child: Row(
              children: [
                // Display selected member or hint
                Expanded(
                  child: widget.selectedMember != null
                      ? _buildSelectedMemberDisplay()
                      : Text(
                          widget.hintText,
                          style: PalmTextStyles.body.copyWith(
                            color: PalmColors.textLight,
                          ),
                        ),
                ),
                
                // Dropdown arrow
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: widget.enabled ? PalmColors.iconNormal : PalmColors.disabled,
                ),
              ],
            ),
          ),
        ),
        
        // 2 - Dropdown content when expanded
        if (_isExpanded && widget.enabled) ...[
          const SizedBox(height: PalmSpacings.xxs),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              border: Border.all(color: PalmColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search field
                Padding(
                  padding: const EdgeInsets.all(PalmSpacings.xs),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterMembers,
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      hintStyle: PalmTextStyles.label.copyWith(
                        color: PalmColors.textLight,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: PalmColors.iconLight,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(PalmSpacings.xs),
                        borderSide: BorderSide(color: PalmColors.greyLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(PalmSpacings.xs),
                        borderSide: BorderSide(color: PalmColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: PalmSpacings.s,
                        vertical: PalmSpacings.xs,
                      ),
                    ),
                    style: PalmTextStyles.body,
                  ),
                ),
                
                const Divider(height: 1),
                
                // Member list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      final isSelected = widget.selectedMember?.id == member.id;
                      
                      return InkWell(
                        onTap: () => _selectMember(member),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PalmSpacings.m,
                            vertical: PalmSpacings.s,
                          ),
                          color: isSelected 
                              ? PalmColors.primary.withOpacity(0.1)
                              : null,
                          child: Row(
                            children: [
                              // Profile picture
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  imageUrl: member.displayProfilePicture,
                                  placeholder: (context, url) => Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: PalmColors.greyLight,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: PalmColors.greyLight,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: PalmSpacings.s),
                              
                              // Member details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: PalmTextStyles.body.copyWith(
                                        color: isSelected 
                                            ? PalmColors.primary 
                                            : PalmColors.textNormal,
                                        fontWeight: isSelected 
                                            ? FontWeight.w600 
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (member.position != null)
                                      Text(
                                        member.position!,
                                        style: PalmTextStyles.label.copyWith(
                                          color: PalmColors.textLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              
                              // Selection indicator
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: PalmColors.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedMemberDisplay() {
    final member = widget.selectedMember!;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            imageUrl: member.displayProfilePicture,
            placeholder: (context, url) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: PalmColors.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                size: 14,
                color: Colors.grey,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: PalmColors.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: PalmSpacings.xs),
        Expanded(
          child: Text(
            member.name,
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textNormal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 