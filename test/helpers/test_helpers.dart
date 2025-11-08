import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Test helpers for the EcoGuard application
class TestHelpers {
  TestHelpers._();

  /// Create a test widget wrapped with providers
  static Widget createTestWidget({
    required Widget child,
    List<Override> overrides = const <Override>[],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Create a test widget with router
  static Widget createTestWidgetWithRouter({
    required Widget child,
    List<Override> overrides = const <Override>[],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  /// Pump and settle with a default duration
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pumpAndSettle(duration);
  }

  /// Find widget by text
  static Finder findByText(String text) => find.text(text);

  /// Find widget by key
  static Finder findByKey(Key key) => find.byKey(key);

  /// Find widget by type
  static Finder findByType<T extends Widget>() => find.byType(T);

  /// Verify widget exists
  static void expectWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verify widget does not exist
  static void expectWidgetDoesNotExist(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verify multiple widgets exist
  static void expectMultipleWidgets(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }
}

/// Mock providers for testing
class MockProviders {
  MockProviders._();

  // Add mock providers here as needed
  // Example:
  // static final mockUserProfileProvider = Provider<UserProfile>((ref) {
  //   return UserProfile(
  //     id: 'test-id',
  //     displayName: 'Test User',
  //     email: 'test@example.com',
  //     ecoPoints: 100,
  //   );
  // });
}
