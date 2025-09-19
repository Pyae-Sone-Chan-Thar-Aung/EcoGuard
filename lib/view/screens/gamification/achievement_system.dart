import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/points/points_service.dart';

class AchievementSystem extends ConsumerStatefulWidget {
  const AchievementSystem({super.key});

  @override
  ConsumerState<AchievementSystem> createState() => _AchievementSystemState();
}

class _AchievementSystemState extends ConsumerState<AchievementSystem>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final PointsService _pointsService = PointsService();

  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_tree',
      title: 'Tree Hugger',
      description: 'Plant your first tree',
      icon: Icons.park,
      color: Colors.green,
      points: 100,
      requirement: 1,
      type: AchievementType.trees,
    ),
    Achievement(
      id: 'eco_warrior',
      title: 'Eco Warrior',
      description: 'Plant 10 trees',
      icon: Icons.forest,
      color: Colors.green[700]!,
      points: 500,
      requirement: 10,
      type: AchievementType.trees,
    ),
    Achievement(
      id: 'recycling_hero',
      title: 'Recycling Hero',
      description: 'Recycle 5 e-waste items',
      icon: Icons.recycling,
      color: Colors.blue,
      points: 200,
      requirement: 5,
      type: AchievementType.ewaste,
    ),
    Achievement(
      id: 'streak_master',
      title: 'Streak Master',
      description: 'Maintain 7-day streak',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      points: 300,
      requirement: 7,
      type: AchievementType.streak,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          final progress = _getAchievementProgress(achievement);
          final isUnlocked = progress >= achievement.requirement;
          
          return _buildAchievementCard(achievement, progress, isUnlocked);
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int progress, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? achievement.color : Colors.grey[300]!,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked ? [
          BoxShadow(
            color: achievement.color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnlocked 
                  ? achievement.color.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              achievement.icon,
              color: isUnlocked ? achievement.color : Colors.grey[400],
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked ? AppColors.primary : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress / achievement.requirement,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isUnlocked ? achievement.color : Colors.grey[400]!,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$progress / ${achievement.requirement}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: achievement.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${achievement.points} pts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: achievement.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: achievement.color,
              size: 24,
            ),
        ],
      ),
    );
  }

  int _getAchievementProgress(Achievement achievement) {
    final stats = _pointsService.stats;
    switch (achievement.type) {
      case AchievementType.trees:
        return stats.treesPlanted;
      case AchievementType.ewaste:
        return stats.ewasteRecycled;
      case AchievementType.streak:
        return _pointsService.currentStreak;
      default:
        return 0;
    }
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int points;
  final int requirement;
  final AchievementType type;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.points,
    required this.requirement,
    required this.type,
  });
}

enum AchievementType {
  trees,
  ewaste,
  streak,
  points,
}
