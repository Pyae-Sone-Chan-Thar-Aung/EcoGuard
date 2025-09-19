import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user/user_profile.dart';
import '../../services/data/supabase_data_service.dart';

final supabaseDataServiceProvider = Provider<SupabaseDataService>((ref) {
  return SupabaseDataService();
});

final userProfileProvider =
StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref _ref;

  UserProfileNotifier(this._ref) : super(null);

  Future<void> loadUserProfile() async {
    try {
      final supabaseService = _ref.read(supabaseDataServiceProvider);
      final user = await supabaseService.getCurrentUserProfile();
      state = user ?? _fallbackUser();
    } catch (_) {
      state = _fallbackUser();
    }
  }

  UserProfile _fallbackUser() {
    return UserProfile(
      id: 'local',
      displayName: 'EcoWarrior',
      email: 'guest@example.com',
      ecoPoints: 0,
      currentStreak: 0,
      longestStreak: 0,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
  }
}
// ---------------- ECO POINTS PROVIDER ----------------
final ecoPointsProvider = Provider<int>((ref) {
  final user = ref.watch(userProfileProvider);
  return user?.ecoPoints ?? 0;
});

// ---------------- STREAK PROVIDER ----------------
final currentStreakProvider = Provider<int>((ref) {
  final user = ref.watch(userProfileProvider);
  return user?.currentStreak ?? 0; // ✅ use currentStreak
});

