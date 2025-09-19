import 'package:json_annotation/json_annotation.dart';
part 'tree_model.g.dart';

@JsonSerializable()
class TreeModel {
  final String id;
  final String speciesId;
  final String speciesName;
  final String commonName;
  final double latitude;
  final double longitude;
  final DateTime plantedAt;
  final String plantedBy;
  final String? imageUrl;
  final String? description;
  final double estimatedCarbonOffset;
  final TreeStatus status;

  TreeModel({
    required this.id,
    required this.speciesId,
    required this.speciesName,
    required this.commonName,
    required this.latitude,
    required this.longitude,
    required this.plantedAt,
    required this.plantedBy,
    this.imageUrl,
    this.description,
    required this.estimatedCarbonOffset,
    this.status = TreeStatus.planted,
  });

  factory TreeModel.fromJson(Map<String,dynamic> json)=>_$TreeModelFromJson(json);
  Map<String,dynamic> toJson()=>_$TreeModelToJson(this);
}

enum TreeStatus { planted, growing, mature, deceased }
