class DeviceAnalysis {
  final String id;
  final String deviceName;
  final String brand;
  final DeviceType deviceType;
  final int ageInYears;
  final DeviceCondition condition;
  final List<String> issues;
  final EnvironmentalImpact environmentalImpact;
  final List<SustainabilityOption> sustainabilityOptions;
  final List<HandicraftSuggestion> handicraftSuggestions;
  final double estimatedValue;
  final DateTime createdAt;

  DeviceAnalysis({
    required this.id,
    required this.deviceName,
    required this.brand,
    required this.deviceType,
    required this.ageInYears,
    required this.condition,
    required this.issues,
    required this.environmentalImpact,
    required this.sustainabilityOptions,
    required this.handicraftSuggestions,
    required this.estimatedValue,
    required this.createdAt,
  });

  factory DeviceAnalysis.fromJson(Map<String, dynamic> json) {
    return DeviceAnalysis(
      id: json['id'] as String,
      deviceName: json['deviceName'] as String,
      brand: json['brand'] as String,
      deviceType: DeviceType.values.firstWhere(
        (e) => e.toString() == 'DeviceType.${json['deviceType']}',
      ),
      ageInYears: json['ageInYears'] as int,
      condition: DeviceCondition.values.firstWhere(
        (e) => e.toString() == 'DeviceCondition.${json['condition']}',
      ),
      issues: List<String>.from(json['issues'] as List),
      environmentalImpact: EnvironmentalImpact.fromJson(
        json['environmentalImpact'] as Map<String, dynamic>,
      ),
      sustainabilityOptions: (json['sustainabilityOptions'] as List)
          .map((e) => SustainabilityOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      handicraftSuggestions: (json['handicraftSuggestions'] as List)
          .map((e) => HandicraftSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      estimatedValue: (json['estimatedValue'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceName': deviceName,
      'brand': brand,
      'deviceType': deviceType.toString().split('.').last,
      'ageInYears': ageInYears,
      'condition': condition.toString().split('.').last,
      'issues': issues,
      'environmentalImpact': environmentalImpact.toJson(),
      'sustainabilityOptions': sustainabilityOptions.map((e) => e.toJson()).toList(),
      'handicraftSuggestions': handicraftSuggestions.map((e) => e.toJson()).toList(),
      'estimatedValue': estimatedValue,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class EnvironmentalImpact {
  final double carbonFootprintKg;
  final double energySavedKwh;
  final List<String> harmfulMaterials;
  final double recycleValuePercentage;
  final String impactLevel; // Low, Medium, High
  final String description;

  EnvironmentalImpact({
    required this.carbonFootprintKg,
    required this.energySavedKwh,
    required this.harmfulMaterials,
    required this.recycleValuePercentage,
    required this.impactLevel,
    required this.description,
  });

  factory EnvironmentalImpact.fromJson(Map<String, dynamic> json) {
    return EnvironmentalImpact(
      carbonFootprintKg: (json['carbonFootprintKg'] as num).toDouble(),
      energySavedKwh: (json['energySavedKwh'] as num).toDouble(),
      harmfulMaterials: List<String>.from(json['harmfulMaterials'] as List),
      recycleValuePercentage: (json['recycleValuePercentage'] as num).toDouble(),
      impactLevel: json['impactLevel'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carbonFootprintKg': carbonFootprintKg,
      'energySavedKwh': energySavedKwh,
      'harmfulMaterials': harmfulMaterials,
      'recycleValuePercentage': recycleValuePercentage,
      'impactLevel': impactLevel,
      'description': description,
    };
  }
}

class SustainabilityOption {
  final String id;
  final SustainabilityType type;
  final String title;
  final String description;
  final List<String> steps;
  final double environmentalBenefit;
  final double economicBenefit;
  final String difficulty; // Easy, Medium, Hard
  final List<String> requiredMaterials;
  final String estimatedTime;
  final List<String> locations; // For recycling centers or repair shops

  SustainabilityOption({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.steps,
    required this.environmentalBenefit,
    required this.economicBenefit,
    required this.difficulty,
    required this.requiredMaterials,
    required this.estimatedTime,
    required this.locations,
  });

  factory SustainabilityOption.fromJson(Map<String, dynamic> json) {
    return SustainabilityOption(
      id: json['id'] as String,
      type: SustainabilityType.values.firstWhere(
        (e) => e.toString() == 'SustainabilityType.${json['type']}',
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      steps: List<String>.from(json['steps'] as List),
      environmentalBenefit: (json['environmentalBenefit'] as num).toDouble(),
      economicBenefit: (json['economicBenefit'] as num).toDouble(),
      difficulty: json['difficulty'] as String,
      requiredMaterials: List<String>.from(json['requiredMaterials'] as List),
      estimatedTime: json['estimatedTime'] as String,
      locations: List<String>.from(json['locations'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'steps': steps,
      'environmentalBenefit': environmentalBenefit,
      'economicBenefit': economicBenefit,
      'difficulty': difficulty,
      'requiredMaterials': requiredMaterials,
      'estimatedTime': estimatedTime,
      'locations': locations,
    };
  }
}

class HandicraftSuggestion {
  final String id;
  final String title;
  final String description;
  final HandicraftCategory category;
  final List<String> materials;
  final List<String> tools;
  final List<String> steps;
  final String difficulty;
  final String estimatedTime;
  final String imageUrl;
  final List<String> benefits;
  final bool isEcoFriendly;

  HandicraftSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.materials,
    required this.tools,
    required this.steps,
    required this.difficulty,
    required this.estimatedTime,
    required this.imageUrl,
    required this.benefits,
    this.isEcoFriendly = true,
  });

  factory HandicraftSuggestion.fromJson(Map<String, dynamic> json) {
    return HandicraftSuggestion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: HandicraftCategory.values.firstWhere(
        (e) => e.toString() == 'HandicraftCategory.${json['category']}',
      ),
      materials: List<String>.from(json['materials'] as List),
      tools: List<String>.from(json['tools'] as List),
      steps: List<String>.from(json['steps'] as List),
      difficulty: json['difficulty'] as String,
      estimatedTime: json['estimatedTime'] as String,
      imageUrl: json['imageUrl'] as String,
      benefits: List<String>.from(json['benefits'] as List),
      isEcoFriendly: json['isEcoFriendly'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'materials': materials,
      'tools': tools,
      'steps': steps,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'imageUrl': imageUrl,
      'benefits': benefits,
      'isEcoFriendly': isEcoFriendly,
    };
  }
}

enum DeviceType {
  smartphone,
  tablet,
  laptop,
  desktop,
  television,
  printer,
  camera,
  gamingConsole,
  smartwatch,
  headphones,
  router,
  keyboard,
  mouse,
  monitor,
  speaker,
  other,
}

enum DeviceCondition {
  excellent,
  good,
  fair,
  poor,
  broken,
  partsOnly,
}

enum SustainabilityType {
  repair,
  refurbish,
  donate,
  sell,
  recycle,
  upcycle,
  repurpose,
}

enum HandicraftCategory {
  decoration,
  furniture,
  storage,
  lighting,
  garden,
  art,
  functional,
  educational,
}
