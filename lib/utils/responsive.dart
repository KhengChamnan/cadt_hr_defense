// responsive_helper.dart
import 'package:flutter/material.dart';

class MobileResponsive {
  // Single breakpoint for mobile apps - phone vs tablet
  static const double tabletBreakpoint = 600.0;
  
  // Device detection
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletBreakpoint;
  }
  
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
  
  // Simple responsive value selector
  static T responsive<T>(
    BuildContext context, {
    required T phone,
    required T tablet,
  }) {
    return isTablet(context) ? tablet : phone;
  }
  
  // Common responsive values
  static double fontSize(BuildContext context, {required double phone, required double tablet}) {
    return responsive(context, phone: phone, tablet: tablet);
  }
  
  static double spacing(BuildContext context, {required double phone, required double tablet}) {
    return responsive(context, phone: phone, tablet: tablet);
  }
  
  static EdgeInsets padding(BuildContext context) {
    return EdgeInsets.all(
      responsive(context, phone: 16.0, tablet: 24.0),
    );
  }
  
  static EdgeInsets horizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(context, phone: 16.0, tablet: 32.0),
    );
  }
}
