import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../state/providers/app_state_provider.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/dashboard/eco_points_card.dart';
import '../../widgets/dashboard/streak_counter.dart';
import '../../widgets/dashboard/quick_actions_grid.dart';

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});
  @override ConsumerState<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  final PointsService _pointsService = PointsService();
  bool _hasCelebrated = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadUserProfile();
      _pointsService.addListener(_onPointsUpdate);
    });
  }
  
  @override
  void dispose() {
    _pointsService.removeListener(_onPointsUpdate);
    super.dispose();
  }
  
  void _onPointsUpdate() {
    if (mounted) {
      setState(() {});
      _checkChallengeCompletion();
    }
  }
  
  void _checkChallengeCompletion() {
    final stats = _pointsService.stats;
    final dailyTreesPlanted = stats.treesPlanted % 10;
    
    // Check if challenge is completed and we haven't celebrated yet
    if (dailyTreesPlanted == 0 && stats.treesPlanted >= 10 && !_hasCelebrated) {
      _hasCelebrated = true;
      _showChallengeCompletionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final ecoPoints = _pointsService.totalPoints;
    final currentStreak = _pointsService.calculateCurrentStreak();
    final recentActivities = _pointsService.recentActivities.take(3).toList();
    final stats = _pointsService.stats;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Welcome, ${user?.displayName ?? 'EcoWarrior'}!'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go(RouteNames.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.read(userProfileProvider.notifier).loadUserProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: EcoPointsCard(points: ecoPoints)),
              const SizedBox(width: 12),
              Expanded(child: StreakCounter(streak: currentStreak)),
            ]),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Today\'s Challenge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Plant a virtual tree and document it with a photo!'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (stats.treesPlanted % 10) / 10.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                  ),
                  const SizedBox(height: 8),
                  Text('${stats.treesPlanted % 10} of 10 trees planted', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const QuickActionsGrid(),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (recentActivities.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No recent activity. Start using EcoGuard features to track your progress!',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...recentActivities.map((activity) => _buildActivityItem(
                      _getIconForActivityType(activity.type),
                      activity.title,
                      activity.getTimeAgo(),
                      '+${activity.points} points',
                    )),
                ]),
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        selectedFontSize: ResponsiveHelper.isTallScreen(context) ? 9 : 10,
        unselectedFontSize: ResponsiveHelper.isTallScreen(context) ? 8 : 9,
        iconSize: ResponsiveHelper.getResponsiveIconSize(context, 20),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Trees'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'E-Waste'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Carbon'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Community'),
        ],
        onTap: (index) {
          switch (index) {
            case 1: context.go(RouteNames.treePlanting); break;
            case 2: context.go(RouteNames.ewaste); break;
            case 3: context.go(RouteNames.carbonCalculator); break;
            case 4: context.go(RouteNames.leaderboard); break;
            default: break;
          }
        },
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String time, String points) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: AppColors.leafGreen.withOpacity(0.2), child: Icon(icon, color: AppColors.primaryGreen)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(time),
      trailing: Text(points, style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
    );
  }
  
  IconData _getIconForActivityType(ActivityType type) {
    switch (type) {
      case ActivityType.treePlanting:
        return Icons.eco;
      case ActivityType.ewasteRecycling:
        return Icons.recycling;
      case ActivityType.sortingGame:
        return Icons.games;
      case ActivityType.carbonCalculation:
        return Icons.calculate;
    }
  }
  
  void _showChallengeCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.celebration,
                  color: AppColors.primaryGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🌱 You completed today\'s challenge! 🌱',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'You planted 10 virtual trees today and earned valuable eco points! Your commitment to environmental sustainability is making a real difference.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.leafGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      '"Every tree planted is a step towards a healthier planet. Keep up the amazing work and inspire others to join the green movement!"',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Continue Saving the Earth!',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.notifications,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              const Text('Notifications'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNotificationItem(
                  Icons.eco,
                  'Daily Challenge',
                  'Plant 10 trees today to earn bonus points!',
                  '2 hours ago',
                ),
                const Divider(),
                _buildNotificationItem(
                  Icons.recycling,
                  'E-Waste Reminder',
                  'Don\'t forget to scan and sort your electronic waste.',
                  '1 day ago',
                ),
                const Divider(),
                _buildNotificationItem(
                  Icons.celebration,
                  'Achievement Unlocked',
                  'You\'ve reached a 7-day streak! Keep it up!',
                  '2 days ago',
                ),
                const Divider(),
                _buildNotificationItem(
                  Icons.info_outline,
                  'Tip of the Day',
                  'Using repair advisor can save 50kg CO2 per device!',
                  '3 days ago',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildNotificationItem(
    IconData icon,
    String title,
    String message,
    String time,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
