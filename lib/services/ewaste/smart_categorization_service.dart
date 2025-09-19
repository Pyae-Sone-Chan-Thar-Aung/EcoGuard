import 'package:flutter/foundation.dart';

class SmartCategorizationService {
  static final SmartCategorizationService _instance = SmartCategorizationService._internal();
  factory SmartCategorizationService() => _instance;
  SmartCategorizationService._internal();

  Future<EWasteAnalysis> analyzeDevice(String deviceName, {String? imageData}) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 2000));
    
    final analysis = _performAIAnalysis(deviceName.toLowerCase());
    return analysis;
  }

  EWasteAnalysis _performAIAnalysis(String deviceName) {
    // AI-powered device categorization logic
    if (_isSmartphone(deviceName)) {
      return _analyzeSmartphone(deviceName);
    } else if (_isLaptop(deviceName)) {
      return _analyzeLaptop(deviceName);
    } else if (_isTablet(deviceName)) {
      return _analyzeTablet(deviceName);
    } else if (_isTVMonitor(deviceName)) {
      return _analyzeTVMonitor(deviceName);
    } else if (_isSmallAppliance(deviceName)) {
      return _analyzeSmallAppliance(deviceName);
    } else {
      return _analyzeGenericDevice(deviceName);
    }
  }

  bool _isSmartphone(String name) {
    final phoneKeywords = ['iphone', 'samsung', 'pixel', 'phone', 'mobile', 'android', 'huawei', 'xiaomi', 'oneplus'];
    return phoneKeywords.any((keyword) => name.contains(keyword));
  }

  bool _isLaptop(String name) {
    final laptopKeywords = ['laptop', 'macbook', 'thinkpad', 'surface', 'notebook', 'ultrabook'];
    return laptopKeywords.any((keyword) => name.contains(keyword));
  }

  bool _isTablet(String name) {
    final tabletKeywords = ['ipad', 'tablet', 'surface pro', 'galaxy tab'];
    return tabletKeywords.any((keyword) => name.contains(keyword));
  }

  bool _isTVMonitor(String name) {
    final tvKeywords = ['tv', 'television', 'monitor', 'display', 'screen'];
    return tvKeywords.any((keyword) => name.contains(keyword));
  }

  bool _isSmallAppliance(String name) {
    final applianceKeywords = ['toaster', 'microwave', 'blender', 'coffee', 'kettle', 'iron'];
    return applianceKeywords.any((keyword) => name.contains(keyword));
  }

  EWasteAnalysis _analyzeSmartphone(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.smartphone,
      materials: ['Aluminum', 'Glass', 'Lithium', 'Rare Earth Elements', 'Gold', 'Silver', 'Copper'],
      hazardousMaterials: ['Lithium Battery', 'Lead Solder', 'Mercury (trace)'],
      recyclablePercentage: 85,
      estimatedValue: _getDeviceValue(deviceName, 'smartphone'),
      co2PreventedKg: 12.5,
      energySavedKwh: 45,
      recyclingInstructions: _getSmartphoneRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('electronics'),
      repairOptions: _getRepairOptions(deviceName),
      donationOptions: _getDonationOptions('smartphone'),
      environmentalImpact: _calculateEnvironmentalImpact('smartphone'),
      aiConfidence: 0.95,
    );
  }

  EWasteAnalysis _analyzeLaptop(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.laptop,
      materials: ['Aluminum', 'Plastic', 'Lithium', 'Rare Earth Elements', 'Gold', 'Silver', 'Copper', 'Steel'],
      hazardousMaterials: ['Lithium Battery', 'Lead', 'Mercury', 'Cadmium'],
      recyclablePercentage: 80,
      estimatedValue: _getDeviceValue(deviceName, 'laptop'),
      co2PreventedKg: 35.0,
      energySavedKwh: 120,
      recyclingInstructions: _getLaptopRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('electronics'),
      repairOptions: _getRepairOptions(deviceName),
      donationOptions: _getDonationOptions('laptop'),
      environmentalImpact: _calculateEnvironmentalImpact('laptop'),
      aiConfidence: 0.92,
    );
  }

  EWasteAnalysis _analyzeTablet(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.tablet,
      materials: ['Aluminum', 'Glass', 'Lithium', 'Rare Earth Elements', 'Copper'],
      hazardousMaterials: ['Lithium Battery', 'Lead Solder'],
      recyclablePercentage: 82,
      estimatedValue: _getDeviceValue(deviceName, 'tablet'),
      co2PreventedKg: 18.0,
      energySavedKwh: 65,
      recyclingInstructions: _getTabletRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('electronics'),
      repairOptions: _getRepairOptions(deviceName),
      donationOptions: _getDonationOptions('tablet'),
      environmentalImpact: _calculateEnvironmentalImpact('tablet'),
      aiConfidence: 0.88,
    );
  }

  EWasteAnalysis _analyzeTVMonitor(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.display,
      materials: ['Glass', 'Plastic', 'Copper', 'Steel', 'Aluminum'],
      hazardousMaterials: ['Lead', 'Mercury', 'Cadmium', 'Phosphor'],
      recyclablePercentage: 75,
      estimatedValue: _getDeviceValue(deviceName, 'display'),
      co2PreventedKg: 45.0,
      energySavedKwh: 150,
      recyclingInstructions: _getDisplayRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('large_electronics'),
      repairOptions: _getRepairOptions(deviceName),
      donationOptions: _getDonationOptions('display'),
      environmentalImpact: _calculateEnvironmentalImpact('display'),
      aiConfidence: 0.85,
    );
  }

  EWasteAnalysis _analyzeSmallAppliance(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.smallAppliance,
      materials: ['Steel', 'Plastic', 'Copper', 'Aluminum'],
      hazardousMaterials: ['Lead Solder', 'PVC Plastics'],
      recyclablePercentage: 70,
      estimatedValue: _getDeviceValue(deviceName, 'appliance'),
      co2PreventedKg: 8.0,
      energySavedKwh: 25,
      recyclingInstructions: _getApplianceRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('appliances'),
      repairOptions: _getRepairOptions(deviceName),
      donationOptions: _getDonationOptions('appliance'),
      environmentalImpact: _calculateEnvironmentalImpact('appliance'),
      aiConfidence: 0.78,
    );
  }

  EWasteAnalysis _analyzeGenericDevice(String deviceName) {
    return EWasteAnalysis(
      deviceName: _formatDeviceName(deviceName),
      category: EWasteCategory.other,
      materials: ['Mixed Materials', 'Plastic', 'Metal'],
      hazardousMaterials: ['Potentially Hazardous Components'],
      recyclablePercentage: 60,
      estimatedValue: 'Unknown',
      co2PreventedKg: 5.0,
      energySavedKwh: 15,
      recyclingInstructions: _getGenericRecyclingInstructions(),
      recyclingCenters: _findNearbyRecyclingCenters('general'),
      repairOptions: [],
      donationOptions: [],
      environmentalImpact: _calculateEnvironmentalImpact('generic'),
      aiConfidence: 0.65,
    );
  }

  String _formatDeviceName(String name) {
    return name.split(' ').map((word) => 
        word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }

  String _getDeviceValue(String deviceName, String category) {
    // AI-estimated value based on device type and condition
    switch (category) {
      case 'smartphone':
        if (deviceName.toLowerCase().contains('iphone')) return '\$150-400';
        if (deviceName.toLowerCase().contains('samsung')) return '\$100-350';
        return '\$50-200';
      case 'laptop':
        if (deviceName.toLowerCase().contains('macbook')) return '\$300-800';
        if (deviceName.toLowerCase().contains('thinkpad')) return '\$200-600';
        return '\$100-400';
      case 'tablet':
        if (deviceName.toLowerCase().contains('ipad')) return '\$150-500';
        return '\$75-250';
      case 'display':
        return '\$50-200';
      case 'appliance':
        return '\$10-50';
      default:
        return 'Unknown';
    }
  }

  List<String> _getSmartphoneRecyclingInstructions() {
    return [
      '1. Remove SIM card and memory card',
      '2. Sign out of all accounts (iCloud, Google, etc.)',
      '3. Perform factory reset to erase personal data',
      '4. Remove case and screen protector',
      '5. Take to certified e-waste recycling center',
      '6. Consider manufacturer trade-in programs',
    ];
  }

  List<String> _getLaptopRecyclingInstructions() {
    return [
      '1. Back up important data',
      '2. Sign out of all accounts and services',
      '3. Perform secure data wipe or remove hard drive',
      '4. Remove battery if possible',
      '5. Take to certified electronics recycling facility',
      '6. Check for manufacturer take-back programs',
    ];
  }

  List<String> _getTabletRecyclingInstructions() {
    return [
      '1. Back up important data to cloud',
      '2. Sign out of all accounts',
      '3. Perform factory reset',
      '4. Remove accessories and cases',
      '5. Take to electronics recycling center',
      '6. Consider trade-in value with retailers',
    ];
  }

  List<String> _getDisplayRecyclingInstructions() {
    return [
      '1. Disconnect all cables',
      '2. Clean screen and housing',
      '3. Check for manufacturer take-back programs',
      '4. Transport carefully to prevent screen damage',
      '5. Take to specialized display recycling facility',
      '6. Never dispose in regular trash due to hazardous materials',
    ];
  }

  List<String> _getApplianceRecyclingInstructions() {
    return [
      '1. Clean thoroughly and remove food residue',
      '2. Unplug and let cool completely',
      '3. Remove any detachable parts',
      '4. Check local recycling programs',
      '5. Take to small appliance recycling center',
      '6. Consider donation if still functional',
    ];
  }

  List<String> _getGenericRecyclingInstructions() {
    return [
      '1. Identify device components and materials',
      '2. Remove batteries if present',
      '3. Separate different material types',
      '4. Contact local recycling center for guidance',
      '5. Never dispose in regular household waste',
      '6. Research manufacturer recycling programs',
    ];
  }

  List<RecyclingCenter> _findNearbyRecyclingCenters(String type) {
    // Mock data - in real app, this would use location services
    return [
      RecyclingCenter(
        name: 'EcoTech Recycling Center',
        address: '123 Green Street, Eco City',
        distance: '2.3 km',
        acceptedTypes: ['Electronics', 'Batteries', 'Small Appliances'],
        hours: 'Mon-Fri: 9AM-6PM, Sat: 9AM-4PM',
        phone: '+1-555-ECO-TECH',
        specialServices: ['Data Destruction', 'Certificate of Recycling'],
      ),
      RecyclingCenter(
        name: 'Green Electronics Hub',
        address: '456 Recycle Avenue, Green Town',
        distance: '4.1 km',
        acceptedTypes: ['All Electronics', 'Large Appliances'],
        hours: 'Mon-Sat: 8AM-7PM',
        phone: '+1-555-GREEN-HUB',
        specialServices: ['Pickup Service', 'Refurbishment Program'],
      ),
      RecyclingCenter(
        name: 'City Waste Management',
        address: '789 Municipal Drive, City Center',
        distance: '5.8 km',
        acceptedTypes: ['General E-Waste', 'Hazardous Materials'],
        hours: 'Mon-Fri: 7AM-5PM',
        phone: '+1-555-CITY-WASTE',
        specialServices: ['Free Drop-off', 'Educational Tours'],
      ),
    ];
  }

  List<RepairOption> _getRepairOptions(String deviceName) {
    return [
      RepairOption(
        name: 'TechFix Pro',
        specialty: 'Smartphone & Tablet Repair',
        estimatedCost: '\$50-150',
        timeEstimate: '1-3 days',
        warranty: '90 days',
        rating: 4.8,
      ),
      RepairOption(
        name: 'Laptop Doctors',
        specialty: 'Computer & Laptop Repair',
        estimatedCost: '\$80-250',
        timeEstimate: '2-5 days',
        warranty: '6 months',
        rating: 4.6,
      ),
      RepairOption(
        name: 'DIY Repair Guides',
        specialty: 'Self-Service Repair',
        estimatedCost: '\$20-80 (parts only)',
        timeEstimate: '2-4 hours',
        warranty: 'N/A',
        rating: 4.2,
      ),
    ];
  }

  List<DonationOption> _getDonationOptions(String category) {
    return [
      DonationOption(
        organization: 'Schools Technology Program',
        description: 'Refurbish devices for educational use',
        requirements: 'Working condition, less than 5 years old',
        taxDeductible: true,
        pickupAvailable: true,
      ),
      DonationOption(
        organization: 'Senior Center Digital Access',
        description: 'Provide technology access to seniors',
        requirements: 'Basic functionality required',
        taxDeductible: true,
        pickupAvailable: false,
      ),
      DonationOption(
        organization: 'Environmental Action Network',
        description: 'Refurbish and redistribute to low-income families',
        requirements: 'Any condition accepted',
        taxDeductible: true,
        pickupAvailable: true,
      ),
    ];
  }

  EnvironmentalImpact _calculateEnvironmentalImpact(String category) {
    switch (category) {
      case 'smartphone':
        return EnvironmentalImpact(
          co2Saved: 12.5,
          energySaved: 45,
          waterSaved: 1200,
          materialsRecovered: ['22g Gold', '150g Copper', '5g Silver'],
          toxicMaterialsPrevented: ['Lead', 'Mercury traces'],
        );
      case 'laptop':
        return EnvironmentalImpact(
          co2Saved: 35.0,
          energySaved: 120,
          waterSaved: 3500,
          materialsRecovered: ['45g Gold', '400g Copper', '15g Silver'],
          toxicMaterialsPrevented: ['Lead', 'Mercury', 'Cadmium'],
        );
      default:
        return EnvironmentalImpact(
          co2Saved: 8.0,
          energySaved: 25,
          waterSaved: 800,
          materialsRecovered: ['Mixed metals', 'Plastics'],
          toxicMaterialsPrevented: ['Various heavy metals'],
        );
    }
  }
}

class EWasteAnalysis {
  final String deviceName;
  final EWasteCategory category;
  final List<String> materials;
  final List<String> hazardousMaterials;
  final int recyclablePercentage;
  final String estimatedValue;
  final double co2PreventedKg;
  final double energySavedKwh;
  final List<String> recyclingInstructions;
  final List<RecyclingCenter> recyclingCenters;
  final List<RepairOption> repairOptions;
  final List<DonationOption> donationOptions;
  final EnvironmentalImpact environmentalImpact;
  final double aiConfidence;

  EWasteAnalysis({
    required this.deviceName,
    required this.category,
    required this.materials,
    required this.hazardousMaterials,
    required this.recyclablePercentage,
    required this.estimatedValue,
    required this.co2PreventedKg,
    required this.energySavedKwh,
    required this.recyclingInstructions,
    required this.recyclingCenters,
    required this.repairOptions,
    required this.donationOptions,
    required this.environmentalImpact,
    required this.aiConfidence,
  });
}

class RecyclingCenter {
  final String name;
  final String address;
  final String distance;
  final List<String> acceptedTypes;
  final String hours;
  final String phone;
  final List<String> specialServices;

  RecyclingCenter({
    required this.name,
    required this.address,
    required this.distance,
    required this.acceptedTypes,
    required this.hours,
    required this.phone,
    required this.specialServices,
  });
}

class RepairOption {
  final String name;
  final String specialty;
  final String estimatedCost;
  final String timeEstimate;
  final String warranty;
  final double rating;

  RepairOption({
    required this.name,
    required this.specialty,
    required this.estimatedCost,
    required this.timeEstimate,
    required this.warranty,
    required this.rating,
  });
}

class DonationOption {
  final String organization;
  final String description;
  final String requirements;
  final bool taxDeductible;
  final bool pickupAvailable;

  DonationOption({
    required this.organization,
    required this.description,
    required this.requirements,
    required this.taxDeductible,
    required this.pickupAvailable,
  });
}

class EnvironmentalImpact {
  final double co2Saved;
  final double energySaved;
  final double waterSaved;
  final List<String> materialsRecovered;
  final List<String> toxicMaterialsPrevented;

  EnvironmentalImpact({
    required this.co2Saved,
    required this.energySaved,
    required this.waterSaved,
    required this.materialsRecovered,
    required this.toxicMaterialsPrevented,
  });
}

enum EWasteCategory {
  smartphone,
  laptop,
  tablet,
  display,
  smallAppliance,
  largeAppliance,
  battery,
  cable,
  other,
}
