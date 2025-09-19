import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../points/points_service.dart';
import '../notifications/notification_service.dart';

class GamificationService extends ChangeNotifier {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  late Box<Map> _achievementsBox;
  late Box<Map> _challengesBox;
  late Box<Map> _badgesBox;
  
  final PointsService _pointsService = PointsService();
  final NotificationService _notificationService = NotificationService();
  
  bool _isInitialized = false;
  List<Achievement> _unlockedAchievements = [];
  List<Challenge> _activeChallenges = [];
  List<Badge> _earnedBadges = [];
  int _currentLevel = 1;
  int _experiencePoints = 0;

  List<Achievement> get unlockedAchievements => _unlockedAchievements;
  List<Challenge> get activeChallenges => _activeChallenges;
  List<Badge> get earnedBadges => _earnedBadges;
  int get currentLevel => _currentLevel;
  int get experiencePoints => _experiencePoints;
  int get experienceToNextLevel => (_currentLevel * 1000) - _experiencePoints;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _achievementsBox = await Hive.openBox<Map>('achievements');
      _challengesBox = await Hive.openBox<Map>('challenges');
      _badgesBox = await Hive.openBox<Map>('badges');
      
      await _loadGamificationData();
      await _initializeChallenges();
      _isInitialized = true;
      
      debugPrint('GamificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing GamificationService: $e');
    }
  }

  Future<void> _loadGamificationData() async {
    // Load achievements
    final achievementData = _achievementsBox.get('unlocked', defaultValue: <String, dynamic>{}) as Map<String, dynamic>;
    _unlockedAchievements = achievementData.entries
        .map((entry) => Achievement.fromMap(entry.value as Map<String, dynamic>))
        .toList();

    // Load badges
    final badgeData = _badgesBox.get('earned', defaultValue: <String, dynamic>{}) as Map<String, dynamic>;
    _earnedBadges = badgeData.entries
        .map((entry) => Badge.fromMap(entry.value as Map<String, dynamic>))
        .toList();

    // Load level and XP
    final levelData = _achievementsBox.get('level', defaultValue: {'level': 1, 'xp': 0}) as Map<String, dynamic>;
    _currentLevel = levelData['level'] ?? 1;
    _experiencePoints = levelData['xp'] ?? 0;
  }

  Future<void> _initializeChallenges() async {
    final today = DateTime.now();
    final challengeData = _challengesBox.get('active', defaultValue: <String, dynamic>{}) as Map<String, dynamic>;
    
    // Check if we need new daily challenges
    final lastUpdate = challengeData['lastUpdate'] != null 
        ? DateTime.parse(challengeData['lastUpdate'])
        : DateTime(2020);
    
    if (!_isSameDay(today, lastUpdate)) {
      await _generateDailyChallenges();
    } else {
      // Load existing challenges
      final challenges = challengeData['challenges'] as List<dynamic>? ?? [];
      _activeChallenges = challenges
          .map((data) => Challenge.fromMap(data as Map<String, dynamic>))
          .toList();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<void> _generateDailyChallenges() async {
    final stats = _pointsService.stats;
    _activeChallenges.clear();

    // Generate 3 daily challenges based on user progress
    _activeChallenges.addAll([
      Challenge(
        id: 'daily_tree_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Plant a Tree Today',
        description: 'Plant 1 tree to help combat climate change',
        type: ChallengeType.daily,
        targetValue: 1,
        currentProgress: 0,
        rewardPoints: 150,
        rewardXP: 100,
        category: 'trees',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      ),
      Challenge(
        id: 'daily_ewaste_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Recycle E-Waste',
        description: 'Scan and recycle 2 electronic items',
        type: ChallengeType.daily,
        targetValue: 2,
        currentProgress: 0,
        rewardPoints: 100,
        rewardXP: 75,
        category: 'ewaste',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      ),
      Challenge(
        id: 'daily_carbon_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Calculate Carbon Footprint',
        description: 'Track your daily carbon emissions',
        type: ChallengeType.daily,
        targetValue: 1,
        currentProgress: 0,
        rewardPoints: 75,
        rewardXP: 50,
        category: 'carbon',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      ),
    ]);

    // Add weekly challenge if it's Monday
    if (DateTime.now().weekday == 1) {
      _activeChallenges.add(Challenge(
        id: 'weekly_eco_warrior_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Eco Warrior Week',
        description: 'Complete 10 environmental actions this week',
        type: ChallengeType.weekly,
        targetValue: 10,
        currentProgress: 0,
        rewardPoints: 500,
        rewardXP: 300,
        category: 'general',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ));
    }

    await _saveChallenges();
  }

  Future<void> _saveChallenges() async {
    final challengeData = {
      'lastUpdate': DateTime.now().toIso8601String(),
      'challenges': _activeChallenges.map((c) => c.toMap()).toList(),
    };
    await _challengesBox.put('active', challengeData);
  }

  Future<void> checkAchievements(String actionType, int value) async {
    final stats = _pointsService.stats;
    final newAchievements = <Achievement>[];

    // Tree planting achievements
    if (actionType == 'tree_planted') {
      if (stats.treesPlanted == 1 && !_hasAchievement('first_tree')) {
        newAchievements.add(_createAchievement('first_tree', 'Tree Hugger', 
            'Planted your first tree!', 100, 50));
      }
      if (stats.treesPlanted == 10 && !_hasAchievement('tree_master')) {
        newAchievements.add(_createAchievement('tree_master', 'Forest Guardian', 
            'Planted 10 trees!', 500, 250));
      }
      if (stats.treesPlanted == 50 && !_hasAchievement('tree_legend')) {
        newAchievements.add(_createAchievement('tree_legend', 'Reforestation Hero', 
            'Planted 50 trees!', 1000, 500));
      }
    }

    // E-waste achievements
    if (actionType == 'ewaste_recycled') {
      if (stats.ewasteRecycled == 1 && !_hasAchievement('first_recycle')) {
        newAchievements.add(_createAchievement('first_recycle', 'Recycling Rookie', 
            'Recycled your first e-waste item!', 75, 40));
      }
      if (stats.ewasteRecycled == 25 && !_hasAchievement('recycle_master')) {
        newAchievements.add(_createAchievement('recycle_master', 'Waste Warrior', 
            'Recycled 25 e-waste items!', 400, 200));
      }
    }

    // Streak achievements
    final currentStreak = _pointsService.currentStreak;
    if (currentStreak == 7 && !_hasAchievement('week_streak')) {
      newAchievements.add(_createAchievement('week_streak', 'Consistency King', 
          'Maintained a 7-day streak!', 300, 150));
    }
    if (currentStreak == 30 && !_hasAchievement('month_streak')) {
      newAchievements.add(_createAchievement('month_streak', 'Dedication Master', 
          'Maintained a 30-day streak!', 1000, 500));
    }

    // Process new achievements
    for (final achievement in newAchievements) {
      await _unlockAchievement(achievement);
    }

    // Update challenges
    await _updateChallengeProgress(actionType, value);
  }

  Achievement _createAchievement(String id, String title, String description, 
      int points, int xp) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      points: points,
      experiencePoints: xp,
      unlockedAt: DateTime.now(),
      iconName: _getAchievementIcon(id),
      rarity: _getAchievementRarity(points),
    );
  }

  String _getAchievementIcon(String id) {
    if (id.contains('tree')) return 'park';
    if (id.contains('recycle')) return 'recycling';
    if (id.contains('streak')) return 'local_fire_department';
    return 'emoji_events';
  }

  AchievementRarity _getAchievementRarity(int points) {
    if (points >= 1000) return AchievementRarity.legendary;
    if (points >= 500) return AchievementRarity.epic;
    if (points >= 200) return AchievementRarity.rare;
    return AchievementRarity.common;
  }

  bool _hasAchievement(String id) {
    return _unlockedAchievements.any((achievement) => achievement.id == id);
  }

  Future<void> _unlockAchievement(Achievement achievement) async {
    _unlockedAchievements.add(achievement);
    
    // Add XP and check for level up
    await _addExperience(achievement.experiencePoints);
    
    // Save achievement
    final achievementData = Map<String, dynamic>.from(_achievementsBox.get('unlocked', defaultValue: <String, dynamic>{}) as Map<String, dynamic>);
    achievementData[achievement.id] = achievement.toMap();
    await _achievementsBox.put('unlocked', achievementData);
    
    // Show notification
    await _notificationService.showAchievementUnlocked(
      achievement.title,
      achievement.description,
    );
    
    notifyListeners();
  }

  Future<void> _addExperience(int xp) async {
    _experiencePoints += xp;
    
    // Check for level up
    final requiredXP = _currentLevel * 1000;
    if (_experiencePoints >= requiredXP) {
      _currentLevel++;
      _experiencePoints -= requiredXP;
      
      // Award level up bonus
      await _pointsService.addActivity(
        'level_up',
        'Reached level $_currentLevel!',
        _currentLevel * 50,
      );
      
      await _notificationService.showLevelUp(_currentLevel);
    }
    
    // Save level data
    await _achievementsBox.put('level', {
      'level': _currentLevel,
      'xp': _experiencePoints,
    });
  }

  Future<void> _updateChallengeProgress(String actionType, int value) async {
    bool challengesUpdated = false;
    
    for (final challenge in _activeChallenges) {
      if (challenge.isCompleted || challenge.isExpired) continue;
      
      bool shouldUpdate = false;
      switch (challenge.category) {
        case 'trees':
          shouldUpdate = actionType == 'tree_planted';
          break;
        case 'ewaste':
          shouldUpdate = actionType == 'ewaste_recycled';
          break;
        case 'carbon':
          shouldUpdate = actionType == 'carbon_calculated';
          break;
        case 'general':
          shouldUpdate = ['tree_planted', 'ewaste_recycled', 'carbon_calculated']
              .contains(actionType);
          break;
      }
      
      if (shouldUpdate) {
        challenge.currentProgress += value;
        challengesUpdated = true;
        
        if (challenge.isCompleted && !challenge.rewardClaimed) {
          await _claimChallengeReward(challenge);
        }
      }
    }
    
    if (challengesUpdated) {
      await _saveChallenges();
      notifyListeners();
    }
  }

  Future<void> _claimChallengeReward(Challenge challenge) async {
    challenge.rewardClaimed = true;
    
    // Award points
    await _pointsService.addActivity(
      'challenge_completed',
      'Completed: ${challenge.title}',
      challenge.rewardPoints,
    );
    
    // Award XP
    await _addExperience(challenge.rewardXP);
    
    // Show notification
    await _notificationService.showChallengeCompleted(
      challenge.title,
      challenge.rewardPoints,
    );
  }

  Future<void> earnBadge(String badgeId, String title, String description) async {
    if (_earnedBadges.any((badge) => badge.id == badgeId)) return;
    
    final badge = Badge(
      id: badgeId,
      title: title,
      description: description,
      earnedAt: DateTime.now(),
      iconName: _getBadgeIcon(badgeId),
    );
    
    _earnedBadges.add(badge);
    
    // Save badge
    final badgeData = Map<String, dynamic>.from(_badgesBox.get('earned', defaultValue: <String, dynamic>{}) as Map<String, dynamic>);
    badgeData[badge.id] = badge.toMap();
    await _badgesBox.put('earned', badgeData);
    
    await _notificationService.showBadgeEarned(badge.title, badge.description);
    notifyListeners();
  }

  String _getBadgeIcon(String badgeId) {
    if (badgeId.contains('streak')) return 'local_fire_department';
    if (badgeId.contains('tree')) return 'park';
    if (badgeId.contains('recycle')) return 'recycling';
    return 'military_tech';
  }

  // Getters for UI
  double get levelProgress {
    final requiredXP = _currentLevel * 1000;
    return _experiencePoints / requiredXP;
  }

  List<Challenge> get completedChallenges {
    return _activeChallenges.where((c) => c.isCompleted).toList();
  }

  List<Challenge> get activeChallengesOnly {
    return _activeChallenges.where((c) => !c.isCompleted && !c.isExpired).toList();
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final int points;
  final int experiencePoints;
  final DateTime unlockedAt;
  final String iconName;
  final AchievementRarity rarity;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.experiencePoints,
    required this.unlockedAt,
    required this.iconName,
    required this.rarity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'experiencePoints': experiencePoints,
      'unlockedAt': unlockedAt.toIso8601String(),
      'iconName': iconName,
      'rarity': rarity.index,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      points: map['points'],
      experiencePoints: map['experiencePoints'],
      unlockedAt: DateTime.parse(map['unlockedAt']),
      iconName: map['iconName'],
      rarity: AchievementRarity.values[map['rarity']],
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetValue;
  int currentProgress;
  final int rewardPoints;
  final int rewardXP;
  final String category;
  final DateTime expiresAt;
  bool rewardClaimed;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentProgress,
    required this.rewardPoints,
    required this.rewardXP,
    required this.category,
    required this.expiresAt,
    this.rewardClaimed = false,
  });

  bool get isCompleted => currentProgress >= targetValue;
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  double get progress => (currentProgress / targetValue).clamp(0.0, 1.0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'rewardPoints': rewardPoints,
      'rewardXP': rewardXP,
      'category': category,
      'expiresAt': expiresAt.toIso8601String(),
      'rewardClaimed': rewardClaimed,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: ChallengeType.values[map['type']],
      targetValue: map['targetValue'],
      currentProgress: map['currentProgress'],
      rewardPoints: map['rewardPoints'],
      rewardXP: map['rewardXP'],
      category: map['category'],
      expiresAt: DateTime.parse(map['expiresAt']),
      rewardClaimed: map['rewardClaimed'] ?? false,
    );
  }
}

class Badge {
  final String id;
  final String title;
  final String description;
  final DateTime earnedAt;
  final String iconName;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.earnedAt,
    required this.iconName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'earnedAt': earnedAt.toIso8601String(),
      'iconName': iconName,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      earnedAt: DateTime.parse(map['earnedAt']),
      iconName: map['iconName'],
    );
  }
}

enum AchievementRarity { common, rare, epic, legendary }
enum ChallengeType { daily, weekly, monthly, special }
