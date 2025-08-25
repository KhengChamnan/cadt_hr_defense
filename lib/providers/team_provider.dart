import 'package:flutter/material.dart';
import '../models/team/team_member.dart';
import '../models/profile/profile.dart';
import '../providers/asyncvalue.dart';
import '../services/team_service.dart';

/// Provider for team-related data and operations
/// Follows the AsyncValue pattern for consistent state management
class TeamProvider extends ChangeNotifier {
  // Team structure data
  AsyncValue<TeamMember>? _teamStructure;
  
  // Selected team member details (for entity details screen)
  AsyncValue<ProfileInfo>? _selectedMemberProfile;
  
  // Current selected team member
  TeamMember? _currentSelectedMember;

  // Getters
  AsyncValue<TeamMember>? get teamStructure => _teamStructure;
  AsyncValue<ProfileInfo>? get selectedMemberProfile => _selectedMemberProfile;
  TeamMember? get currentSelectedMember => _currentSelectedMember;

  /// Fetch the complete team structure
  Future<void> getTeamStructure() async {
    print("🏢 TeamProvider: getTeamStructure() called");
    
    // Prevent multiple simultaneous calls
    if (_teamStructure?.state == AsyncValueState.loading) {
      print("🏢 TeamProvider: Already loading team structure, returning early");
      return;
    }
    
    print("🏢 TeamProvider: Setting loading state for team structure");
    _teamStructure = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🏢 TeamProvider: Notifying loading state for team structure");
      notifyListeners();
    });

    try {
      print("🏢 TeamProvider: Calling TeamService.fetchTeamStructure()");
      final teamData = await TeamService.fetchTeamStructure();
      print("🏢 TeamProvider: Team structure loaded successfully, root: ${teamData.name}");
      _teamStructure = AsyncValue.success(teamData);
    } catch (e) {
      print("🏢 TeamProvider: Failed to load team structure: $e");
      _teamStructure = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🏢 TeamProvider: Notifying final state for team structure: ${_teamStructure?.state}");
      notifyListeners();
    });
  }

  /// Get detailed profile information for a specific team member
  Future<void> getTeamMemberProfile(TeamMember member) async {
    print("👤 TeamProvider: getTeamMemberProfile() called for ${member.name}");
    
    // Set the current selected member
    _currentSelectedMember = member;
    
    // Prevent multiple simultaneous calls for the same member
    if (_selectedMemberProfile?.state == AsyncValueState.loading) {
      print("👤 TeamProvider: Already loading member profile, returning early");
      return;
    }
    
    print("👤 TeamProvider: Setting loading state for member profile");
    _selectedMemberProfile = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("👤 TeamProvider: Notifying loading state for member profile");
      notifyListeners();
    });

    try {
      print("👤 TeamProvider: Converting TeamMember to ProfileInfo for ${member.name}");
      final profileInfo = _convertTeamMemberToProfile(member);
      print("👤 TeamProvider: Member profile converted successfully");
      _selectedMemberProfile = AsyncValue.success(profileInfo);
    } catch (e) {
      print("👤 TeamProvider: Failed to load member profile: $e");
      _selectedMemberProfile = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("👤 TeamProvider: Notifying final state for member profile: ${_selectedMemberProfile?.state}");
      notifyListeners();
    });
  }

  /// Convert TeamMember to ProfileInfo for the entity details screen
  ProfileInfo _convertTeamMemberToProfile(TeamMember member) {
    // For now, create a mock ProfileInfo based on TeamMember data
    // TODO: Replace with actual API call when backend is available
    return ProfileInfo(
      profileId: member.id,
      name: member.name,
      email: member.email ?? 'email@company.com',
      phone: member.phone ?? '+1-555-0000',
      profileImage: member.displayProfilePicture,
      gender: 'Other', // Mock gender
      dob: '1990-01-01', // Mock date
      status: 'Active', // Mock status
      memberSince: '2020-01-01', // Mock member since date
      phone2: null,
      address: 'Company Address, City, State',
      title: 'Mr./Ms.', // Mock title
      nickName: member.name.split(' ').first, // Use first name as nickname
      position: member.position,
      department: member.department,
      dateOfEmployment: '2020-01-01', // Mock employment date
      managerName: 'Manager Name', // Mock manager
      supervisorName: 'Supervisor Name', // Mock supervisor
      companyName: 'Palm HR Company', // Mock company
      branchName: 'Main Branch', // Mock branch
      companyId: 'COMP001', // Mock company ID
      branchId: 'BR001', // Mock branch ID
      facebook: null,
    );
  }

  /// Safe method to get team structure that can be called during build
  void getTeamStructureSafe() {
    // Only proceed if not already loading or loaded
    if (_teamStructure?.state == AsyncValueState.loading) return;
    if (_teamStructure?.state == AsyncValueState.success) return;
    
    // Schedule the actual call after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTeamStructure();
    });
  }

  /// Safe method to get team member profile that can be called during build
  void getTeamMemberProfileSafe(TeamMember member) {
    // Only proceed if not already loading the same member
    if (_selectedMemberProfile?.state == AsyncValueState.loading && 
        _currentSelectedMember?.id == member.id) return;
    
    // Schedule the actual call after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTeamMemberProfile(member);
    });
  }

  /// Search team members by name
  List<TeamMember> searchMembers(String query) {
    if (_teamStructure?.state != AsyncValueState.success || _teamStructure?.data == null) {
      return [];
    }
    
    return TeamService.searchMembers(_teamStructure!.data!, query);
  }

  /// Get flattened list of all team members
  List<TeamMember> getFlatMembersList() {
    if (_teamStructure?.state != AsyncValueState.success || _teamStructure?.data == null) {
      return [];
    }
    
    return TeamService.getFlatMembersList(_teamStructure!.data!);
  }

  /// Clear all team data (useful for logout/login scenarios)
  void clearTeamData() {
    _teamStructure = null;
    _selectedMemberProfile = null;
    _currentSelectedMember = null;
    notifyListeners();
  }

  /// Clear selected member profile data
  void clearSelectedMemberProfile() {
    _selectedMemberProfile = null;
    _currentSelectedMember = null;
    notifyListeners();
  }
}
