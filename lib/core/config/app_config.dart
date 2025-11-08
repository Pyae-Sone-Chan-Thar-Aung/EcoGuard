/// Application configuration
/// 
/// This file manages environment-specific configurations including
/// API keys, URLs, and other sensitive data.
/// 
/// **IMPORTANT**: Never commit sensitive credentials to version control.
/// Use environment variables or a secure secrets management solution.
class AppConfig {
  AppConfig._();

  // Environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';

  // Supabase Configuration
  // TODO: Move these to environment variables or secure storage
  // For now, using placeholders - replace with actual values from secure source
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tlawzidglriindqvhayo.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsYXd6aWRnbHJpaW5kcXZoYXlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNTEyNzEsImV4cCI6MjA3MjgyNzI3MX0.cxPwfzO-xsQQY7-Ofp8sAp49Rp6NsuPs5Hz1XXEidag',
  );

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Feature Flags
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: false,
  );

  // App Information
  static const String appName = 'EcoGuard';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@ecoguard.app';

  // Logging
  static bool get enableDebugLogging => !isProduction;
  static bool get enableVerboseLogging => isDevelopment;
}
