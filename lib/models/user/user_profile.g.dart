// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    avatarUrl: json['avatarUrl'] as String?,
    ecoPoints: json['ecoPoints'] as int? ?? 0,
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
    achievements: (json['achievements'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'ecoPoints': instance.ecoPoints,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActiveAt': instance.lastActiveAt.toIso8601String(),
      'achievements': instance.achievements,
      'preferredLanguage': instance.preferredLanguage,
    };
