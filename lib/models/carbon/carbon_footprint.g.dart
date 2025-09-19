// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_footprint.dart';

CarbonFootprint _$CarbonFootprintFromJson(Map<String, dynamic> json) {
  return CarbonFootprint(
    id: json['id'] as String,
    userId: json['userId'] as String,
    calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    totalAnnualEmissions: (json['totalAnnualEmissions'] as num).toDouble(),
    emissionsByCategory: (json['emissionsByCategory'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, (e as num).toDouble()),
    ),
    recommendedActions: (json['recommendedActions'] as List<dynamic>).map((e) => e as String).toList(),
    treesNeededToOffset: (json['treesNeededToOffset'] as num).toDouble(),
  );
}

Map<String, dynamic> _$CarbonFootprintToJson(CarbonFootprint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'totalAnnualEmissions': instance.totalAnnualEmissions,
      'emissionsByCategory': instance.emissionsByCategory,
      'recommendedActions': instance.recommendedActions,
      'treesNeededToOffset': instance.treesNeededToOffset,
    };
