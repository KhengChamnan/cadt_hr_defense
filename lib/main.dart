//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/app.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/repository_factory.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/home/home_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/splash/splash_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/splash/test/splash_screen_test2.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/theme_config.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/bottom_navigator.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable mock repositories for testing while server is down
  final repositoryFactory = RepositoryFactory();
  repositoryFactory.setUseMockRepositories(false); // Set to true for all mocks, but leaves mock is already enabled separately
  
  // Initialize other services here if needed
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PALM HR',
      theme: themeData(ThemeConfig.lightTheme),
      home:  const SplashScreenTest2(),
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(

      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
    );
  }
}
