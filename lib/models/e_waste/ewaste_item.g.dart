// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ewaste_item.dart';

EwasteItem _$EwasteItemFromJson(Map<String, dynamic> json) {
  return EwasteItem(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    category: _$enumDecode(_$EwasteCategoryEnumMap, json['category']),
    imageUrl: json['imageUrl'] as String,
    disposalInstructions: (json['disposalInstructions'] as List<dynamic>).map((e) => e as String).toList(),
    isHazardous: json['isHazardous'] as bool? ?? false,
    ecoPointsValue: json['ecoPointsValue'] as int? ?? 10,
    recyclingCenters: (json['recyclingCenters'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  );
}

Map<String, dynamic> _$EwasteItemToJson(EwasteItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$EwasteCategoryEnumMap[instance.category],
      'imageUrl': instance.imageUrl,
      'disposalInstructions': instance.disposalInstructions,
      'isHazardous': instance.isHazardous,
      'ecoPointsValue': instance.ecoPointsValue,
      'recyclingCenters': instance.recyclingCenters,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  dynamic source,
) {
  return enumValues.entries.singleWhere((e) => e.value == source).key;
}

const _$EwasteCategoryEnumMap = {
  EwasteCategory.smartphones: 'smartphones',
  EwasteCategory.computers: 'computers',
  EwasteCategory.batteries: 'batteries',
  EwasteCategory.appliances: 'appliances',
  EwasteCategory.cables: 'cables',
  EwasteCategory.monitors: 'monitors',
  EwasteCategory.printers: 'printers',
  EwasteCategory.other: 'other',
};
