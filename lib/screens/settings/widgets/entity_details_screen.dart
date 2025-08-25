import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/models/team/team_member.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/home/widgets/profile_card.dart';

/// EntityDetailsScreen displays comprehensive user profile information
/// This screen shows all available user details fetched from the API or TeamMember data
class EntityDetailsScreen extends StatefulWidget {
  final bool showProfileCard;
  final TeamMember? teamMember; // Optional team member data
  
  const EntityDetailsScreen({
    super.key,
    this.showProfileCard = true, // Default to true for backward compatibility
    this.teamMember, // Optional team member data for team structure navigation
  });

  @override
  State<EntityDetailsScreen> createState() => _EntityDetailsScreenState();
}

class _EntityDetailsScreenState extends State<EntityDetailsScreen> {
  @override
  void initState() {
    super.initState();
    print("🔍 EntityDetailsScreen: initState() called");
    // Remove the call from initState - we'll handle it in the Consumer like profile_card.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PalmColors.backGroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Entity Details',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.teamMember != null
          ? _buildTeamMemberContent() // Use team member data directly
          : _buildProfileProviderContent(), // Use ProfileProvider for settings navigation
    );
  }

  /// Build content using ProfileProvider (for settings navigation)
  Widget _buildProfileProviderContent() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final fullProfileValue = profileProvider.fullProfileInfo;
        
        print("🔍 EntityDetailsScreen: Consumer building, fullProfileValue state: ${fullProfileValue?.state}");
        
        if (fullProfileValue == null) {
          print("🔍 EntityDetailsScreen: fullProfileValue is null, calling getFullProfileInfo");
          // Fetch full profile info if not already loaded - same pattern as profile_card.dart
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("🔍 EntityDetailsScreen: About to call getFullProfileInfo() from Consumer");
            profileProvider.getFullProfileInfo();
          });
          return _buildLoadingState();
        }

        switch (fullProfileValue.state) {
          case AsyncValueState.loading:
            print("🔍 EntityDetailsScreen: State is loading");
            return _buildLoadingState();
          case AsyncValueState.success:
            print("🔍 EntityDetailsScreen: State is success, profile name: ${fullProfileValue.data?.name}");
            return _buildSuccessState(fullProfileValue.data!);
          case AsyncValueState.error:
            print("🔍 EntityDetailsScreen: State is error: ${fullProfileValue.error}");
            return _buildErrorState(
              fullProfileValue.error.toString(),
              () => profileProvider.getFullProfileInfo(),
            );
        }
      },
    );
  }

  /// Build content using TeamMember data (for team structure navigation)
  Widget _buildTeamMemberContent() {
    // Convert TeamMember to ProfileInfo
    final profileInfo = _convertTeamMemberToProfile(widget.teamMember!);
    return _buildSuccessState(profileInfo);
  }

  /// Convert TeamMember to ProfileInfo for display
  ProfileInfo _convertTeamMemberToProfile(TeamMember member) {
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
      companyName: 'Company Name', // Mock company
      branchName: 'Branch Name', // Mock branch
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(PalmColors.primary),
          ),
          const SizedBox(height: PalmSpacings.m),
          Text(
            'Loading entity details...',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: PalmColors.danger,
            ),
            const SizedBox(height: PalmSpacings.m),
            Text(
              'Failed to load entity details',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.danger,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PalmSpacings.s),
            Text(
              error,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutral,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PalmSpacings.m),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PalmColors.primary,
              ),
              child: Text(
                'Retry',
                style: TextStyle(color: PalmColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(ProfileInfo profile) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          children: [
            // Conditionally show ProfileCard based on navigation source
            if (widget.showProfileCard) ...[
              const ProfileCard(),
              const SizedBox(height: PalmSpacings.l),
            ],
            
            // Personal Information Section
            _buildSection(
              'Personal Information',
              [
                _buildDetailRow('Full Name', profile.name),
                _buildDetailRow('Gender', profile.title ?? '-'),
                _buildDetailRow('Nick Name', profile.nickName ?? '-'),
                _buildDetailRow('Date of Birth', profile.dob),
              ],
            ),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Contact Information Section
            _buildSection(
              'Contact Information',
              [
                _buildDetailRow('Email', profile.email),
                _buildDetailRow('Phone', profile.phone),
                _buildDetailRow('Phone 2', profile.phone2 ?? '-'),
                _buildDetailRow('Address', profile.address ?? '-'),
                _buildDetailRow('Facebook', profile.facebook ?? '-'),
              ],
            ),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Work Information Section
            _buildSection(
              'Work Information',
              [
                _buildDetailRow('Position', profile.position?.toString() ?? '-'),
                _buildDetailRow('Department', profile.department ?? '-'),
                _buildDetailRow('Date of Employment', profile.dateOfEmployment ?? '-'),
                _buildDetailRow('Manager', profile.managerName ?? '-'),
                _buildDetailRow('Supervisor', profile.supervisorName ?? '-'),
              ],
            ),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Organization Information Section
            _buildSection(
              'Organization Information',
              [
                _buildDetailRow('Company', profile.companyName ?? '-'),
                _buildDetailRow('Branch', profile.branchName ?? '-'),
                _buildDetailRow('Company ID', profile.companyId ?? '-'),
                _buildDetailRow('Branch ID', profile.branchId ?? '-'),
              ],
            ),
            
            const SizedBox(height: PalmSpacings.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(PalmSpacings.m),
            decoration: BoxDecoration(
              color: PalmColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PalmSpacings.radius),
                topRight: Radius.circular(PalmSpacings.radius),
              ),
            ),
            child: Text(
              title,
              style: PalmTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: PalmColors.primary,
              ),
            ),
          ),
          
          // Section Content
          Padding(
            padding: const EdgeInsets.all(PalmSpacings.m),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PalmSpacings.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: PalmTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: PalmColors.dark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutral,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 