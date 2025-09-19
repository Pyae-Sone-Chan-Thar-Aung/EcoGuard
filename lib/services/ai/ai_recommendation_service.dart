import 'package:flutter/foundation.dart';
import '../points/points_service.dart';

class AIRecommendationService extends ChangeNotifier {
  static final AIRecommendationService _instance = AIRecommendationService._internal();
  factory AIRecommendationService() => _instance;
  AIRecommendationService._internal();

  final PointsService _pointsService = PointsService();
  List<AIRecommendation> _recommendations = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<AIRecommendation> get recommendations => _recommendations;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    // Initialize any required data or connections
    _isInitialized = true;
  }

  Future<void> generatePersonalizedRecommendations() async {
    if (!_isInitialized) {
      await initialize();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userStats = _pointsService.stats;
      final recentActivities = _pointsService.recentActivities;
      
      _recommendations = await _analyzeUserBehaviorAndGenerateRecommendations(
        userStats,
        recentActivities,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error generating AI recommendations: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<AIRecommendation>> _analyzeUserBehaviorAndGenerateRecommendations(
    dynamic userStats,
    List<dynamic> recentActivities,
  ) async {
    // Simulate AI analysis delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<AIRecommendation> recommendations = [];

    // Analyze tree planting behavior
    if (userStats.treesPlanted < 5) {
      recommendations.add(AIRecommendation(
        id: 'tree_beginner',
        title: 'Start Your Forest Journey',
        description: 'Plant your first tree to begin offsetting carbon emissions. Each tree can absorb 22kg of CO₂ annually.',
        category: RecommendationCategory.environmental,
        priority: RecommendationPriority.high,
        potentialPoints: 100,
        potentialImpact: 'Offset 22kg CO₂/year',
        actionType: 'tree_planting',
        estimatedTimeMinutes: 15,
        difficultyLevel: DifficultyLevel.easy,
      ));
    } else if (userStats.treesPlanted >= 5 && userStats.treesPlanted < 20) {
      recommendations.add(AIRecommendation(
        id: 'tree_intermediate',
        title: 'Expand Your Green Impact',
        description: 'You\'re doing great! Plant 5 more trees this month to reach the "Forest Guardian" achievement.',
        category: RecommendationCategory.gamification,
        priority: RecommendationPriority.medium,
        potentialPoints: 250,
        potentialImpact: 'Unlock achievement + 110kg CO₂/year',
        actionType: 'tree_planting',
        estimatedTimeMinutes: 45,
        difficultyLevel: DifficultyLevel.medium,
      ));
    }

    // Analyze e-waste recycling patterns
    if (userStats.ewasteRecycled < 3) {
      recommendations.add(AIRecommendation(
        id: 'ewaste_starter',
        title: 'Tackle Electronic Waste',
        description: 'Use our AI scanner to identify and properly recycle old electronics. Prevent toxic materials from landfills.',
        category: RecommendationCategory.recycling,
        priority: RecommendationPriority.high,
        potentialPoints: 75,
        potentialImpact: 'Prevent 2kg toxic waste',
        actionType: 'ewaste_scanning',
        estimatedTimeMinutes: 10,
        difficultyLevel: DifficultyLevel.easy,
      ));
    }

    // Analyze carbon footprint tracking
    final hasCalculatedCarbon = recentActivities.any((activity) => 
        activity.type == 'carbon_calculated');
    
    if (!hasCalculatedCarbon) {
      recommendations.add(AIRecommendation(
        id: 'carbon_awareness',
        title: 'Know Your Carbon Impact',
        description: 'Calculate your carbon footprint to understand your environmental impact and get personalized reduction tips.',
        category: RecommendationCategory.awareness,
        priority: RecommendationPriority.medium,
        potentialPoints: 50,
        potentialImpact: 'Identify 15% reduction opportunities',
        actionType: 'carbon_calculation',
        estimatedTimeMinutes: 8,
        difficultyLevel: DifficultyLevel.easy,
      ));
    }

    // Streak-based recommendations
    if (_pointsService.currentStreak >= 7) {
      recommendations.add(AIRecommendation(
        id: 'streak_master',
        title: 'Streak Champion Challenge',
        description: 'Amazing ${_pointsService.currentStreak}-day streak! Try our advanced eco-challenges to maximize your impact.',
        category: RecommendationCategory.challenge,
        priority: RecommendationPriority.low,
        potentialPoints: 300,
        potentialImpact: 'Double your weekly impact',
        actionType: 'advanced_challenge',
        estimatedTimeMinutes: 30,
        difficultyLevel: DifficultyLevel.hard,
      ));
    }

    // Seasonal and contextual recommendations
    recommendations.addAll(_generateSeasonalRecommendations());
    recommendations.addAll(_generateContextualRecommendations(userStats));

    // Sort by priority and relevance
    recommendations.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    
    return recommendations.take(6).toList(); // Limit to top 6 recommendations
  }

  List<AIRecommendation> _generateSeasonalRecommendations() {
    final now = DateTime.now();
    final month = now.month;
    
    List<AIRecommendation> seasonal = [];

    // Spring recommendations (March-May)
    if (month >= 3 && month <= 5) {
      seasonal.add(AIRecommendation(
        id: 'spring_planting',
        title: 'Spring Planting Season',
        description: 'Perfect weather for tree planting! Spring trees have 90% higher survival rates.',
        category: RecommendationCategory.seasonal,
        priority: RecommendationPriority.medium,
        potentialPoints: 150,
        potentialImpact: '90% survival rate',
        actionType: 'seasonal_tree_planting',
        estimatedTimeMinutes: 20,
        difficultyLevel: DifficultyLevel.easy,
      ));
    }

    // Summer recommendations (June-August)
    if (month >= 6 && month <= 8) {
      seasonal.add(AIRecommendation(
        id: 'energy_saving',
        title: 'Beat the Heat Efficiently',
        description: 'Reduce AC usage by 2°C to save 20% energy. Use fans and close curtains during peak hours.',
        category: RecommendationCategory.energy,
        priority: RecommendationPriority.high,
        potentialPoints: 80,
        potentialImpact: 'Save 50kg CO₂/month',
        actionType: 'energy_conservation',
        estimatedTimeMinutes: 5,
        difficultyLevel: DifficultyLevel.easy,
      ));
    }

    // Fall recommendations (September-November)
    if (month >= 9 && month <= 11) {
      seasonal.add(AIRecommendation(
        id: 'composting_season',
        title: 'Autumn Composting',
        description: 'Turn fallen leaves into nutrient-rich compost. Reduce waste and create natural fertilizer.',
        category: RecommendationCategory.waste_reduction,
        priority: RecommendationPriority.medium,
        potentialPoints: 60,
        potentialImpact: 'Reduce 5kg waste/week',
        actionType: 'composting',
        estimatedTimeMinutes: 15,
        difficultyLevel: DifficultyLevel.medium,
      ));
    }

    // Winter recommendations (December-February)
    if (month == 12 || month <= 2) {
      seasonal.add(AIRecommendation(
        id: 'winter_efficiency',
        title: 'Winter Energy Optimization',
        description: 'Seal windows and use programmable thermostats to reduce heating costs by 15%.',
        category: RecommendationCategory.energy,
        priority: RecommendationPriority.high,
        potentialPoints: 120,
        potentialImpact: 'Save 80kg CO₂/month',
        actionType: 'winter_efficiency',
        estimatedTimeMinutes: 30,
        difficultyLevel: DifficultyLevel.medium,
      ));
    }

    return seasonal;
  }

  List<AIRecommendation> _generateContextualRecommendations(dynamic userStats) {
    List<AIRecommendation> contextual = [];

    // Based on user level/experience
    final totalActivities = userStats.treesPlanted + userStats.ewasteRecycled;
    
    if (totalActivities < 5) {
      // Beginner user
      contextual.add(AIRecommendation(
        id: 'beginner_guide',
        title: 'Eco-Warrior Bootcamp',
        description: 'Complete our interactive tutorial to learn the most impactful environmental actions.',
        category: RecommendationCategory.education,
        priority: RecommendationPriority.medium,
        potentialPoints: 200,
        potentialImpact: 'Learn 10 key eco-actions',
        actionType: 'education_tutorial',
        estimatedTimeMinutes: 25,
        difficultyLevel: DifficultyLevel.easy,
      ));
    } else if (totalActivities >= 20) {
      // Advanced user
      contextual.add(AIRecommendation(
        id: 'community_leader',
        title: 'Become a Community Leader',
        description: 'Share your expertise! Mentor new users and organize local environmental events.',
        category: RecommendationCategory.community,
        priority: RecommendationPriority.low,
        potentialPoints: 500,
        potentialImpact: 'Influence 10+ people',
        actionType: 'community_leadership',
        estimatedTimeMinutes: 60,
        difficultyLevel: DifficultyLevel.hard,
      ));
    }

    // Smart device integration recommendations
    contextual.add(AIRecommendation(
      id: 'smart_tracking',
      title: 'Smart Home Integration',
      description: 'Connect smart devices to automatically track energy usage and get real-time optimization tips.',
      category: RecommendationCategory.technology,
      priority: RecommendationPriority.low,
      potentialPoints: 150,
      potentialImpact: 'Automate 30% savings',
      actionType: 'smart_integration',
      estimatedTimeMinutes: 45,
      difficultyLevel: DifficultyLevel.hard,
    ));

    return contextual;
  }

  void markRecommendationCompleted(String recommendationId) {
    _recommendations.removeWhere((rec) => rec.id == recommendationId);
    notifyListeners();
    
    // Generate new recommendations after completion
    Future.delayed(const Duration(seconds: 1), () {
      generatePersonalizedRecommendations();
    });
  }

  AIRecommendation? getRecommendationById(String id) {
    try {
      return _recommendations.firstWhere((rec) => rec.id == id);
    } catch (e) {
      return null;
    }
  }
}

class AIRecommendation {
  final String id;
  final String title;
  final String description;
  final RecommendationCategory category;
  final RecommendationPriority priority;
  final int potentialPoints;
  final String potentialImpact;
  final String actionType;
  final int estimatedTimeMinutes;
  final DifficultyLevel difficultyLevel;
  final DateTime createdAt;

  AIRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.potentialPoints,
    required this.potentialImpact,
    required this.actionType,
    required this.estimatedTimeMinutes,
    required this.difficultyLevel,
  }) : createdAt = DateTime.now();
}

enum RecommendationCategory {
  environmental,
  recycling,
  energy,
  awareness,
  gamification,
  challenge,
  seasonal,
  waste_reduction,
  education,
  community,
  technology,
}

enum RecommendationPriority {
  low,
  medium,
  high,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
}
