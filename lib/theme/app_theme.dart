import 'package:flutter/material.dart';

///
/// Definition of App colors.
///
class PalmColors {
  static Color primary            = const Color(0xFF2C5282); // Primary color
  static Color primaryLight       = const Color(0xFF3182CE); // Primary light
  static Color primaryDark        = const Color(0xFF1A365D); // Primary dark
  static Color secondary          = const Color(0xFF4299E1); // Secondary color
  static Color success            = const Color(0xFF38A169); // Success color
  static Color warning            = const Color(0xFFED8936); // Warning color
  static Color danger             = const Color(0xFFE53E3E); // Danger color
  static Color info               = const Color(0xFF3182CE); // Info color
  static Color dark               = const Color(0xFF2D3748); // Dark color

  static Color backgroundAccent   = const Color(0xFFEDEDED);
 
  static Color neutralDark        = const Color(0xFF054752);
  static Color neutral            = const Color(0xFF3d5c62);
  static Color neutralLight       = const Color(0xFF708c91);
  static Color neutralLighter     = const Color(0xFF92A7AB);

  static Color greyLight          = const Color(0xFFE2E2E2);
  static Color greyDark           = const Color(0xFF718096); // Added for bottom nav and text
  
  static Color white              = Colors.white;

  // Sidebar colors
  static Color sidebarBg          = const Color(0xFF2C5282);
  static Color sidebarHover       = const Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)
  static Color sidebarActive      = const Color(0x33FFFFFF); // rgba(255, 255, 255, 0.2)

  static Color get backGroundColor { 
    return PalmColors.primary;
  }

  static Color get textNormal {
    return PalmColors.dark;
  }

  static Color get textLight {
    return PalmColors.neutralLight;
  }

  static Color get iconNormal {
    return PalmColors.neutral;
  }

  static Color get iconLight {
    return PalmColors.neutralLighter;
  }

  static Color get disabled {
    return PalmColors.greyLight;
  }
}
  
///
/// Definition of App text styles.
///
class PalmTextStyles {
  static TextStyle heading = const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'Eesti');
  
  static TextStyle subheading = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Eesti');

  static TextStyle title = const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Eesti');

  static TextStyle body = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Eesti');

  static TextStyle label = const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontFamily: 'Eesti');

  static TextStyle caption = const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Eesti');

  static TextStyle button = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Eesti');
}

///
/// Definition of App spacings, in pixels.
/// Bascially small (S), medium (m), large (l), extra large (x), extra extra large (xxl)
///
class PalmSpacings {
  static const double xxs=4;
  static const double xs = 8;     // Added extra small spacing
  static const double s = 12;
  static const double m = 16; 
  static const double l = 24; 
  static const double xl = 32; 
  static const double xxl = 40; 

  static const double radius = 16; 
  static const double radiusLarge = 24; 
}

///
/// Definition of App icons sizes.
///
class PalmIcons {
  static const double size = 24;
}

///
/// Definition of App Theme.
///
ThemeData appTheme = ThemeData(
  fontFamily: 'Eesti',
  scaffoldBackgroundColor: Colors.white,
  primaryColor: PalmColors.primary,
  colorScheme: ColorScheme.light(
    primary: PalmColors.primary,
    secondary: PalmColors.secondary,
    error: PalmColors.danger,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Eesti'),
    displayMedium: TextStyle(fontFamily: 'Eesti'),
    displaySmall: TextStyle(fontFamily: 'Eesti'),
    headlineLarge: TextStyle(fontFamily: 'Eesti'),
    headlineMedium: TextStyle(fontFamily: 'Eesti'),
    headlineSmall: TextStyle(fontFamily: 'Eesti'),
    titleLarge: TextStyle(fontFamily: 'Eesti'),
    titleMedium: TextStyle(fontFamily: 'Eesti'),
    titleSmall: TextStyle(fontFamily: 'Eesti'),
    bodyLarge: TextStyle(fontFamily: 'Eesti'),
    bodyMedium: TextStyle(fontFamily: 'Eesti'),
    bodySmall: TextStyle(fontFamily: 'Eesti'),
    labelLarge: TextStyle(fontFamily: 'Eesti'),
    labelMedium: TextStyle(fontFamily: 'Eesti'),
    labelSmall: TextStyle(fontFamily: 'Eesti'),
  ),
);
 