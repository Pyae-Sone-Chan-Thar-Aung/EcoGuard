import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/e_waste/device_analysis.dart';
import '../../../services/e_waste/device_analysis_service.dart';

class DeviceInputScreen extends ConsumerStatefulWidget {
  const DeviceInputScreen({super.key});

  @override
  ConsumerState<DeviceInputScreen> createState() => _DeviceInputScreenState();
}

class _DeviceInputScreenState extends ConsumerState<DeviceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _ageController = TextEditingController();
  
  DeviceType _selectedDeviceType = DeviceType.smartphone;
  DeviceCondition _selectedCondition = DeviceCondition.good;
  final List<String> _selectedIssues = [];
  bool _isAnalyzing = false;

  final List<String> _availableIssues = [
    'Screen cracked',
    'Battery issues',
    'Charging problems',
    'Water damage',
    'Overheating',
    'Slow performance',
    'Storage full',
    'Camera not working',
    'Speaker issues',
    'Microphone problems',
    'Connectivity issues',
    'Physical damage',
    'Software problems',
    'Motherboard issues',
    'Display issues',
    'Button not working',
  ];

  @override
  void dispose() {
    _deviceNameController.dispose();
    _brandController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Analyze Your Device',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isAnalyzing ? _buildAnalyzingView() : _buildInputForm(),
    );
  }

  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing your device...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Calculating environmental impact and sustainability options',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildDeviceDetailsCard(),
            const SizedBox(height: 20),
            _buildDeviceConditionCard(),
            const SizedBox(height: 20),
            _buildIssuesCard(),
            const SizedBox(height: 30),
            _buildAnalyzeButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
            Icons.devices,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'E-Waste Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get personalized recommendations for your old electronic devices',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceDetailsCard() {
    return _buildCard(
      title: 'Device Information',
      icon: Icons.info_outline,
      child: Column(
        children: [
          TextFormField(
            controller: _deviceNameController,
            decoration: const InputDecoration(
              labelText: 'Device Name',
              hintText: 'e.g., iPhone 12, MacBook Pro',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter device name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: 'Brand',
              hintText: 'e.g., Apple, Samsung, Dell',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter brand name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<DeviceType>(
            value: _selectedDeviceType,
            decoration: const InputDecoration(
              labelText: 'Device Type',
              border: OutlineInputBorder(),
            ),
            items: DeviceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_getDeviceTypeDisplayName(type)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDeviceType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Age (years)',
              hintText: 'How old is your device?',
              border: OutlineInputBorder(),
              suffixText: 'years',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter device age';
              }
              final age = int.tryParse(value);
              if (age == null || age < 0 || age > 50) {
                return 'Please enter a valid age (0-50 years)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceConditionCard() {
    return _buildCard(
      title: 'Device Condition',
      icon: Icons.assessment,
      child: Column(
        children: DeviceCondition.values.map((condition) {
          return RadioListTile<DeviceCondition>(
            title: Text(_getConditionDisplayName(condition)),
            subtitle: Text(_getConditionDescription(condition)),
            value: condition,
            groupValue: _selectedCondition,
            onChanged: (value) {
              setState(() {
                _selectedCondition = value!;
              });
            },
            activeColor: AppColors.primary,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIssuesCard() {
    return _buildCard(
      title: 'Issues (Select all that apply)',
      icon: Icons.bug_report,
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableIssues.map((issue) {
              final isSelected = _selectedIssues.contains(issue);
              return FilterChip(
                label: Text(issue),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedIssues.add(issue);
                    } else {
                      _selectedIssues.remove(issue);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          if (_selectedIssues.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No issues? That\'s great! Your device might have good resale value.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

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

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _analyzeDevice,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics),
            const SizedBox(width: 8),
            const Text(
              'Analyze My Device',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeDevice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final analysis = await DeviceAnalysisService().analyzeDevice(
        deviceName: _deviceNameController.text,
        brand: _brandController.text,
        deviceType: _selectedDeviceType,
        ageInYears: int.parse(_ageController.text),
        condition: _selectedCondition,
        issues: _selectedIssues,
      );

      if (mounted) {
        context.push('/device-analysis-results', extra: analysis);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing device: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  String _getDeviceTypeDisplayName(DeviceType type) {
    switch (type) {
      case DeviceType.smartphone: return 'Smartphone';
      case DeviceType.tablet: return 'Tablet';
      case DeviceType.laptop: return 'Laptop';
      case DeviceType.desktop: return 'Desktop Computer';
      case DeviceType.television: return 'Television';
      case DeviceType.printer: return 'Printer';
      case DeviceType.camera: return 'Camera';
      case DeviceType.gamingConsole: return 'Gaming Console';
      case DeviceType.smartwatch: return 'Smartwatch';
      case DeviceType.headphones: return 'Headphones';
      case DeviceType.router: return 'Router';
      case DeviceType.keyboard: return 'Keyboard';
      case DeviceType.mouse: return 'Mouse';
      case DeviceType.monitor: return 'Monitor';
      case DeviceType.speaker: return 'Speaker';
      case DeviceType.other: return 'Other';
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

  String _getConditionDescription(DeviceCondition condition) {
    switch (condition) {
      case DeviceCondition.excellent: return 'Like new, minimal wear';
      case DeviceCondition.good: return 'Some wear but fully functional';
      case DeviceCondition.fair: return 'Noticeable wear, may have minor issues';
      case DeviceCondition.poor: return 'Significant wear, major issues';
      case DeviceCondition.broken: return 'Not working, needs major repair';
      case DeviceCondition.partsOnly: return 'Only useful for parts/components';
    }
  }
}
