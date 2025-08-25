import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/auth_screen/signup_signin/sign_in/sign_in_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/bottom_navigator.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState(); // Call super.initState() first
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final String? token = await authProvider.getToken();
      
      if (mounted) {
        if (token != null) {
          authProvider.setIsLoggedIn(true);
        } else {
          authProvider.setIsLoggedIn(false);
        }
        
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking auth
    if (_isLoading) {
      
      return const SplashScreen();
    }
    
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Check authentication status
        if (authProvider.isLoggedIn) {
          // User is logged in, show home screen
          return const BottomNavBar();
        } else {
          // User is not logged in, show login screen
          return const SignInScreen();
        }
      },
    );
  }
}
