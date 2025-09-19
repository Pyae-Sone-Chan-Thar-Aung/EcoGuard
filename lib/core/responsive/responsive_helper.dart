import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _vivoV21Height = 2400;
  static const double _vivoV21Width = 1080;
  static const double _iphone12ProHeight = 2532;
  static const double _iphone12ProWidth = 1170;
  
  // Device type detection
  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;
    
    // Vivo V21 has aspect ratio around 0.45 (1080/2400)
    // iPhone 12 Pro has aspect ratio around 0.46 (1170/2532)
    if (aspectRatio < 0.47) {
      return DeviceType.tallScreen;
    } else if (aspectRatio < 0.6) {
      return DeviceType.standardScreen;
    } else {
      return DeviceType.wideScreen;
    }
  }
  
  // Check if current device is tall screen (Vivo V21, iPhone 12 Pro)
  static bool isTallScreen(BuildContext context) {
    return getDeviceType(context) == DeviceType.tallScreen;
  }
  
  // Get responsive padding based on device type
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isTallScreen(context)) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }
  
  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isTallScreen(context)) {
      return baseSize * 0.9; // Slightly smaller for tall screens
    }
    return baseSize;
  }
  
  // Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    if (isTallScreen(context)) {
      return baseSize * 0.85; // Smaller icons for tall screens
    }
    return baseSize;
  }
  
  // Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isTallScreen(context)) {
      return baseSpacing * 0.8; // Tighter spacing for tall screens
    }
    return baseSpacing;
  }
  
  // Get responsive bottom navigation height
  static double getBottomNavHeight(BuildContext context) {
    if (isTallScreen(context)) {
      return 60; // Adequate height for tall screens with FAB
    }
    return 65; // Standard height with FAB clearance
  }
  
  // Get responsive grid aspect ratio
  static double getGridAspectRatio(BuildContext context) {
    if (isTallScreen(context)) {
      return 1.3; // Taller cards for tall screens
    }
    return 1.2;
  }
  
  // Get responsive card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isTallScreen(context)) {
      return const EdgeInsets.all(8);
    }
    return const EdgeInsets.all(12);
  }
  
  // Get responsive button padding
  static EdgeInsets getButtonPadding(BuildContext context) {
    if (isTallScreen(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  }
  
  // Get responsive safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }
}

enum DeviceType {
  tallScreen,    // Vivo V21, iPhone 12 Pro
  standardScreen, // Most phones
  wideScreen,    // Tablets
}
