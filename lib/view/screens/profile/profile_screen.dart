import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../state/providers/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/common/bottom_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final PointsService _pointsService = PointsService();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final stats = _pointsService.stats;
    final totalPoints = _pointsService.totalPoints;
    final currentStreak = _pointsService.calculateCurrentStreak();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$totalPoints Eco Points',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Stats Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Current Streak',
                          '$currentStreak days',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Trees Planted',
                          '${stats.treesPlanted}',
                          Icons.eco,
                          AppColors.leafGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'E-Waste Scanned',
                          '${stats.itemsRecycled}',
                          Icons.recycling,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Games Played',
                          '${stats.gamesPlayed}',
                          Icons.games,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements Section
                  const Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildAchievementItem(
                            'Tree Hugger',
                            'Plant your first tree',
                            stats.treesPlanted > 0,
                            Icons.eco,
                          ),
                          _buildAchievementItem(
                            'Recycling Hero',
                            'Scan 5 e-waste items',
                            stats.itemsRecycled >= 5,
                            Icons.recycling,
                          ),
                          _buildAchievementItem(
                            'Streak Master',
                            'Maintain a 7-day streak',
                            currentStreak >= 7,
                            Icons.local_fire_department,
                          ),
                          _buildAchievementItem(
                            'Point Collector',
                            'Earn 1000 eco points',
                            totalPoints >= 1000,
                            Icons.stars,
                          ),
                          _buildAchievementItem(
                            'Gaming Pro',
                            'Play 10 sorting games',
                            stats.gamesPlayed >= 10,
                            Icons.games,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Settings Section
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: true,
                          onChanged: null, // Follows system theme; toggle disabled
                          title: const Text('Dark Mode (System)'),
                          subtitle: const Text('Theme follows device setting'),
                          secondary: const Icon(Icons.dark_mode),
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notifications'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showNotificationsInfo(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showHelpSupport(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('About EcoGuard'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showAboutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 0, // Dashboard tab (profile accessible from there)
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.treePlanting);
              break;
            case 2:
              context.go(RouteNames.ewaste);
              break;
            case 3:
              context.go(RouteNames.carbonCalculator);
              break;
            case 4:
              context.go(RouteNames.leaderboard);
              break;
          }
        },
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description, bool unlocked, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: unlocked 
                ? AppColors.primaryGreen.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            child: Icon(
              icon,
              color: unlocked ? AppColors.primaryGreen : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: unlocked ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(
              Icons.check_circle,
              color: AppColors.primaryGreen,
              size: 20,
            ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About EcoGuard'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EcoGuard - Your Digital Environmental Companion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'EcoGuard is a comprehensive digital platform designed to promote environmental sustainability through gamification and education.',
            ),
            SizedBox(height: 12),
            Text('Features:'),
            Text('• Virtual tree planting with real impact'),
            Text('• AR-powered e-waste scanning and sorting'),
            Text('• Carbon footprint calculator'),
            Text('• Repair advisor for electronic devices'),
            Text('• Community challenges and leaderboards'),
            SizedBox(height: 12),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
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
      ),
    );
  }

  void _showNotificationsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text(
          'EcoGuard can send reminders for tree planting, recycling tips, and community challenges. You can manage notification permissions from your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('For FAQs, tutorials, and troubleshooting:'),
              SizedBox(height: 8),
              Text('• How to scan e-waste using AI'),
              Text('• How points and streaks work'),
              Text('• Finding nearby recycling centers'),
              SizedBox(height: 12),
              Text('Contact us: support@ecoguard.app'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      ),
    );
  }
}
