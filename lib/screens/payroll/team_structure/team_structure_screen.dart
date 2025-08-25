import 'package:flutter/material.dart';

import '../../../models/team/team_member.dart';
import '../../../services/team_service.dart';
import '../../../widgets/loading_widget.dart';
import '../../settings/widgets/entity_details_screen.dart';
import 'widgets/team_leader_header.dart';
import 'widgets/team_member_dropdown_section.dart';
import 'widgets/team_members_section_header.dart';
import 'widgets/team_member_grid_view.dart';
import 'widgets/team_member_list_view.dart';
import 'widgets/no_team_members_state.dart';
import 'widgets/team_structure_app_bar.dart';

/// This screen allows users to:
/// - View team structure hierarchy
/// - Navigate through different team levels
/// - Switch between grid and list view modes
/// - Select team members to drill down into their teams
class TeamStructureScreen extends StatefulWidget {
  final TeamMember? initialTeamMember;
  final bool? isGridView;

  const TeamStructureScreen({
    Key? key,
    this.initialTeamMember,
    this.isGridView,
  }) : super(key: key);

  @override
  State<TeamStructureScreen> createState() => _TeamStructureScreenState();
}

class _TeamStructureScreenState extends State<TeamStructureScreen> {
  bool _isGridView = false;
  bool _isLoading = true;
  TeamMember? _currentTeamMember;
  TeamMember? _selectedMember;
  List<TeamMember> _breadcrumbPath = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize screen data and fetch team structure
  void _initializeData() async {
    setState(() {
      _isGridView = widget.isGridView ?? false;
      _isLoading = true;
    });

    if (widget.initialTeamMember != null) {
      // Use provided team member
      _currentTeamMember = widget.initialTeamMember!;
      setState(() {
        _isLoading = false;
      });
    } else {
      // Fetch team structure from service
      try {
        final teamData = await TeamService.fetchTeamStructure();
        _currentTeamMember = teamData;
      } catch (e) {
        // Handle error - for now just show empty state
        _currentTeamMember = TeamMember(
          id: 'error',
          name: 'Error loading team data',
        );
      }
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Navigate to a team member's subordinates or entity details
  void _navigateToMember(TeamMember member) {
    // Navigate to entity details screen with team member data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityDetailsScreen(
          showProfileCard: false, // Don't show ProfileCard when coming from team structure
          teamMember: member, // Pass the team member data directly
        ),
      ),
    );
  }

  /// Navigate to team member's subordinates (drill down)
  void _drillDownToMember(TeamMember member) {
    if (member.hasChildren && _currentTeamMember != null) {
      setState(() {
        _breadcrumbPath.add(_currentTeamMember!);
        _currentTeamMember = member;
        _selectedMember = null;
      });
    }
  }

  /// Navigate back to the previous level
  void _navigateBack() {
    if (_breadcrumbPath.isNotEmpty) {
      setState(() {
        _currentTeamMember = _breadcrumbPath.removeLast();
        _selectedMember = null;
      });
    } else {
      Navigator.pop(context);
    }
  }

  /// Handle dropdown member selection
  void _onMemberSelected(TeamMember? member) {
    if (member != null) {
      setState(() {
        _selectedMember = member;
      });
      // Navigate to selected member's team structure (drill down)
      _drillDownToMember(member);
    }
  }

  /// Toggle between grid and list view
  void _toggleViewMode(String viewMode) {
    setState(() {
      _isGridView = viewMode == 'grid';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TeamStructureAppBar(
        onBackPressed: _navigateBack,
        isGridView: _isGridView,
        onViewModeToggle: _toggleViewMode,
        currentTeamMember: _currentTeamMember,
        isRootLevel: _breadcrumbPath.isEmpty,
        breadcrumbPath: _breadcrumbPath,
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: LoadingWidget());
  }

  Widget _buildContent() {
    if (_currentTeamMember == null) {
      return const Center(child: LoadingWidget());
    }
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1 - Team leader header
          TeamLeaderHeader(teamLeader: _currentTeamMember!),
          
          // 2 - Member dropdown (only show if there are children)
          TeamMemberDropdownSection(
            members: _currentTeamMember!.children,
            selectedMember: _selectedMember,
            onMemberSelected: _onMemberSelected,
          ),
          
          // 3 - Members section header (only show if there are children)
          if (_currentTeamMember!.hasChildren)
            TeamMembersSectionHeader(
              memberCount: _currentTeamMember!.children.length,
              isGridView: _isGridView,
            ),
          
          // 4 - Members content
          _currentTeamMember!.hasChildren
              ? _buildMembersContent()
              : const NoTeamMembersState(),
        ],
      ),
    );
  }

  Widget _buildMembersContent() {
    if (_currentTeamMember == null) {
      return const Center(child: LoadingWidget());
    }
    
    return _isGridView 
        ? TeamMemberGridView(
            members: _currentTeamMember!.children,
            onMemberTap: _navigateToMember,
            onMemberLongPress: _drillDownToMember,
          )
        : TeamMemberListView(
            members: _currentTeamMember!.children,
            onMemberTap: _navigateToMember,
            onMemberLongPress: _drillDownToMember,
          );
  }
}

/// Main wrapper widget for team structure navigation
class MainTeamStructure extends StatelessWidget {
  const MainTeamStructure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    TeamMember? teamMember;
    bool? isGridView;
    
    if (arguments != null) {
      // Convert from old format to new model
      if (arguments['teams'] != null) {
        teamMember = TeamMember.fromJson(arguments['teams'] as Map<String, dynamic>);
      }
      isGridView = arguments['isGrid'] == '0' ? true : false;
    }
    
    return TeamStructureScreen(
      initialTeamMember: teamMember,
      isGridView: isGridView,
    );
  }
}
