import 'package:flutter_test/flutter_test.dart';
import 'package:ecoguard/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('should have correct default environment', () {
      expect(AppConfig.environment, equals('development'));
    });

    test('should return correct environment flags', () {
      expect(AppConfig.isDevelopment, isTrue);
      expect(AppConfig.isProduction, isFalse);
      expect(AppConfig.isStaging, isFalse);
    });

    test('should have valid API timeout', () {
      expect(AppConfig.apiTimeout, equals(const Duration(seconds: 30)));
    });

    test('should have valid max retries', () {
      expect(AppConfig.maxRetries, equals(3));
      expect(AppConfig.maxRetries, greaterThan(0));
    });

    test('should have valid cache configuration', () {
      expect(AppConfig.cacheExpiry, equals(const Duration(hours: 24)));
      expect(AppConfig.maxCacheSize, greaterThan(0));
    });

    test('should have correct logging flags for development', () {
      expect(AppConfig.enableDebugLogging, isTrue);
      expect(AppConfig.enableVerboseLogging, isTrue);
    });

    test('should have valid app information', () {
      expect(AppConfig.appName, isNotEmpty);
      expect(AppConfig.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect(AppConfig.supportEmail, contains('@'));
    });

    test('should have valid Supabase configuration', () {
      expect(AppConfig.supabaseUrl, isNotEmpty);
      expect(AppConfig.supabaseUrl, startsWith('https://'));
      expect(AppConfig.supabaseAnonKey, isNotEmpty);
    });
  });
}
