import 'package:json_annotation/json_annotation.dart';
part 'ewaste_item.g.dart';

@JsonSerializable()
class EwasteItem {
  final String id;
  final String name;
  final String description;
  final EwasteCategory category;
  final String imageUrl;
  final List<String> disposalInstructions;
  final bool isHazardous;
  final int ecoPointsValue;
  final List<String> recyclingCenters;

  EwasteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.disposalInstructions,
    this.isHazardous = false,
    this.ecoPointsValue = 10,
    this.recyclingCenters = const [],
  });

  factory EwasteItem.fromJson(Map<String,dynamic> json)=>_$EwasteItemFromJson(json);
  Map<String,dynamic> toJson()=>_$EwasteItemToJson(this);
}

enum EwasteCategory {
  smartphones,
  computers,
  batteries,
  appliances,
  cables,
  monitors,
  printers,
  other,
}
