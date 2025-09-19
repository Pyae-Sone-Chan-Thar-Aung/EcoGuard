import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PointsService extends ChangeNotifier {
  static final PointsService _instance = PointsService._internal();
  factory PointsService() => _instance;
  PointsService._internal();

  late Box<int> _pointsBox;
  late Box<Map> _activitiesBox;
  late Box<Map> _statsBox;

  bool _isInitialized = false;
  int _totalPoints = 0;
  List<ActivityItem> _recentActivities = [];
  UserStats _stats = UserStats();

  bool get isInitialized => _isInitialized;
  int get totalPoints => _totalPoints;
  List<ActivityItem> get recentActivities => _recentActivities;
  UserStats get stats => _stats;
  int get currentStreak => _calculateCurrentStreak();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _pointsBox = await Hive.openBox<int>('points');
      _activitiesBox = await Hive.openBox<Map>('activities');
      _statsBox = await Hive.openBox<Map>('stats');

      _loadData();
      
      // Add some demo data if this is the first time
      if (_totalPoints == 0 && _recentActivities.isEmpty) {
        await _initializeDemoData();
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing PointsService: $e');
    }
  }
  
  Future<void> _initializeDemoData() async {
    // Add some sample activities to show how the system works
    final now = DateTime.now();
    
    await addTreePlantingActivity('English Oak', 25);
    await Future.delayed(const Duration(milliseconds: 100));
    
    await addEwasteRecyclingActivity('Smartphone', 15);
    await Future.delayed(const Duration(milliseconds: 100));
    
    await addSortingGameActivity(80, 8, 10);
  }

  void _loadData() {
    // Load total points
    _totalPoints = _pointsBox.get('total', defaultValue: 0)!;

    // Load activities
    _recentActivities = [];
    for (int i = 0; i < _activitiesBox.length; i++) {
      final activityData = _activitiesBox.getAt(i);
      if (activityData != null) {
        _recentActivities.add(ActivityItem.fromMap(Map<String, dynamic>.from(activityData)));
      }
    }
    
    // Sort by timestamp (most recent first)
    _recentActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Load stats
    final statsData = _statsBox.get('user_stats');
    if (statsData != null) {
      _stats = UserStats.fromMap(Map<String, dynamic>.from(statsData));
    }
  }

  Future<void> addTreePlantingActivity(String treeSpecies, int points) async {
    await _addActivity(
      ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.treePlanting,
        title: 'Planted $treeSpecies',
        description: 'Added a new tree to your forest',
        points: points,
        timestamp: DateTime.now(),
        icon: '🌳',
      ),
    );
    
    _stats = _stats.copyWith(treesPlanted: _stats.treesPlanted + 1);
    await _saveStats();
  }

  Future<void> addEwasteRecyclingActivity(String itemName, int points) async {
    await _addActivity(
      ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.ewasteRecycling,
        title: 'Recycled $itemName',
        description: 'Scanned and identified e-waste item',
        points: points,
        timestamp: DateTime.now(),
        icon: '♻️',
      ),
    );
    
    _stats = _stats.copyWith(itemsRecycled: _stats.itemsRecycled + 1);
    await _saveStats();
  }

  Future<void> addSortingGameActivity(int score, int correctAnswers, int totalQuestions) async {
    await _addActivity(
      ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.sortingGame,
        title: 'Completed Sorting Game',
        description: 'Scored $correctAnswers/$totalQuestions correct',
        points: score,
        timestamp: DateTime.now(),
        icon: '🎮',
      ),
    );
    
    _stats = _stats.copyWith(gamesPlayed: _stats.gamesPlayed + 1);
    await _saveStats();
  }

  Future<void> addCarbonCalculationActivity(double carbonFootprint, int points) async {
    await _addActivity(
      ActivityItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.carbonCalculation,
        title: 'Updated Carbon Footprint',
        description: '${carbonFootprint.toStringAsFixed(1)} kg CO₂/year calculated',
        points: points,
        timestamp: DateTime.now(),
        icon: '📊',
      ),
    );
  }

  Future<void> _addActivity(ActivityItem activity) async {
    _totalPoints += activity.points;
    await _pointsBox.put('total', _totalPoints);

    _recentActivities.insert(0, activity);
    
    // Keep only last 20 activities
    if (_recentActivities.length > 20) {
      _recentActivities = _recentActivities.take(20).toList();
    }

    // Save activities to Hive
    await _activitiesBox.clear();
    for (int i = 0; i < _recentActivities.length; i++) {
      await _activitiesBox.add(_recentActivities[i].toMap());
    }

    notifyListeners();
  }

  Future<void> _saveStats() async {
    await _statsBox.put('user_stats', _stats.toMap());
    notifyListeners();
  }

  // Calculate streak
  int calculateCurrentStreak() {
    if (_recentActivities.isEmpty) return 0;

    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 30; i++) { // Check last 30 days
      final checkDate = today.subtract(Duration(days: i));
      final hasActivityOnDay = _recentActivities.any((activity) =>
          activity.timestamp.year == checkDate.year &&
          activity.timestamp.month == checkDate.month &&
          activity.timestamp.day == checkDate.day);
      
      if (hasActivityOnDay) {
        streak++;
      } else if (i > 0) { // Allow for today having no activity yet
        break;
      }
    }
    
    return streak;
  }

  // Get activities by type for specific screens
  List<ActivityItem> getActivitiesByType(ActivityType type) {
    return _recentActivities.where((activity) => activity.type == type).toList();
  }

  // Calculate CO2 saved (rough estimate)
  double calculateCO2Saved() {
    double co2Saved = 0;
    co2Saved += _stats.treesPlanted * 22.0; // ~22kg CO2 per tree per year
    co2Saved += _stats.itemsRecycled * 2.1; // ~2.1kg CO2 saved per recycled item
    return co2Saved;
  }

  // Calculate current streak
  int _calculateCurrentStreak() {
    if (_recentActivities.isEmpty) return 0;
    
    final now = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 30; i++) { // Check last 30 days
      final checkDate = now.subtract(Duration(days: i));
      bool hasActivity = _recentActivities.any((activity) {
        final activityDate = activity.timestamp;
        return activityDate.year == checkDate.year &&
               activityDate.month == checkDate.month &&
               activityDate.day == checkDate.day;
      });
      
      if (hasActivity) {
        streak++;
      } else if (i > 0) { // Allow for today to not have activity yet
        break;
      }
    }
    
    return streak;
  }

  // Add activity method
  Future<void> addActivity(String type, String description, int points) async {
    final activity = ActivityItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _getActivityType(type),
      title: type,
      description: description,
      points: points,
      timestamp: DateTime.now(),
      icon: _getActivityIcon(type),
    );

    _recentActivities.insert(0, activity);
    _totalPoints += points;

    // Update stats based on activity type
    _updateStatsForActivity(type);

    await _saveData();
    notifyListeners();
  }

  ActivityType _getActivityType(String type) {
    switch (type) {
      case 'tree_planted':
        return ActivityType.treePlanting;
      case 'ewaste_recycled':
        return ActivityType.ewasteRecycling;
      case 'carbon_calculated':
        return ActivityType.carbonCalculation;
      default:
        return ActivityType.ewasteRecycling;
    }
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'tree_planted':
        return 'park';
      case 'ewaste_recycled':
        return 'recycling';
      case 'carbon_calculated':
        return 'co2';
      default:
        return 'eco';
    }
  }

  void _updateStatsForActivity(String type) {
    switch (type) {
      case 'tree_planted':
        _stats = _stats.copyWith(treesPlanted: _stats.treesPlanted + 1);
        break;
      case 'ewaste_recycled':
        _stats = _stats.copyWith(
          ewasteRecycled: _stats.ewasteRecycled + 1,
          itemsRecycled: _stats.itemsRecycled + 1,
        );
        break;
      case 'carbon_calculated':
        // No specific stat update needed
        break;
    }
    
    // Update CO2 saved
    _stats = _stats.copyWith(co2Saved: calculateCO2Saved());
  }

  Future<void> _saveData() async {
    // Persist total points
    await _pointsBox.put('total', _totalPoints);

    // Persist recent activities
    await _activitiesBox.clear();
    for (final activity in _recentActivities) {
      await _activitiesBox.add(activity.toMap());
    }

    // Persist stats
    await _saveStats();
  }
}

enum ActivityType {
  treePlanting,
  ewasteRecycling,
  sortingGame,
  carbonCalculation,
}

class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final int points;
  final DateTime timestamp;
  final String icon;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.points,
    required this.timestamp,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'description': description,
      'points': points,
      'timestamp': timestamp.toIso8601String(),
      'icon': icon,
    };
  }

  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    return ActivityItem(
      id: map['id'],
      type: ActivityType.values[map['type']],
      title: map['title'],
      description: map['description'],
      points: map['points'],
      timestamp: DateTime.parse(map['timestamp']),
      icon: map['icon'],
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class UserStats {
  final int treesPlanted;
  final int itemsRecycled;
  final int ewasteRecycled;
  final int gamesPlayed;
  final int achievements;
  final double co2Saved;
  final DateTime lastUpdated;

  UserStats({
    this.treesPlanted = 0,
    this.itemsRecycled = 0,
    this.ewasteRecycled = 0,
    this.gamesPlayed = 0,
    this.achievements = 0,
    this.co2Saved = 0.0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  UserStats copyWith({
    int? treesPlanted,
    int? itemsRecycled,
    int? ewasteRecycled,
    int? gamesPlayed,
    int? achievements,
    double? co2Saved,
    DateTime? lastUpdated,
  }) {
    return UserStats(
      treesPlanted: treesPlanted ?? this.treesPlanted,
      itemsRecycled: itemsRecycled ?? this.itemsRecycled,
      ewasteRecycled: ewasteRecycled ?? this.ewasteRecycled,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      achievements: achievements ?? this.achievements,
      co2Saved: co2Saved ?? this.co2Saved,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'treesPlanted': treesPlanted,
      'itemsRecycled': itemsRecycled,
      'ewasteRecycled': ewasteRecycled,
      'gamesPlayed': gamesPlayed,
      'achievements': achievements,
      'co2Saved': co2Saved,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      treesPlanted: map['treesPlanted'] ?? 0,
      itemsRecycled: map['itemsRecycled'] ?? 0,
      ewasteRecycled: map['ewasteRecycled'] ?? 0,
      gamesPlayed: map['gamesPlayed'] ?? 0,
      achievements: map['achievements'] ?? 0,
      co2Saved: map['co2Saved']?.toDouble() ?? 0.0,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'])
          : DateTime.now(),
    );
  }
}
