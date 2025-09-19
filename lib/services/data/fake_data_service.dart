import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user/user_profile.dart';
import '../../models/tree/tree_model.dart';
import '../../models/e_waste/ewaste_item.dart';
import '../../models/carbon/carbon_footprint.dart';

class FakeDataService {
  Future<UserProfile> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return UserProfile(
      id: 'user_123',
      email: 'juan@example.com',
      displayName: 'Juan',
      avatarUrl: null,
      ecoPoints: 1250,
      currentStreak: 15,
      longestStreak: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastActiveAt: DateTime.now(),
      achievements: const ['first_tree', 'eco_warrior', 'recycling_hero'],
      preferredLanguage: 'en',
    );
  }

  Future<List<TreeModel>> getUserTrees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      TreeModel(
        id: 'tree_1',
        speciesId: 'oak_001',
        speciesName: 'Quercus robur',
        commonName: 'English Oak',
        latitude: 14.5995,
        longitude: 120.9842,
        plantedAt: DateTime.now().subtract(const Duration(days: 30)),
        plantedBy: 'user_123',
        imageUrl: null,
        description: null,
        estimatedCarbonOffset: 22.7,
      ),
    ];
  }

  Future<List<EwasteItem>> getEwasteItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      EwasteItem(
        id: 'phone_001',
        name: 'Smartphone',
        description: 'Old or broken mobile phones',
        category: EwasteCategory.smartphones,
        imageUrl: 'assets/images/ewaste/smartphone.png',
        disposalInstructions: const [
          'Remove personal data',
          'Remove battery if possible',
          'Take to certified e-waste center',
        ],
        isHazardous: false,
        ecoPointsValue: 25,
        recyclingCenters: const [],
      ),
    ];
  }

  Future<CarbonFootprint> calculateCarbonFootprint(
      Map<String, double> inputs,
      ) async {
    await Future.delayed(const Duration(seconds: 1));

    final total = inputs.values.fold<double>(0.0, (a, b) => a + b);

    return CarbonFootprint(
      id: 'carbon_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_123',
      calculatedAt: DateTime.now(),
      totalAnnualEmissions: total,
      emissionsByCategory: inputs,
      recommendedActions: const [
        'Use public transportation more often',
        'Switch to renewable energy',
        'Reduce meat consumption',
        'Use energy-efficient appliances',
      ],
      treesNeededToOffset: (total / 22.7).ceilToDouble(),
    );
  }
}

/// ✅ Riverpod provider for FakeDataService
final fakeDataServiceProvider = Provider<FakeDataService>((ref) {
  return FakeDataService();
});
