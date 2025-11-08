import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoguard/state/providers/app_state_provider.dart';
import 'package:ecoguard/models/user/user_profile.dart';

void main() {
  group('UserProfileNotifier', () {
    test('should have null initial state', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      final UserProfile? profile = container.read(userProfileProvider);
      expect(profile, isNull);
    });

    test('should load fallback user on error', () async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      final UserProfileNotifier notifier =
          container.read(userProfileProvider.notifier);
      await notifier.loadUserProfile();

      final UserProfile? profile = container.read(userProfileProvider);
      expect(profile, isNotNull);
      expect(profile!.id, equals('local'));
      expect(profile.displayName, equals('EcoWarrior'));
      expect(profile.ecoPoints, equals(0));
    });
  });

  group('ecoPointsProvider', () {
    test('should return 0 when user is null', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      final int points = container.read(ecoPointsProvider);
      expect(points, equals(0));
    });

    test('should return user eco points when user exists', () {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          userProfileProvider.overrideWith(
            (StateNotifierProviderRef<UserProfileNotifier, UserProfile?> ref) =>
                UserProfileNotifier(ref)
                  ..state = UserProfile(
                    id: 'test',
                    displayName: 'Test User',
                    email: 'test@test.com',
                    ecoPoints: 150,
                    currentStreak: 5,
                    longestStreak: 10,
                    createdAt: DateTime.now(),
                    lastActiveAt: DateTime.now(),
                  ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final int points = container.read(ecoPointsProvider);
      expect(points, equals(150));
    });
  });

  group('currentStreakProvider', () {
    test('should return 0 when user is null', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      final int streak = container.read(currentStreakProvider);
      expect(streak, equals(0));
    });

    test('should return user current streak when user exists', () {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          userProfileProvider.overrideWith(
            (StateNotifierProviderRef<UserProfileNotifier, UserProfile?> ref) =>
                UserProfileNotifier(ref)
                  ..state = UserProfile(
                    id: 'test',
                    displayName: 'Test User',
                    email: 'test@test.com',
                    ecoPoints: 100,
                    currentStreak: 7,
                    longestStreak: 15,
                    createdAt: DateTime.now(),
                    lastActiveAt: DateTime.now(),
                  ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final int streak = container.read(currentStreakProvider);
      expect(streak, equals(7));
    });
  });
}
