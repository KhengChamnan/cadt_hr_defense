// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/app_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/settings/setting_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/report_screen.dart';

import 'package:palm_ecommerce_mobile_app_2/utils/location_management.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/settings_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key, Function? function}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String storeToken = '';
  int _selectedIndex = 0;
  bool _lastLoginState = true; // Track last known login state

  final _screens = [
    const HomeScreen(),
    const AppFeature(),
    const ReportScreen(),
    const SettingScreen(),
  ];

  before() async {
    Position position = await getGeoLocationPosition();
    location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    getAddressFromLatLong(position);
  }

  @override
  void initState() {
    before();
    super.initState();
    
    // Listen for auth state changes to clear provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAuthListener();
    });
  }

  void _setupAuthListener() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _lastLoginState = authProvider.isLoggedIn;
  }

  void _checkAuthStateChange(AuthProvider authProvider) {
    // If user was logged out but now is logged in, trigger profile loading
    if (!_lastLoginState && authProvider.isLoggedIn) {
      _loadProfileAfterLogin();
    }
    
    // If user was logged in but now isn't, clear all provider data
    if (_lastLoginState && !authProvider.isLoggedIn) {
      _clearAllProviderData();
    }
    
    _lastLoginState = authProvider.isLoggedIn;
  }

  void _loadProfileAfterLogin() {
    print('🔄 BottomNavigator: User logged in, triggering data load...');
    
    // Use post-frame callback to ensure auth state is fully settled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      try {
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
        final approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
        
        // Load profile, settings, and approval data after auth
        profileProvider.loadProfileAfterAuth();
        settingsProvider.loadSettingsAfterAuth();
        approvalProvider.loadApprovalAfterAuth();
        
        print('✅ All provider data loading triggered after login');
      } catch (e) {
        print('❌ Error triggering data load: $e');
      }
    });
  }

  void _clearAllProviderData() {
    // Use post-frame callback to ensure widgets are still mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      try {
        // Clear profile provider data
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        profileProvider.clearProfileInfo();
        
        // Clear settings provider data  
        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
        settingsProvider.clearAllData();
        
        // Clear approval provider data
        final approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
        approvalProvider.clearApprovalDashboard();
        
        print('✅ All provider data cleared after logout detection');
      } catch (e) {
        print('❌ Error clearing provider data: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check for auth state changes to clear provider data
        _checkAuthStateChange(authProvider);
        
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = screenWidth / 5; // Slightly smaller than 1/4 to ensure spacing
        
        Widget customBottomNav() {
          return Container(
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, -4),
                  spreadRadius: 0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomNavItem(0, 'Home', 'assets/figma_icons/home_icon.png', itemWidth),
                _buildBottomNavItem(1, 'App', 'assets/figma_icons/app_icon.png', itemWidth),
                _buildBottomNavItem(2, 'Report', 'assets/figma_icons/report_icon.png', itemWidth),
                _buildBottomNavItem(3, 'Setting', 'assets/figma_icons/setting_icon.png', itemWidth),
              ],
            ),
          );
        }

        return Scaffold(
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: customBottomNav(),
          ),
          body: Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: _selectedIndex != i,
                      child: screen,
                    )))
                .values
                .toList(),
          ),
        );
      },
    );
  }
  
  Widget _buildBottomNavItem(int index, String label, String iconPath, double width) {
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: isSelected ? width * 1.6 : width,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C96CB) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 4,
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurStyle: BlurStyle.normal,
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: isSelected ? 30 : 25,
              height: isSelected ? 30 : 25,
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}