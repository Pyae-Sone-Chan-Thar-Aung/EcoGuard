import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final int ecoPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final List<String> achievements;
  final String? preferredLanguage;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.ecoPoints,
    required this.currentStreak,
    required this.longestStreak,
    required this.createdAt,
    required this.lastActiveAt,
    this.achievements = const [],
    this.preferredLanguage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
