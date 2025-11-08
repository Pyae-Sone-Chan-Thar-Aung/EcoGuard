import 'package:flutter/material.dart';

/// Application localizations
/// 
/// This class provides localized strings for the application.
/// Currently supports English with placeholders for other languages.
/// 
/// To use: AppLocalizations.of(context).someString
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common strings
  String get appName => 'EcoGuard';
  String get ok => 'OK';
  String get cancel => 'Cancel';
  String get save => 'Save';
  String get delete => 'Delete';
  String get edit => 'Edit';
  String get close => 'Close';
  String get yes => 'Yes';
  String get no => 'No';
  String get loading => 'Loading...';
  String get error => 'Error';
  String get success => 'Success';
  String get retry => 'Retry';
  String get dismiss => 'Dismiss';

  // Authentication
  String get login => 'Login';
  String get logout => 'Logout';
  String get register => 'Register';
  String get email => 'Email';
  String get password => 'Password';
  String get confirmPassword => 'Confirm Password';
  String get forgotPassword => 'Forgot Password?';
  String get resetPassword => 'Reset Password';

  // Dashboard
  String get dashboard => 'Dashboard';
  String get ecoPoints => 'Eco Points';
  String get currentStreak => 'Current Streak';
  String get achievements => 'Achievements';

  // E-Waste
  String get eWaste => 'E-Waste';
  String get scanDevice => 'Scan Device';
  String get recyclingCenters => 'Recycling Centers';
  String get deviceAnalysis => 'Device Analysis';

  // Tree Planting
  String get treePlanting => 'Tree Planting';
  String get plantTree => 'Plant Tree';
  String get myTrees => 'My Trees';

  // Carbon Footprint
  String get carbonFootprint => 'Carbon Footprint';
  String get calculateFootprint => 'Calculate Footprint';
  String get myFootprint => 'My Footprint';

  // Community
  String get community => 'Community';
  String get leaderboard => 'Leaderboard';
  String get challenges => 'Challenges';

  // Profile
  String get profile => 'Profile';
  String get settings => 'Settings';
  String get notifications => 'Notifications';

  // Error Messages
  String get genericError => 'An unexpected error occurred. Please try again.';
  String get networkError => 'Network error. Please check your connection.';
  String get authError => 'Authentication failed. Please try again.';
  String get notFoundError => 'Resource not found.';
  String get sessionExpired => 'Session expired. Please log in again.';

  // Success Messages
  String get saveSuccess => 'Saved successfully';
  String get deleteSuccess => 'Deleted successfully';
  String get updateSuccess => 'Updated successfully';

  // Validation Messages
  String get emailRequired => 'Email is required';
  String get emailInvalid => 'Please enter a valid email';
  String get passwordRequired => 'Password is required';
  String get passwordTooShort => 'Password must be at least 8 characters';
  String get passwordsDontMatch => 'Passwords do not match';

  // Parameterized strings
  String pointsEarned(int points) => 'You earned $points points!';
  String treesPlanted(int count) => '$count ${count == 1 ? "tree" : "trees"} planted';
  String daysStreak(int days) => '$days day${days == 1 ? "" : "s"} streak';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Currently supporting only English
    // Add more language codes as translations are added
    return <String>['en', 'es', 'fr', 'de', 'zh', 'ja', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // In a real app, you would load translations from files here
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
