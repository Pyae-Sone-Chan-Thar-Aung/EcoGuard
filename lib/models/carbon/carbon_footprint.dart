import 'package:json_annotation/json_annotation.dart';
part 'carbon_footprint.g.dart';

@JsonSerializable()
class CarbonFootprint {
  final String id;
  final String userId;
  final DateTime calculatedAt;
  final double totalAnnualEmissions;
  final Map<String, double> emissionsByCategory;
  final List<String> recommendedActions;
  final double treesNeededToOffset;

  CarbonFootprint({
    required this.id,
    required this.userId,
    required this.calculatedAt,
    required this.totalAnnualEmissions,
    required this.emissionsByCategory,
    required this.recommendedActions,
    required this.treesNeededToOffset,
  });

  factory CarbonFootprint.fromJson(Map<String,dynamic> json)=>_$CarbonFootprintFromJson(json);
  Map<String,dynamic> toJson()=>_$CarbonFootprintToJson(this);
}
