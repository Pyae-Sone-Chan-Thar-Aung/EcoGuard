import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/common/bottom_nav.dart';
import 'ar_scanner_screen.dart';
import 'sorting_game_screen.dart';
import 'recycling_centers_map_screen.dart';
import 'ewaste_countries_animation.dart';

class EwasteHubScreen extends StatefulWidget {
  const EwasteHubScreen({super.key});

  @override
  State<EwasteHubScreen> createState() => _EwasteHubScreenState();
}

class _EwasteHubScreenState extends State<EwasteHubScreen> {
  final PointsService _pointsService = PointsService();
  
  @override
  void initState() {
    super.initState();
    _pointsService.addListener(_onPointsUpdate);
  }
  
  @override
  void dispose() {
    _pointsService.removeListener(_onPointsUpdate);
    super.dispose();
  }
  
  void _onPointsUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _pointsService.stats;
    final co2Saved = _pointsService.calculateCO2Saved();
    final ewastePoints = _pointsService.getActivitiesByType(ActivityType.ewasteRecycling)
        .fold(0, (sum, activity) => sum + activity.points);
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Waste Hub'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                child: Column(
                  children: [
                    const Icon(
                      Icons.recycling,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'E-Waste Management Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Scan, Sort, and Recycle Electronic Waste Responsibly',
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
            
            // Main features grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(context, 12),
              mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(context, 12),
              childAspectRatio: ResponsiveHelper.getGridAspectRatio(context),
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.analytics,
                  title: 'Device Analysis',
                  subtitle: 'Analyze your old devices',
                  onTap: () => context.push(RouteNames.deviceInput),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.camera_alt,
                  title: 'AR Scanner',
                  subtitle: 'Identify e-waste items',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ARScannerScreen(),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.games,
                  title: 'Sorting Game',
                  subtitle: 'Learn through play',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SortingGameScreen(),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.map,
                  title: 'Find Centers',
                  subtitle: 'Recycling locations',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecyclingCentersMapScreen(),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.info,
                  title: 'Guidelines',
                  subtitle: 'Disposal tips',
                  onTap: () => _showDisposalGuidelines(context),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.play_circle_filled,
                  title: 'Video Tutorials',
                  subtitle: 'Educational content',
                  onTap: () => _showEducationalVideos(context),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.public,
                  title: 'E Waste Countries',
                  subtitle: 'with animated visualization',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AsiaEWasteMap(),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Statistics card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your E-Waste Impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem('Items Recycled', '${stats.itemsRecycled}', Icons.recycling),
                        ),
                        Expanded(
                          child: _buildStatItem('Points Earned', '$ewastePoints', Icons.eco),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem('CO₂ Saved', '${co2Saved.toStringAsFixed(0)}kg', Icons.eco),
                        ),
                        Expanded(
                          child: _buildStatItem('Games Played', '${stats.gamesPlayed}', Icons.games),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick tips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem('Remove batteries before recycling devices'),
                    _buildTipItem('Wipe personal data from storage devices'),
                    _buildTipItem('Keep original cables and accessories together'),
                    _buildTipItem('Check local recycling center requirements'),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 2, // E-Waste tab
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.treePlanting);
              break;
            case 2:
              // Already on e-waste page
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

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: ResponsiveHelper.getCardPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context, 6)),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 6)),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 13),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 2)),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 10),
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
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

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb,
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisposalGuidelines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('E-Waste Disposal Guidelines'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Electronics (Phones, Laptops, etc.):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Remove all personal data\n• Remove SIM cards and memory cards\n• Include original cables if possible'),
              SizedBox(height: 16),
              Text(
                'Batteries:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Never dispose in regular trash\n• Take to specialized battery recycling centers\n• Keep terminals covered'),
              SizedBox(height: 16),
              Text(
                'Large Appliances:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Contact recycling center for pickup\n• Remove doors from old refrigerators\n• Drain all fluids safely'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showEducationalVideos(BuildContext context) {
    final educationalVideos = [
      {
        'title': 'The Growing Problem of E-Waste',
        'description': 'Understanding the global impact of electronic waste',
        'url': 'https://www.youtube.com/watch?v=dd_ZttK3PuM',
        'channel': 'TED-Ed',
        'category': 'Awareness',
      },
      {
        'title': 'How to Recycle Electronics Properly',
        'description': 'Step-by-step guide to responsible e-waste disposal',
        'url': 'https://www.youtube.com/watch?v=yDSp3qOPzQA',
        'channel': 'EPA',
        'category': 'Recycling',
      },
      {
        'title': 'The Right to Repair Movement',
        'description': 'Advocacy for consumer repair rights and sustainability',
        'url': 'https://www.youtube.com/watch?v=Npd_xDuNi9k',
        'channel': 'Vox',
        'category': 'Advocacy',
      },
      {
        'title': 'Circular Economy and Electronics',
        'description': 'Creating sustainable tech consumption cycles',
        'url': 'https://www.youtube.com/watch?v=zCRKvDyyHmI',
        'channel': 'Ellen MacArthur Foundation',
        'category': 'Sustainability',
      },
      {
        'title': 'DIY Electronics Repair for Beginners',
        'description': 'Essential repair skills to extend device life',
        'url': 'https://www.youtube.com/watch?v=_0B_CveFIlQ',
        'channel': 'EEVblog',
        'category': 'Repair',
      },
      {
        'title': 'E-Waste Mining: Urban Mining Explained',
        'description': 'How precious metals are recovered from e-waste',
        'url': 'https://www.youtube.com/watch?v=MqlZxmTqUHE',
        'channel': 'Seeker',
        'category': 'Recycling',
      },
      {
        'title': 'Planned Obsolescence: The Dark Side of Tech',
        'description': 'Why devices are designed to fail and what we can do',
        'url': 'https://www.youtube.com/watch?v=j5v8D-alAKE',
        'channel': 'DW Documentary',
        'category': 'Advocacy',
      },
      {
        'title': 'Green Computing: Sustainable Technology',
        'description': 'How to make technology choices that help the planet',
        'url': 'https://www.youtube.com/watch?v=U7VK0FJBX8I',
        'channel': 'TechQuickie',
        'category': 'Sustainability',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
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

              // Header with back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_circle_filled,
                        color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Educational Videos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Learn about e-waste, recycling, repair & advocacy',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Video categories info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Earn 3 eco-points for each video you watch!',
                        style: TextStyle(color: AppColors.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Videos list
              Flexible(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: educationalVideos.length,
                  itemBuilder: (context, index) {
                    final video = educationalVideos[index];
                    final categoryColor =
                    _getCategoryColor(video['category']!);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _launchYouTubeVideo(video['url']!);

                          // Award points for watching educational content
                          await _pointsService
                              .addCarbonCalculationActivity(0, 3);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Play button
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

                              // Video info
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
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          video['channel']!,
                                          style: const TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withOpacity(0.2),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            video['category']!,
                                            style: TextStyle(
                                              color: categoryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(Icons.launch,
                                  color: Colors.grey, size: 20),
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

  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'recycling':
        return AppColors.primaryGreen;
      case 'repair':
        return Colors.blue;
      case 'advocacy':
        return Colors.orange;
      case 'awareness':
        return Colors.red;
      case 'sustainability':
        return AppColors.darkGreen;
      default:
        return Colors.grey;
    }
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
              duration: Duration(seconds: 2),
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
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
