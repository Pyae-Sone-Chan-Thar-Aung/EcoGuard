import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/common/bottom_nav.dart';

class RepairAdvisorScreen extends StatefulWidget {
  const RepairAdvisorScreen({super.key});

  @override
  State<RepairAdvisorScreen> createState() => _RepairAdvisorScreenState();
}

class _RepairAdvisorScreenState extends State<RepairAdvisorScreen> {
  final PointsService _pointsService = PointsService();
  String? _selectedDevice;
  String? _selectedIssue;
  String? _recommendation;
  bool _isAnalyzing = false;

  final Map<String, List<String>> _deviceIssues = {
    'Smartphone': [
      'Cracked screen',
      'Battery drains quickly',
      'Charging port not working',
      'Camera not focusing',
      'Speaker not working',
      'Water damage',
    ],
    'Laptop': [
      'Slow performance',
      'Screen flickering',
      'Overheating',
      'Keyboard not responding',
      'Hard drive clicking',
      'Wi-Fi not connecting',
    ],
    'Tablet': [
      'Touch screen unresponsive',
      'Won\'t charge',
      'Apps crashing',
      'Screen has dead pixels',
      'Volume buttons stuck',
    ],
    'Desktop Computer': [
      'Won\'t turn on',
      'Blue screen errors',
      'Noisy fan',
      'USB ports not working',
      'Monitor no signal',
    ],
    'Gaming Console': [
      'Disc won\'t read',
      'Controller not connecting',
      'Overheating during games',
      'Network connection issues',
      'Audio cutting out',
    ],
  };

  final Map<String, Map<String, dynamic>> _repairAdvice = {
    'Smartphone_Cracked screen': {
      'recommendation': 'REPAIR',
      'cost': '\$50-150',
      'difficulty': 'Professional',
      'environmental_impact': 'High',
      'description': 'Screen replacement is cost-effective and extends device life by 2-3 years.',
      'co2_saved': '15kg',
      'repair_shops': ['TechFix Mobile', 'QuickScreen Repair', 'Phone Clinic'],
      'diy_possible': false,
      'tutorial_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Phone Screen Repair Tutorial
      'tutorial_title': 'How to Replace a Smartphone Screen',
    },
    'Smartphone_Battery drains quickly': {
      'recommendation': 'REPAIR',
      'cost': '\$30-80',
      'difficulty': 'Moderate',
      'environmental_impact': 'High',
      'description': 'Battery replacement can restore 90%+ of original performance.',
      'co2_saved': '12kg',
      'repair_shops': ['Battery Plus', 'Mobile Medics', 'PowerUp Repairs'],
      'diy_possible': true,
      'tutorial_url': 'https://www.youtube.com/watch?v=8hJ1HDcMowk', // Phone Battery Replacement
      'tutorial_title': 'DIY Phone Battery Replacement Guide',
    },
    'Laptop_Slow performance': {
      'recommendation': 'REPAIR',
      'cost': '\$50-200',
      'difficulty': 'Easy',
      'environmental_impact': 'Very High',
      'description': 'RAM upgrade and SSD replacement can make old laptop perform like new.',
      'co2_saved': '45kg',
      'repair_shops': ['ComputerCare', 'Laptop Specialists', 'Tech Solutions'],
      'diy_possible': true,
      'tutorial_url': 'https://www.youtube.com/watch?v=gZfm81YKueQ', // Laptop RAM & SSD Upgrade
      'tutorial_title': 'Upgrade Your Laptop RAM and SSD - Complete Guide',
    },
    'Laptop_Screen flickering': {
      'recommendation': 'EVALUATE',
      'cost': '\$150-400',
      'difficulty': 'Professional',
      'environmental_impact': 'Medium',
      'description': 'Could be cable or screen issue. Diagnosis needed before deciding.',
      'co2_saved': '35kg',
      'repair_shops': ['Display Doctors', 'Screen Savers', 'Visual Tech'],
      'diy_possible': false,
      'tutorial_url': 'https://www.youtube.com/watch?v=FQX0t5N8_qY', // Laptop Screen Diagnosis
      'tutorial_title': 'How to Diagnose Laptop Screen Problems',
    },
    'Gaming Console_Disc won\'t read': {
      'recommendation': 'REPAIR',
      'cost': '\$40-120',
      'difficulty': 'Professional',
      'environmental_impact': 'High',
      'description': 'Usually a laser or motor issue. Much cheaper than replacement.',
      'co2_saved': '25kg',
      'repair_shops': ['GameFix Pro', 'Console Clinic', 'RetroRepair'],
      'diy_possible': false,
      'tutorial_url': 'https://www.youtube.com/watch?v=QhJBCWPzKNE', // Gaming Console Repair
      'tutorial_title': 'Gaming Console Disc Drive Repair Guide',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Advisor'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.lightGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.build,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Should You Repair or Replace?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get personalized advice to extend device life and reduce e-waste',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Device Selection
            const Text(
              'Select your device type:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _deviceIssues.keys.map((device) {
                final isSelected = _selectedDevice == device;
                return FilterChip(
                  label: Text(device),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDevice = selected ? device : null;
                      _selectedIssue = null;
                      _recommendation = null;
                    });
                  },
                  selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  backgroundColor: Colors.grey[100],
                );
              }).toList(),
            ),
            
            if (_selectedDevice != null) ...[
              const SizedBox(height: 24),
              
              // Issue Selection
              Text(
                'What\'s the problem with your $_selectedDevice?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Column(
                children: _deviceIssues[_selectedDevice]!.map((issue) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<String>(
                      title: Text(issue),
                      value: issue,
                      groupValue: _selectedIssue,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (value) {
                        setState(() {
                          _selectedIssue = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              
              if (_selectedIssue != null) ...[
                const SizedBox(height: 24),
                
                // Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeRepair,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(
                      _isAnalyzing ? 'Analyzing...' : 'Get Repair Advice',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
            
            // Results
            if (_recommendation != null) ...[
              const SizedBox(height: 24),
              _buildRecommendationCard(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.treePlanting);
              break;
            case 2:
              context.go(RouteNames.ewaste);
              break;
            case 3:
              context.go(RouteNames.carbonCalculator);
              break;
            case 4:
              context.go(RouteNames.leaderboard);
              break;
          }
        },
      ),
    );
  }

  Future<void> _analyzeRepair() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));

    final key = '${_selectedDevice}_$_selectedIssue';
    final advice = _repairAdvice[key];

    setState(() {
      _recommendation = advice?['recommendation'] ?? 'EVALUATE';
      _isAnalyzing = false;
    });

    // Award points for using the advisor
    await _pointsService.addCarbonCalculationActivity(0, 5);
  }

  Widget _buildRecommendationCard() {
    final key = '${_selectedDevice}_$_selectedIssue';
    final advice = _repairAdvice[key];
    
    if (advice == null) return const SizedBox();

    final isRepair = advice['recommendation'] == 'REPAIR';
    final isEvaluate = advice['recommendation'] == 'EVALUATE';
    
    Color cardColor = isRepair 
        ? AppColors.primaryGreen 
        : isEvaluate 
            ? Colors.orange 
            : Colors.red;

    String title = isRepair 
        ? '✅ RECOMMENDED: REPAIR' 
        : isEvaluate 
            ? '🔍 EVALUATION NEEDED' 
            : '❌ CONSIDER REPLACEMENT';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              cardColor.withOpacity(0.1),
              cardColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: cardColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              advice['description'],
              style: const TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 16),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Est. Cost',
                    advice['cost'],
                    Icons.attach_money,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'CO₂ Saved',
                    advice['co2_saved'],
                    Icons.eco,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Difficulty',
                    advice['difficulty'],
                    Icons.build,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Impact',
                    advice['environmental_impact'],
                    Icons.public,
                  ),
                ),
              ],
            ),
            
            if (advice['diy_possible'] == true) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.handyman, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DIY repair possible! Check our tutorial section.',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Buttons
            if (isRepair) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRepairShops(advice['repair_shops']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.store),
                      label: const Text('Find Repair Shops'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _watchTutorial(advice),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.play_circle),
                      label: const Text('Watch Tutorial'),
                    ),
                  ),
                ],
              ),
            ] else if (isEvaluate) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showRepairShops(advice['repair_shops']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Get Professional Diagnosis'),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to recycling centers
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RepairAdvisorScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.recycling),
                  label: const Text('Find Recycling Centers'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRepairShops(List<String> shops) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const Text(
                'Recommended Repair Shops',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.store,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        title: Text(shops[index]),
                        subtitle: const Text('Certified repair specialist'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Open shop details or call
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _watchTutorial(Map<String, dynamic> advice) async {
    final tutorialUrl = advice['tutorial_url'] as String?;
    final tutorialTitle = advice['tutorial_title'] as String?;
    
    if (tutorialUrl == null) {
      // Show general e-waste education videos if no specific tutorial
      _showEducationalVideos();
      return;
    }
    
    // Show tutorial selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Educational Videos'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Specific repair tutorial
            if (tutorialTitle != null) ...[
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.build, color: Colors.red),
                ),
                title: Text(tutorialTitle),
                subtitle: const Text('Specific repair guide'),
                onTap: () {
                  Navigator.of(context).pop();
                  _launchYouTubeVideo(tutorialUrl);
                },
              ),
              const Divider(),
            ],


            // General e-waste education
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: AppColors.primaryGreen),
              ),
              title: const Text('E-Waste Education'),
              subtitle: const Text('Learn about recycling & sustainability'),
              onTap: () {
                Navigator.of(context).pop();
                _showEducationalVideos();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _showEducationalVideos() {
    final educationalVideos = [
      {
        'title': 'The Growing Problem of E-Waste',
        'description': 'Understanding the global impact of electronic waste',
        'url': 'https://www.youtube.com/watch?v=dd_ZttK3PuM',
        'channel': 'TED-Ed',
      },
      {
        'title': 'How to Recycle Electronics Properly',
        'description': 'Step-by-step guide to responsible e-waste disposal',
        'url': 'https://www.youtube.com/watch?v=yDSp3qOPzQA',
        'channel': 'EPA',
      },
      {
        'title': 'Repair vs Replace: Making Sustainable Choices',
        'description': 'Environmental and economic benefits of repairing',
        'url': 'https://www.youtube.com/watch?v=kqqWkKPzGT8',
        'channel': 'Sustainability Illustrated',
      },
      {
        'title': 'The Right to Repair Movement',
        'description': 'Advocacy for consumer repair rights',
        'url': 'https://www.youtube.com/watch?v=Npd_xDuNi9k',
        'channel': 'Vox',
      },
      {
        'title': 'DIY Electronics Repair Basics',
        'description': 'Essential tools and techniques for beginners',
        'url': 'https://www.youtube.com/watch?v=_0B_CveFIlQ',
        'channel': 'EEVblog',
      },
      {
        'title': 'Circular Economy and Electronics',
        'description': 'Creating sustainable tech consumption cycles',
        'url': 'https://www.youtube.com/watch?v=zCRKvDyyHmI',
        'channel': 'Ellen MacArthur Foundation',
      },
    ];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              Row(
                children: [
                  const Icon(Icons.play_circle_filled, color: Colors.red, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Educational Videos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Learn about e-waste, recycling, repair advocacy, and sustainability',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: educationalVideos.length,
                  itemBuilder: (context, index) {
                    final video = educationalVideos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _launchYouTubeVideo(video['url']!);
                          
                          // Award points for watching educational content
                          _pointsService.addCarbonCalculationActivity(0, 3);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                              
                              const SizedBox(width: 16),
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video['title']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      video['description']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      video['channel']!,
                                      style: const TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const Icon(
                                Icons.launch,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _launchYouTubeVideo(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎥 Opening educational video... +3 eco points!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
      } else {
        throw Exception('Could not launch video');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
