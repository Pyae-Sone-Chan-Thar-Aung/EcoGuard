import 'dart:math';
import '../../models/e_waste/device_analysis.dart';

class DeviceAnalysisService {
  static final DeviceAnalysisService _instance = DeviceAnalysisService._internal();
  factory DeviceAnalysisService() => _instance;
  DeviceAnalysisService._internal();

  Future<DeviceAnalysis> analyzeDevice({
    required String deviceName,
    required String brand,
    required DeviceType deviceType,
    required int ageInYears,
    required DeviceCondition condition,
    required List<String> issues,
  }) async {
    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));

    final environmentalImpact = _calculateEnvironmentalImpact(deviceType, ageInYears, condition);
    final sustainabilityOptions = _generateSustainabilityOptions(deviceType, condition, issues);
    final handicraftSuggestions = _generateHandicraftSuggestions(deviceType, condition);
    final estimatedValue = _calculateEstimatedValue(deviceType, ageInYears, condition, brand);

    return DeviceAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      deviceName: deviceName,
      brand: brand,
      deviceType: deviceType,
      ageInYears: ageInYears,
      condition: condition,
      issues: issues,
      environmentalImpact: environmentalImpact,
      sustainabilityOptions: sustainabilityOptions,
      handicraftSuggestions: handicraftSuggestions,
      estimatedValue: estimatedValue,
      createdAt: DateTime.now(),
    );
  }

  EnvironmentalImpact _calculateEnvironmentalImpact(
    DeviceType deviceType,
    int ageInYears,
    DeviceCondition condition,
  ) {
    final baseFootprint = _getBaseCarbonFootprint(deviceType);
    final carbonFootprintKg = baseFootprint * (1 + ageInYears * 0.1);
    final energySavedKwh = _getEnergySavings(deviceType, condition);
    final harmfulMaterials = _getHarmfulMaterials(deviceType);
    final recycleValuePercentage = _getRecycleValue(deviceType, condition);
    
    String impactLevel;
    if (carbonFootprintKg > 50) {
      impactLevel = "High";
    } else if (carbonFootprintKg > 20) {
      impactLevel = "Medium";
    } else {
      impactLevel = "Low";
    }

    return EnvironmentalImpact(
      carbonFootprintKg: carbonFootprintKg,
      energySavedKwh: energySavedKwh,
      harmfulMaterials: harmfulMaterials,
      recycleValuePercentage: recycleValuePercentage,
      impactLevel: impactLevel,
      description: _getImpactDescription(deviceType, impactLevel),
    );
  }

  List<SustainabilityOption> _generateSustainabilityOptions(
    DeviceType deviceType,
    DeviceCondition condition,
    List<String> issues,
  ) {
    List<SustainabilityOption> options = [];

    // Repair option
    if (condition != DeviceCondition.partsOnly && issues.isNotEmpty) {
      options.add(SustainabilityOption(
        id: 'repair_${deviceType.name}',
        type: SustainabilityType.repair,
        title: 'Repair Your Device',
        description: 'Fix the issues and extend the device\'s life',
        steps: _getRepairSteps(deviceType, issues),
        environmentalBenefit: 85.0,
        economicBenefit: 70.0,
        difficulty: _getRepairDifficulty(issues),
        requiredMaterials: _getRepairMaterials(issues),
        estimatedTime: _getRepairTime(issues),
        locations: _getRepairLocations(deviceType),
      ));
    }

    // Donation option
    if (condition == DeviceCondition.excellent || condition == DeviceCondition.good) {
      options.add(SustainabilityOption(
        id: 'donate_${deviceType.name}',
        type: SustainabilityType.donate,
        title: 'Donate to Community',
        description: 'Help someone in need while reducing e-waste',
        steps: _getDonationSteps(),
        environmentalBenefit: 95.0,
        economicBenefit: 0.0,
        difficulty: 'Easy',
        requiredMaterials: ['Original box (if available)', 'Charger', 'User manual'],
        estimatedTime: '1-2 hours',
        locations: _getDonationCenters(),
      ));
    }

    // Sell option
    if (condition != DeviceCondition.broken && condition != DeviceCondition.partsOnly) {
      options.add(SustainabilityOption(
        id: 'sell_${deviceType.name}',
        type: SustainabilityType.sell,
        title: 'Sell Your Device',
        description: 'Get money while keeping the device in circulation',
        steps: _getSellingSteps(deviceType),
        environmentalBenefit: 80.0,
        economicBenefit: 90.0,
        difficulty: 'Easy',
        requiredMaterials: ['Device photos', 'Original accessories'],
        estimatedTime: '2-3 hours',
        locations: _getSellingPlatforms(),
      ));
    }

    // Recycle option (always available)
    options.add(SustainabilityOption(
      id: 'recycle_${deviceType.name}',
      type: SustainabilityType.recycle,
      title: 'Responsible Recycling',
      description: 'Ensure proper disposal of electronic components',
      steps: _getRecyclingSteps(deviceType),
      environmentalBenefit: 75.0,
      economicBenefit: 10.0,
      difficulty: 'Easy',
      requiredMaterials: ['Data backup', 'Factory reset'],
      estimatedTime: '30 minutes',
      locations: _getRecyclingCenters(),
    ));

    return options;
  }

  List<HandicraftSuggestion> _generateHandicraftSuggestions(
    DeviceType deviceType,
    DeviceCondition condition,
  ) {
    List<HandicraftSuggestion> suggestions = [];

    switch (deviceType) {
      case DeviceType.smartphone:
        suggestions.addAll(_getSmartphoneHandicrafts(condition));
        break;
      case DeviceType.laptop:
      case DeviceType.desktop:
        suggestions.addAll(_getComputerHandicrafts(condition));
        break;
      case DeviceType.monitor:
      case DeviceType.television:
        suggestions.addAll(_getScreenHandicrafts(condition));
        break;
      case DeviceType.keyboard:
        suggestions.addAll(_getKeyboardHandicrafts(condition));
        break;
      default:
        suggestions.addAll(_getGeneralHandicrafts(deviceType, condition));
    }

    return suggestions;
  }

  // Helper methods for environmental impact
  double _getBaseCarbonFootprint(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.smartphone: return 70.0;
      case DeviceType.tablet: return 130.0;
      case DeviceType.laptop: return 300.0;
      case DeviceType.desktop: return 500.0;
      case DeviceType.television: return 800.0;
      case DeviceType.printer: return 200.0;
      case DeviceType.monitor: return 350.0;
      default: return 100.0;
    }
  }

  double _getEnergySavings(DeviceType deviceType, DeviceCondition condition) {
    final baseSavings = _getBaseCarbonFootprint(deviceType) * 0.8;
    final conditionMultiplier = condition == DeviceCondition.excellent ? 1.0 : 
                               condition == DeviceCondition.good ? 0.8 : 0.5;
    return baseSavings * conditionMultiplier;
  }

  List<String> _getHarmfulMaterials(DeviceType deviceType) {
    List<String> materials = ['Lead', 'Mercury', 'Cadmium', 'Chromium'];
    
    if (deviceType == DeviceType.television || deviceType == DeviceType.monitor) {
      materials.add('Phosphorus');
    }
    if (deviceType == DeviceType.smartphone || deviceType == DeviceType.laptop) {
      materials.add('Lithium');
    }
    
    return materials;
  }

  double _getRecycleValue(DeviceType deviceType, DeviceCondition condition) {
    double baseValue = 0.6;
    
    if (deviceType == DeviceType.smartphone || deviceType == DeviceType.laptop) {
      baseValue = 0.8;
    }
    
    switch (condition) {
      case DeviceCondition.excellent: return baseValue * 0.9;
      case DeviceCondition.good: return baseValue * 0.7;
      case DeviceCondition.fair: return baseValue * 0.5;
      case DeviceCondition.poor: return baseValue * 0.3;
      case DeviceCondition.broken: return baseValue * 0.2;
      case DeviceCondition.partsOnly: return baseValue * 0.4;
    }
  }

  String _getImpactDescription(DeviceType deviceType, String impactLevel) {
    switch (impactLevel) {
      case "High":
        return "This device has a significant environmental footprint. Proper disposal or reuse is crucial.";
      case "Medium":
        return "Moderate environmental impact. Consider repair or donation before recycling.";
      default:
        return "Lower environmental impact, but still benefits from responsible disposal.";
    }
  }

  double _calculateEstimatedValue(
    DeviceType deviceType,
    int ageInYears,
    DeviceCondition condition,
    String brand,
  ) {
    double baseValue = _getBaseValue(deviceType, brand);
    double ageDepreciation = pow(0.8, ageInYears).toDouble();
    double conditionMultiplier = _getConditionMultiplier(condition);
    
    return baseValue * ageDepreciation * conditionMultiplier;
  }

  double _getBaseValue(DeviceType deviceType, String brand) {
    double brandMultiplier = 1.0;
    
    // Premium brands
    if (['Apple', 'Samsung', 'Sony', 'Dell', 'HP'].contains(brand)) {
      brandMultiplier = 1.3;
    }
    
    switch (deviceType) {
      case DeviceType.smartphone: return 800.0 * brandMultiplier;
      case DeviceType.tablet: return 600.0 * brandMultiplier;
      case DeviceType.laptop: return 1200.0 * brandMultiplier;
      case DeviceType.desktop: return 800.0 * brandMultiplier;
      case DeviceType.television: return 1000.0 * brandMultiplier;
      default: return 300.0 * brandMultiplier;
    }
  }

  double _getConditionMultiplier(DeviceCondition condition) {
    switch (condition) {
      case DeviceCondition.excellent: return 0.9;
      case DeviceCondition.good: return 0.7;
      case DeviceCondition.fair: return 0.5;
      case DeviceCondition.poor: return 0.3;
      case DeviceCondition.broken: return 0.1;
      case DeviceCondition.partsOnly: return 0.05;
    }
  }

  // Helper methods for sustainability options
  List<String> _getRepairSteps(DeviceType deviceType, List<String> issues) {
    return [
      'Diagnose the specific problem',
      'Check warranty status',
      'Find authorized repair service',
      'Get cost estimate',
      'Decide on repair vs replacement',
      'Complete repair and test functionality',
    ];
  }

  String _getRepairDifficulty(List<String> issues) {
    if (issues.contains('Screen cracked') || issues.contains('Battery issues')) {
      return 'Medium';
    }
    if (issues.contains('Water damage') || issues.contains('Motherboard issues')) {
      return 'Hard';
    }
    return 'Easy';
  }

  List<String> _getRepairMaterials(List<String> issues) {
    List<String> materials = ['Screwdrivers', 'Cleaning supplies'];
    
    if (issues.contains('Screen cracked')) {
      materials.add('Replacement screen');
    }
    if (issues.contains('Battery issues')) {
      materials.add('Replacement battery');
    }
    
    return materials;
  }

  String _getRepairTime(List<String> issues) {
    if (issues.contains('Water damage') || issues.contains('Motherboard issues')) {
      return '1-3 days';
    }
    if (issues.contains('Screen cracked') || issues.contains('Battery issues')) {
      return '2-4 hours';
    }
    return '1-2 hours';
  }

  List<String> _getRepairLocations(DeviceType deviceType) {
    return [
      'Authorized Service Centers',
      'Local Electronics Repair Shops',
      'Mobile Repair Services',
      'DIY Repair Cafes',
    ];
  }

  List<String> _getDonationSteps() {
    return [
      'Back up important data',
      'Factory reset the device',
      'Clean the device thoroughly',
      'Gather original accessories',
      'Contact donation center',
      'Drop off or schedule pickup',
    ];
  }

  List<String> _getDonationCenters() {
    return [
      'Local Schools and Libraries',
      'Community Centers',
      'Senior Centers',
      'Non-profit Organizations',
      'Goodwill Stores',
    ];
  }

  List<String> _getSellingSteps(DeviceType deviceType) {
    return [
      'Clean and prepare device',
      'Take high-quality photos',
      'Research market price',
      'Create detailed listing',
      'Respond to inquiries',
      'Complete safe transaction',
    ];
  }

  List<String> _getSellingPlatforms() {
    return [
      'eBay',
      'Facebook Marketplace',
      'Swappa (for phones)',
      'Gazelle',
      'Local classified ads',
    ];
  }

  List<String> _getRecyclingSteps(DeviceType deviceType) {
    return [
      'Back up important data',
      'Perform factory reset',
      'Remove personal information',
      'Remove batteries if possible',
      'Find certified e-waste recycler',
      'Drop off device safely',
    ];
  }

  List<String> _getRecyclingCenters() {
    return [
      'Best Buy Recycling Program',
      'Staples Electronics Recycling',
      'Local Municipal Centers',
      'Manufacturer Take-back Programs',
      'Certified E-waste Recyclers',
    ];
  }

  // Handicraft suggestions
  List<HandicraftSuggestion> _getSmartphoneHandicrafts(DeviceCondition condition) {
    List<HandicraftSuggestion> suggestions = [];

    if (condition == DeviceCondition.broken || condition == DeviceCondition.partsOnly) {
      suggestions.add(HandicraftSuggestion(
        id: 'phone_clock',
        title: 'Digital Clock Display',
        description: 'Convert your old phone into a unique desk clock',
        category: HandicraftCategory.functional,
        materials: ['Old smartphone', 'Clock app', 'Stand or frame'],
        tools: ['Charger', 'Basic tools for frame modification'],
        steps: [
          'Remove or disable unused functions',
          'Install a clock app with customizable display',
          'Create or buy a suitable stand',
          'Set up permanent power connection',
          'Configure display settings for always-on mode',
        ],
        difficulty: 'Easy',
        estimatedTime: '2-3 hours',
        imageUrl: 'assets/handicrafts/phone_clock.png',
        benefits: ['Unique timepiece', 'Reuses electronics', 'Customizable display'],
      ));

      suggestions.add(HandicraftSuggestion(
        id: 'phone_photo_frame',
        title: 'Digital Photo Frame',
        description: 'Transform your phone into a rotating photo display',
        category: HandicraftCategory.decoration,
        materials: ['Old smartphone', 'Photo slideshow app', 'Picture frame'],
        tools: ['Frame cutting tools', 'Mounting hardware'],
        steps: [
          'Select photos for slideshow',
          'Install photo frame app',
          'Modify picture frame to fit phone',
          'Mount phone securely in frame',
          'Set up slideshow timing and transitions',
        ],
        difficulty: 'Medium',
        estimatedTime: '3-4 hours',
        imageUrl: 'assets/handicrafts/phone_photo_frame.png',
        benefits: ['Personal photo display', 'Reduces waste', 'Conversation starter'],
      ));
    }

    return suggestions;
  }

  List<HandicraftSuggestion> _getComputerHandicrafts(DeviceCondition condition) {
    return [
      HandicraftSuggestion(
        id: 'computer_planter',
        title: 'Tech Planter Box',
        description: 'Convert old computer case into a unique planter',
        category: HandicraftCategory.garden,
        materials: ['Old computer case', 'Drainage materials', 'Soil', 'Plants'],
        tools: ['Drill', 'Waterproof liner', 'Drainage holes'],
        steps: [
          'Remove all electronic components',
          'Clean case thoroughly',
          'Drill drainage holes',
          'Add waterproof liner',
          'Layer drainage materials',
          'Fill with soil and plant',
        ],
        difficulty: 'Medium',
        estimatedTime: '4-5 hours',
        imageUrl: 'assets/handicrafts/computer_planter.png',
        benefits: ['Unique garden feature', 'Conversation piece', 'Zero waste'],
      ),
    ];
  }

  List<HandicraftSuggestion> _getScreenHandicrafts(DeviceCondition condition) {
    return [
      HandicraftSuggestion(
        id: 'screen_mirror',
        title: 'Futuristic Mirror',
        description: 'Turn old screen into a decorative mirror',
        category: HandicraftCategory.decoration,
        materials: ['Old monitor/TV', 'Mirror film', 'LED strips'],
        tools: ['Cleaning supplies', 'Application tools'],
        steps: [
          'Remove electronic components safely',
          'Clean screen thoroughly',
          'Apply mirror film carefully',
          'Add LED backlighting (optional)',
          'Mount securely on wall',
        ],
        difficulty: 'Hard',
        estimatedTime: '6-8 hours',
        imageUrl: 'assets/handicrafts/screen_mirror.png',
        benefits: ['Modern aesthetic', 'Unique home decor', 'Tech upcycling'],
      ),
    ];
  }

  List<HandicraftSuggestion> _getKeyboardHandicrafts(DeviceCondition condition) {
    return [
      HandicraftSuggestion(
        id: 'keyboard_garden',
        title: 'Succulent Keyboard Garden',
        description: 'Plant tiny succulents in keyboard keys',
        category: HandicraftCategory.garden,
        materials: ['Old keyboard', 'Small succulents', 'Soil', 'Moss'],
        tools: ['Small spoon', 'Tweezers', 'Spray bottle'],
        steps: [
          'Remove keys carefully',
          'Clean keyboard base',
          'Fill key spaces with soil',
          'Plant small succulents in keys',
          'Add decorative moss',
          'Create care routine',
        ],
        difficulty: 'Easy',
        estimatedTime: '2-3 hours',
        imageUrl: 'assets/handicrafts/keyboard_garden.png',
        benefits: ['Living art piece', 'Air purification', 'Minimal maintenance'],
      ),
    ];
  }

  List<HandicraftSuggestion> _getGeneralHandicrafts(DeviceType deviceType, DeviceCondition condition) {
    return [
      HandicraftSuggestion(
        id: 'general_art',
        title: 'Electronic Art Sculpture',
        description: 'Create abstract art from electronic components',
        category: HandicraftCategory.art,
        materials: ['Electronic components', 'Base material', 'Adhesive'],
        tools: ['Glue gun', 'Wire cutters', 'Paint (optional)'],
        steps: [
          'Disassemble device safely',
          'Sort components by size/color',
          'Design your composition',
          'Secure components to base',
          'Add finishing touches',
        ],
        difficulty: 'Medium',
        estimatedTime: '4-6 hours',
        imageUrl: 'assets/handicrafts/electronic_art.png',
        benefits: ['Artistic expression', 'Component reuse', 'Educational value'],
      ),
    ];
  }
}
