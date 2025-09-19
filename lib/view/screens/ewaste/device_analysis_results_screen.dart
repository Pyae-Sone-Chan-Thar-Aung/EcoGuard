import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/e_waste/device_analysis.dart';

class DeviceAnalysisResultsScreen extends ConsumerStatefulWidget {
  final DeviceAnalysis analysis;
  
  const DeviceAnalysisResultsScreen({
    super.key,
    required this.analysis,
  });

  @override
  ConsumerState<DeviceAnalysisResultsScreen> createState() =>
      _DeviceAnalysisResultsScreenState();
}

class _DeviceAnalysisResultsScreenState
    extends ConsumerState<DeviceAnalysisResultsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Analysis Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.white,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.assessment)),
            Tab(text: 'Options', icon: Icon(Icons.eco)),
            Tab(text: 'Handicrafts', icon: Icon(Icons.build_circle)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSustainabilityOptionsTab(),
          _buildHandicraftsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeviceSummaryCard(),
          const SizedBox(height: 16),
          _buildEnvironmentalImpactCard(),
          const SizedBox(height: 16),
          _buildValueEstimateCard(),
          const SizedBox(height: 16),
          _buildQuickActionsCard(),
        ],
      ),
    );
  }

  Widget _buildDeviceSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getDeviceIcon(widget.analysis.deviceType),
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            widget.analysis.deviceName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.analysis.brand} • ${widget.analysis.ageInYears} years old',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getConditionDisplayName(widget.analysis.condition),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalImpactCard() {
    final impact = widget.analysis.environmentalImpact;
    return _buildCard(
      title: 'Environmental Impact',
      icon: Icons.eco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImpactMetric(
            'Carbon Footprint',
            '${impact.carbonFootprintKg.toStringAsFixed(1)} kg CO₂',
            Icons.cloud,
            _getImpactColor(impact.impactLevel),
          ),
          const SizedBox(height: 12),
          _buildImpactMetric(
            'Energy Savings Potential',
            '${impact.energySavedKwh.toStringAsFixed(1)} kWh',
            Icons.flash_on,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildImpactMetric(
            'Recyclable Components',
            '${(impact.recycleValuePercentage * 100).toStringAsFixed(0)}%',
            Icons.recycling,
            Colors.green,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getImpactColor(impact.impactLevel).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getImpactIcon(impact.impactLevel),
                  color: _getImpactColor(impact.impactLevel),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact.description,
                    style: TextStyle(
                      color: _getImpactColor(impact.impactLevel),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (impact.harmfulMaterials.isNotEmpty) ...[
            const Text(
              'Harmful Materials Present:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: impact.harmfulMaterials.map((material) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    material,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildValueEstimateCard() {
    return _buildCard(
      title: 'Estimated Value',
      icon: Icons.attach_money,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Market Value',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$${widget.analysis.estimatedValue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (widget.analysis.estimatedValue > 50)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Good news! Your device still has significant value. Consider selling or donating.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    final topOptions = widget.analysis.sustainabilityOptions.take(3).toList();
    
    return _buildCard(
      title: 'Recommended Actions',
      icon: Icons.recommend,
      child: Column(
        children: topOptions.map((option) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getSustainabilityIcon(option.type),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                option.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                option.description,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${option.environmentalBenefit.toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Text(
                    'eco benefit',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              onTap: () => _tabController.animateTo(1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSustainabilityOptionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.analysis.sustainabilityOptions.length,
      itemBuilder: (context, index) {
        final option = widget.analysis.sustainabilityOptions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildSustainabilityOptionCard(option),
        );
      },
    );
  }

  Widget _buildSustainabilityOptionCard(SustainabilityOption option) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getSustainabilityIcon(option.type),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildBenefitIndicator(
                    'Environmental',
                    option.environmentalBenefit,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBenefitIndicator(
                    'Economic',
                    option.economicBenefit,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip('Difficulty: ${option.difficulty}', Icons.speed),
                const SizedBox(width: 8),
                _buildInfoChip('Time: ${option.estimatedTime}', Icons.schedule),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Steps to Follow'),
              leading: const Icon(Icons.list),
              children: option.steps.asMap().entries.map((entry) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
            if (option.locations.isNotEmpty) ...[
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text('Locations/Resources'),
                leading: const Icon(Icons.location_on),
                children: option.locations.map((location) {
                  return ListTile(
                    leading: const Icon(Icons.place, size: 16),
                    title: Text(
                      location,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHandicraftsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.analysis.handicraftSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = widget.analysis.handicraftSuggestions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildHandicraftCard(suggestion),
        );
      },
    );
  }

  Widget _buildHandicraftCard(HandicraftSuggestion suggestion) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(suggestion.category),
                  _getCategoryColor(suggestion.category).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(suggestion.category),
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suggestion.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip('${suggestion.difficulty}', Icons.speed),
                    const SizedBox(width: 8),
                    _buildInfoChip(suggestion.estimatedTime, Icons.schedule),
                    const SizedBox(width: 8),
                    if (suggestion.isEcoFriendly)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco, size: 14, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Eco-Friendly',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ExpansionTile(
                  title: const Text('Materials & Tools'),
                  leading: const Icon(Icons.build),
                  children: [
                    if (suggestion.materials.isNotEmpty) ...[
                      const ListTile(
                        title: Text(
                          'Materials:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...suggestion.materials.map((material) => ListTile(
                        leading: const Icon(Icons.circle, size: 8),
                        title: Text(material, style: const TextStyle(fontSize: 14)),
                        dense: true,
                      )),
                    ],
                    if (suggestion.tools.isNotEmpty) ...[
                      const ListTile(
                        title: Text(
                          'Tools:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...suggestion.tools.map((tool) => ListTile(
                        leading: const Icon(Icons.build_circle, size: 16),
                        title: Text(tool, style: const TextStyle(fontSize: 14)),
                        dense: true,
                      )),
                    ],
                  ],
                ),
                ExpansionTile(
                  title: const Text('Step-by-Step Instructions'),
                  leading: const Icon(Icons.list_alt),
                  children: suggestion.steps.asMap().entries.map((entry) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: _getCategoryColor(suggestion.category),
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
                if (suggestion.benefits.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Benefits:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: suggestion.benefits.map((benefit) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          benefit,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets and methods
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildImpactMetric(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Icon and color helper methods
  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.smartphone: return Icons.phone_android;
      case DeviceType.tablet: return Icons.tablet;
      case DeviceType.laptop: return Icons.laptop;
      case DeviceType.desktop: return Icons.computer;
      case DeviceType.television: return Icons.tv;
      case DeviceType.printer: return Icons.print;
      case DeviceType.camera: return Icons.camera_alt;
      case DeviceType.gamingConsole: return Icons.games;
      case DeviceType.smartwatch: return Icons.watch;
      case DeviceType.headphones: return Icons.headphones;
      case DeviceType.router: return Icons.router;
      case DeviceType.keyboard: return Icons.keyboard;
      case DeviceType.mouse: return Icons.mouse;
      case DeviceType.monitor: return Icons.monitor;
      case DeviceType.speaker: return Icons.speaker;
      case DeviceType.other: return Icons.devices_other;
    }
  }

  IconData _getSustainabilityIcon(SustainabilityType type) {
    switch (type) {
      case SustainabilityType.repair: return Icons.build;
      case SustainabilityType.refurbish: return Icons.refresh;
      case SustainabilityType.donate: return Icons.volunteer_activism;
      case SustainabilityType.sell: return Icons.sell;
      case SustainabilityType.recycle: return Icons.recycling;
      case SustainabilityType.upcycle: return Icons.autorenew;
      case SustainabilityType.repurpose: return Icons.transform;
    }
  }

  IconData _getCategoryIcon(HandicraftCategory category) {
    switch (category) {
      case HandicraftCategory.decoration: return Icons.palette;
      case HandicraftCategory.furniture: return Icons.chair;
      case HandicraftCategory.storage: return Icons.storage;
      case HandicraftCategory.lighting: return Icons.lightbulb;
      case HandicraftCategory.garden: return Icons.local_florist;
      case HandicraftCategory.art: return Icons.brush;
      case HandicraftCategory.functional: return Icons.handyman;
      case HandicraftCategory.educational: return Icons.school;
    }
  }

  Color _getCategoryColor(HandicraftCategory category) {
    switch (category) {
      case HandicraftCategory.decoration: return Colors.purple;
      case HandicraftCategory.furniture: return Colors.brown;
      case HandicraftCategory.storage: return Colors.blue;
      case HandicraftCategory.lighting: return Colors.orange;
      case HandicraftCategory.garden: return Colors.green;
      case HandicraftCategory.art: return Colors.red;
      case HandicraftCategory.functional: return Colors.indigo;
      case HandicraftCategory.educational: return Colors.teal;
    }
  }

  Color _getImpactColor(String impactLevel) {
    switch (impactLevel) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getImpactIcon(String impactLevel) {
    switch (impactLevel) {
      case 'High': return Icons.warning;
      case 'Medium': return Icons.info;
      case 'Low': return Icons.check_circle;
      default: return Icons.help;
    }
  }

  String _getConditionDisplayName(DeviceCondition condition) {
    switch (condition) {
      case DeviceCondition.excellent: return 'Excellent';
      case DeviceCondition.good: return 'Good';
      case DeviceCondition.fair: return 'Fair';
      case DeviceCondition.poor: return 'Poor';
      case DeviceCondition.broken: return 'Broken';
      case DeviceCondition.partsOnly: return 'Parts Only';
    }
  }

  void _shareResults() {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
      ),
    );
  }
}
