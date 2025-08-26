import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/settings_section.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/company_profile_card.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/contact_info_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/about_us_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/policy_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/widgets/entity_details_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auth_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/settings_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

/// SettingScreen displays the user profile information and settings
/// - Shows company profile information at the top
/// - Provides access to account settings
/// - Offers help and support options
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider =
          Provider.of<SettingsProvider>(context, listen: false);
      settingsProvider.loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PalmColors.backGroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Settings',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                // Get all providers
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final settingsProvider =
                    Provider.of<SettingsProvider>(context, listen: false);
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                final approvalProvider =
                    Provider.of<ApprovalProvider>(context, listen: false);
                final staffProvider =
                    Provider.of<StaffProvider>(context, listen: false);

                // Clear all provider data first
                print('🔄 Starting logout process...');
                settingsProvider.clearAllData();
                profileProvider.clearProfileInfo();
                approvalProvider.clearApprovalDashboard();
                staffProvider.clearStaffInfo(); // Clear staff data too
                print('✅ All provider data cleared');

                // Then logout
                await authProvider.logoutEnhanced();
                print('✅ Auth logout completed');

                // Navigate directly to sign in screen
                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthWrapper()));
                }
              } catch (e) {
                print('❌ Logout error: $e');
                // Still try to navigate even if there's an error
                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthWrapper()));
                }
              }
            },
          ),
        ],
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
              child: Column(
                children: [
                  SizedBox(height: PalmSpacings.m),

                  // Company profile header - populated from API
                  _buildCompanyProfileSection(settingsProvider),

                  SizedBox(height: PalmSpacings.l),

                  // Account settings section
                  SettingsSection(
                    title: 'Accounts',
                    items: [
                      SettingItem(
                        icon: Icons.person,
                        title: 'Entity Details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EntityDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      SettingItem(
                        icon: Icons.location_on,
                        title: 'Location & Grade Details',
                        onTap: () {
                          // Handle location details tap
                        },
                      ),
                      SettingItem(
                        icon: Icons.credit_card,
                        title: 'Finance Details',
                        onTap: () {
                          // Handle finance details tap
                        },
                        isLast: true,
                      ),
                    ],
                  ),

                  SizedBox(height: PalmSpacings.l),

                  // Company Settings
                  SettingsSection(
                    title: 'Company',
                    items: [
                      SettingItem(
                        icon: Icons.business,
                        title: 'Company Information',
                        onTap: () {
                          // Handle company info tap
                        },
                      ),
                      SettingItem(
                        icon: Icons.location_city,
                        title: 'Branches',
                        onTap: () {
                          // Handle branches tap
                        },
                      ),
                      SettingItem(
                        icon: Icons.groups,
                        title: 'Departments',
                        onTap: () {
                          // Handle departments tap
                        },
                      ),
                      SettingItem(
                        icon: Icons.group,
                        title: 'Organization',
                        onTap: () {
                          // Handle team members tap
                        },
                      ),
                      SettingItem(
                        icon: Icons.history,
                        title: 'Company History',
                        onTap: () {
                          // Handle company history tap
                        },
                        isLast: true,
                      ),
                    ],
                  ),

                  SizedBox(height: PalmSpacings.l),

                  // Help & Support section - Updated to use API data
                  _buildHelpSupportSection(settingsProvider),

                  SizedBox(height: PalmSpacings.l),

                  // Social Media section - Based on API contact_us data

                  SizedBox(height: PalmSpacings.xxl * 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyProfileSection(SettingsProvider settingsProvider) {
    final settingsValue = settingsProvider.settingsValue;

    if (settingsValue == null) {
      return _buildLoadingCard('Loading company information...');
    }

    switch (settingsValue.state) {
      case AsyncValueState.loading:
        return _buildLoadingCard('Loading company information...');
      case AsyncValueState.success:
        final settings = settingsValue.data!;
        return CompanyProfileCard(
          logoPath: settings.data.contactUs.photo.isNotEmpty
              ? settings.data.contactUs.photo
              : 'assets/images/palm_logo.png',
          companyName:
              'Buntheuorn PhoneShop', // Could be extracted from settings if available
          contactInfo:
              '${settings.data.contactUs.phone} | ${settings.data.contactUs.email}',
          location: settings.data.contactUs.address,
        );
      case AsyncValueState.error:
        return _buildErrorCard(
          'Failed to load company information',
          () => settingsProvider.loadSettings(),
        );
    }
  }

  Widget _buildHelpSupportSection(SettingsProvider settingsProvider) {
    return SettingsSection(
      title: 'Help & Support',
      items: [
        SettingItem(
          icon: Icons.call,
          title: 'Contact Us',
          subtitle: 'Get in touch with our support team',
          onTap: () async {
            await settingsProvider.getContactInfo();
            if (settingsProvider.contactInfoValue?.state ==
                    AsyncValueState.success &&
                mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactInfoScreen(
                    contactInfo: settingsProvider.contactInfoValue!.data!,
                  ),
                ),
              );
            } else if (settingsProvider.contactInfoValue?.state ==
                AsyncValueState.error) {
              _showErrorSnackBar('Failed to load contact information');
            }
          },
        ),
        SettingItem(
          icon: Icons.person_outline,
          title: 'About Us',
          subtitle: 'Learn more about our company',
          onTap: () async {
            await settingsProvider.getAboutInfo();
            if (settingsProvider.aboutInfoValue?.state ==
                    AsyncValueState.success &&
                mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(
                    aboutInfo: settingsProvider.aboutInfoValue!.data!,
                  ),
                ),
              );
            } else if (settingsProvider.aboutInfoValue?.state ==
                AsyncValueState.error) {
              _showErrorSnackBar('Failed to load about information');
            }
          },
        ),
        SettingItem(
          icon: Icons.info_outline,
          title: 'Terms & Conditions',
          subtitle: 'Read our terms and conditions',
          onTap: () async {
            await _navigateToPolicy(
                'Terms & Conditions', settingsProvider, 'terms');
          },
        ),
        SettingItem(
          icon: Icons.policy_outlined,
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          onTap: () async {
            await _navigateToPolicy(
                'Privacy Policy', settingsProvider, 'privacy');
          },
        ),
        SettingItem(
          icon: Icons.assignment_return_outlined,
          title: 'Return Policy',
          subtitle: 'Learn about our return policy',
          onTap: () async {
            await _navigateToPolicy(
                'Return Policy', settingsProvider, 'return');
          },
        ),
        SettingItem(
          icon: Icons.article_outlined,
          title: 'Article Categories',
          onTap: () {
            // Navigate to article categories screen with API data
          },
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius - 3),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(PalmColors.primary),
            ),
            const SizedBox(width: PalmSpacings.m),
            Text(
              message,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutral,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, VoidCallback onRetry) {
    return Container(
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius - 3),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: PalmColors.danger,
                ),
                const SizedBox(width: PalmSpacings.s),
                Expanded(
                  child: Text(
                    message,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.danger,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PalmSpacings.s),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToPolicy(String title,
      SettingsProvider settingsProvider, String policyType) async {
    // Show loading indicator
    _showLoadingSnackBar('Loading $title...');

    // Load settings if not available
    if (settingsProvider.settingsValue?.state != AsyncValueState.success) {
      await settingsProvider.loadSettings();
    }

    if (settingsProvider.settingsValue?.state == AsyncValueState.success &&
        mounted) {
      final settings = settingsProvider.settingsValue!.data!;
      String content = '';

      switch (policyType) {
        case 'terms':
          content = settings.data.termCondition.termCondition;
          break;
        case 'privacy':
          content = settings.data.policyPrivacy.policyPrivacy;
          break;
        case 'return':
          content = settings.data.returnPolicy.returnPolicy;
          break;
      }

      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PolicyScreen(
            title: title,
            content: content,
          ),
        ),
      );
    } else if (settingsProvider.settingsValue?.state == AsyncValueState.error) {
      _showErrorSnackBar('Failed to load $title');
    }
  }

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(PalmColors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: PalmColors.primary,
        duration: const Duration(seconds: 30), // Long duration for loading
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: PalmColors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: PalmColors.danger,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
