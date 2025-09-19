import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  List<AppNotification> _notifications = [];

  bool get isInitialized => _isInitialized;
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Initialize with demo notifications
    _notifications = [
      AppNotification(
        id: '1',
        title: 'Daily Challenge',
        message: 'Plant 10 trees today to earn bonus points!',
        type: NotificationType.challenge,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '2',
        title: 'E-Waste Reminder',
        message: 'Don\'t forget to scan and sort your electronic waste.',
        type: NotificationType.reminder,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: '3',
        title: 'Achievement Unlocked',
        message: 'You\'ve reached a 7-day streak! Keep it up!',
        type: NotificationType.achievement,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    
    _isInitialized = true;
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // Missing methods for gamification integration
  Future<void> showAchievementUnlocked(String title, String description) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Achievement Unlocked: $title',
      message: description,
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }

  Future<void> showLevelUp(int level) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Level Up!',
      message: 'Congratulations! You\'ve reached level $level!',
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }

  Future<void> showChallengeCompleted(String title, int points) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Challenge Completed!',
      message: 'You completed "$title" and earned $points points!',
      type: NotificationType.challenge,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }

  Future<void> showBadgeEarned(String title, String description) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Badge Earned: $title',
      message: description,
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }

  Future<void> showRecyclingConfirmed(String deviceName, int points) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Recycling Confirmed!',
      message: 'You recycled $deviceName and earned $points points!',
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }

  // Trigger notifications for specific events
  void notifyTreePlanted(String treeName) {
    addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Tree Planted! 🌱',
      message: 'You planted a $treeName and earned eco points!',
      type: NotificationType.success,
      createdAt: DateTime.now(),
    ));
  }

  void notifyEwasteRecycled(String itemName) {
    addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'E-Waste Recycled! ♻️',
      message: 'You recycled a $itemName responsibly!',
      type: NotificationType.success,
      createdAt: DateTime.now(),
    ));
  }

  void notifyStreakAchieved(int streakDays) {
    addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Streak Achievement! 🔥',
      message: 'Amazing! You\'ve maintained a $streakDays-day streak!',
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    ));
  }

  void notifyDailyChallenge() {
    addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Daily Challenge! 🎯',
      message: 'Complete today\'s eco-challenge to earn bonus points!',
      type: NotificationType.challenge,
      createdAt: DateTime.now(),
    ));
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

enum NotificationType {
  challenge,
  reminder,
  achievement,
  success,
  info,
  warning,
}
