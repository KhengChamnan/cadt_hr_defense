import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/settings_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/home/widgets/pending_icon.dart';
import 'package:provider/provider.dart';

class PalmAppBar extends StatelessWidget {
  final String? username;
  final String? welcomeText;
  final String? avatarPath;

  const PalmAppBar({
    super.key, 
    this.username,
    this.welcomeText = 'Welcome back!',
    this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to have black status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    
    return Consumer2<ProfileProvider, SettingsProvider>(
      builder: (context, profileProvider, settingsProvider, _) {
        final profileInfo = profileProvider.profileInfo;
        final settingsData = settingsProvider.settingsValue;
        
        // If profile hasn't been loaded yet, trigger the loading
        if (profileInfo == null) {
          profileProvider.getProfileInfoSafe();
        }
        
        // If settings haven't been loaded yet, trigger the loading
        if (settingsData == null) {
          settingsProvider.loadSettings();
        }
        
        return Column(
          children: [
            // Black area for notch
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).padding.top,
              width: double.infinity,
            ),
            // Actual app bar content
            Container(
              height: 75,
              color: const Color(0xFF2C5282), // Dark blue from Figma design
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Company logo image
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: ClipOval(
                      child: _buildCompanyLogo(settingsData),
                    ),
                  ),
                  const SizedBox(width: 9), // Space between avatar and text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome back text and company name
                      _buildWelcomeWithCompanyName(settingsData),
                    ],
                  ),
                  const Spacer(), // Add spacer to push any future elements to the right
                  
                  // Pending approvals section with real approval data
                  const PendingIcon(),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  // Helper method to determine if the logoPath is a URL or local asset
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  Widget _buildCompanyLogo(AsyncValue<SettingsModel>? settingsData) {
    String logoPath = 'assets/images/palm_logo.png'; // Default logo
    
    // If settings data is available and successful
    if (settingsData != null && 
        settingsData.state == AsyncValueState.success && 
        settingsData.data != null) {
      final settings = settingsData.data!;
      final companyPhoto = settings.data.contactUs.photo;
      
      // If company photo is available and not empty, use it
      if (companyPhoto.isNotEmpty) {
        logoPath = companyPhoto;
      }
    }
    
    return Image(
      image: _getImageProvider(logoPath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default logo if image fails to load
        return Image.asset(
          'assets/images/palm_logo.png',
          fit: BoxFit.cover,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildWelcomeWithCompanyName(AsyncValue<SettingsModel>? settingsData) {
    const welcomeTextStyle = TextStyle(
      color: Color(0xFFF5F5F5),
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter',
    );
    
    const companyTextStyle = TextStyle(
      color: Color(0xFFF5F5F5),
      fontSize: 11,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back!', style: welcomeTextStyle),
        const SizedBox(height: 2),
        Text('Buntheoun Phone Shop', style: companyTextStyle),
      ],
    );
  }
}