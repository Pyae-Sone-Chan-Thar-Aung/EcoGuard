import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../view/screens/splash/modern_splash_screen.dart';
import '../../view/screens/onboarding/modern_onboarding_screen.dart';
import '../../view/screens/dashboard/modern_dashboard_screen.dart';
import '../../view/screens/ewaste/smart_ewaste_scanner.dart';
import '../../view/screens/tree_planting/tree_planting_hub.dart';
import '../../view/screens/ewaste/ewaste_hub_screen.dart';
import '../../view/screens/carbon_footprint/carbon_calculator_screen.dart';
import '../../view/screens/education/eco_museum_screen.dart';
import '../../view/screens/community/leaderboard_screen.dart';
import '../../view/screens/profile/profile_screen.dart';
import '../../view/screens/ewaste/ar_scanner_screen.dart';
import '../../view/screens/ewaste/sorting_game_screen.dart';
import '../../view/screens/ewaste/recycling_centers_map_screen.dart';
import '../../view/screens/repair/repair_advisor_screen.dart';
import '../../view/screens/ewaste/device_input_screen.dart';
import '../../view/screens/ewaste/device_analysis_results_screen.dart';
import '../../models/e_waste/device_analysis.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(path: RouteNames.splash, builder: (context, state) => const ModernSplashScreen()),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const ModernOnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const ModernDashboardScreen(),
      ),
      GoRoute(path: RouteNames.treePlanting, builder: (context, state) => const TreePlantingHub()),
      GoRoute(path: RouteNames.ewaste, builder: (context, state) => const EwasteHubScreen()),
      GoRoute(path: RouteNames.carbonCalculator, builder: (context, state) => const CarbonCalculatorScreen()),
      GoRoute(path: RouteNames.ecoMuseum, builder: (context, state) => const EcoMuseumScreen()),
      // Aliases for convenience
      GoRoute(path: RouteNames.education, builder: (context, state) => const EcoMuseumScreen()),
      GoRoute(path: RouteNames.leaderboard, builder: (context, state) => const LeaderboardScreen()),
      // Map community to leaderboard until a dedicated community screen exists
      GoRoute(path: RouteNames.community, builder: (context, state) => const LeaderboardScreen()),
      GoRoute(path: RouteNames.profile, builder: (context, state) => const ProfileScreen()),
      GoRoute(path: RouteNames.arScanner, builder: (context, state) => const SmartEWasteScanner()),
      GoRoute(path: RouteNames.sortingGame, builder: (context, state) => const SortingGameScreen()),
      GoRoute(path: RouteNames.recyclingMap, builder: (context, state) => const RecyclingCentersMapScreen()),
      GoRoute(path: RouteNames.repairAdvisor, builder: (context, state) => const RepairAdvisorScreen()),
      GoRoute(path: RouteNames.deviceInput, builder: (context, state) => const DeviceInputScreen()),
      GoRoute(
        path: RouteNames.deviceAnalysisResults,
        builder: (context, state) {
          final analysis = state.extra as DeviceAnalysis;
          return DeviceAnalysisResultsScreen(analysis: analysis);
        },
      ),
    ],
  );
});
