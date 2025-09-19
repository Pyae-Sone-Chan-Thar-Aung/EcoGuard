// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_model.dart';

TreeModel _$TreeModelFromJson(Map<String, dynamic> json) {
  return TreeModel(
    id: json['id'] as String,
    speciesId: json['speciesId'] as String,
    speciesName: json['speciesName'] as String,
    commonName: json['commonName'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    plantedAt: DateTime.parse(json['plantedAt'] as String),
    plantedBy: json['plantedBy'] as String,
    imageUrl: json['imageUrl'] as String?,
    description: json['description'] as String?,
    estimatedCarbonOffset: (json['estimatedCarbonOffset'] as num).toDouble(),
    status: _$enumDecodeNullable(_$TreeStatusEnumMap, json['status']) ?? TreeStatus.planted,
  );
}

Map<String, dynamic> _$TreeModelToJson(TreeModel instance) => <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'speciesName': instance.speciesName,
      'commonName': instance.commonName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'plantedAt': instance.plantedAt.toIso8601String(),
      'plantedBy': instance.plantedBy,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'estimatedCarbonOffset': instance.estimatedCarbonOffset,
      'status': _$TreeStatusEnumMap[instance.status],
    };

K _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source,
) {
  if (source == null) {
    return null as K;
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError('Unknown enum value: $source'))
      .key;
}

const _$TreeStatusEnumMap = {
  TreeStatus.planted: 'planted',
  TreeStatus.growing: 'growing',
  TreeStatus.mature: 'mature',
  TreeStatus.deceased: 'deceased',
};
