import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../state/providers/app_state_provider.dart';
import '../../../services/points/points_service.dart';
import '../../../services/notifications/notification_service.dart';
import '../../../services/ai/ai_recommendation_service.dart';
import '../../../services/gamification/gamification_service.dart';
import '../../widgets/responsive/responsive_layout.dart';
import '../../widgets/common/animated_button.dart';
import '../../widgets/animations/animated_counter.dart';

class ModernDashboardScreen extends ConsumerStatefulWidget {
  const ModernDashboardScreen({super.key});
  
  @override
  ConsumerState<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends ConsumerState<ModernDashboardScreen>
    with TickerProviderStateMixin {
  final PointsService _pointsService = PointsService();
  final AIRecommendationService _aiService = AIRecommendationService();
  final GamificationService _gamificationService = GamificationService();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadUserProfile();
      _pointsService.addListener(_onPointsUpdate);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _pointsService.removeListener(_onPointsUpdate);
    _animationController.dispose();
    super.dispose();
  }

  void _onPointsUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverToBoxAdapter(
                  child: _buildModernHeader(context, userProfile),
                ),
                
                // Environmental Impact Summary
                SliverToBoxAdapter(
                  child: _buildImpactSummary(context),
                ),
                
                SliverToBoxAdapter(
                  child: _buildGamificationSection(context),
                ),
                
                // AI Recommendations
                SliverToBoxAdapter(
                  child: _buildAIRecommendations(context),
                ),
                // Quick Actions
                SliverToBoxAdapter(
                  child: _buildQuickActions(context),
                ),
                SliverToBoxAdapter(
                  child: _buildRecentActivities(context),
                ),
                
                // Bottom Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(context),
      floatingActionButton: _buildSmartFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModernHeader(BuildContext context, dynamic userProfile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getGreeting()}!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile?.displayName ?? 'EcoWarrior',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildEcoPointsCard(),
        ],
      ),
    );
  }

  Widget _buildEcoPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eco Points',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange[300],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_pointsService.currentStreak} day streak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_pointsService.totalPoints}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep going! You\'re making a difference 🌱',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSummary(BuildContext context) {
    final stats = _pointsService.stats;
    
    return ResponsivePadding(
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Your Environmental Impact',
            mobileStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            tabletStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.responsiveValue(mobile: 12, tablet: 16)),
          AdaptiveGrid(
            spacing: context.responsiveValue(mobile: 8, tablet: 12),
            runSpacing: context.responsiveValue(mobile: 8, tablet: 12),
            minItemsPerRow: 2,
            maxItemsPerRow: 4,
            minItemWidth: 140,
            children: [
              _buildImpactCard(
                icon: Icons.park,
                title: 'Trees Planted',
                value: '${stats.treesPlanted}',
                subtitle: 'CO₂ absorbed',
                color: Colors.green,
              ),
              _buildImpactCard(
                icon: Icons.recycling,
                title: 'Items Recycled',
                value: '${stats.ewasteRecycled}',
                subtitle: 'Waste reduced',
                color: Colors.blue,
              ),
              _buildImpactCard(
                icon: Icons.co2,
                title: 'CO₂ Saved',
                value: '${stats.co2Saved.toStringAsFixed(1)}kg',
                subtitle: 'Carbon offset',
                color: Colors.orange,
              ),
              _buildImpactCard(
                icon: Icons.emoji_events,
                title: 'Achievements',
                value: '${stats.achievements}',
                subtitle: 'Unlocked',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    // Extract numeric value for animation
    final numericValue = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final suffix = value.replaceAll(RegExp(r'[0-9]'), '');
    
    return Container(
      padding: EdgeInsets.all(context.responsiveValue(mobile: 12, tablet: 16)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PulseAnimation(
            child: Icon(
              icon, 
              color: color, 
              size: context.responsiveValue(mobile: 20, tablet: 24),
            ),
          ),
          SizedBox(height: context.responsiveValue(mobile: 6, tablet: 8)),
          AnimatedCounter(
            value: numericValue,
            suffix: suffix,
            textStyle: TextStyle(
              fontSize: context.responsiveValue(mobile: 18, tablet: 20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          ResponsiveText(
            title,
            mobileStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            tabletStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          ResponsiveText(
            subtitle,
            mobileStyle: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
            ),
            tabletStyle: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationSection(BuildContext context) {
    return ResponsivePadding(
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Your Progress',
            mobileStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            tabletStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.responsiveValue(mobile: 12, tablet: 16)),
          
          // Level Progress Card
          Container(
            padding: EdgeInsets.all(context.responsiveValue(mobile: 16, tablet: 20)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          'Level ${_gamificationService.currentLevel}',
                          mobileStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          tabletStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ResponsiveText(
                          'Eco Champion',
                          mobileStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          tabletStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    PulseAnimation(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsiveValue(mobile: 12, tablet: 16)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveText(
                          'Progress to Level ${_gamificationService.currentLevel + 1}',
                          mobileStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          tabletStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        ResponsiveText(
                          '${_gamificationService.experiencePoints}/${_gamificationService.experienceToNextLevel + _gamificationService.experiencePoints} XP',
                          mobileStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          tabletStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedProgressBar(
                      progress: _gamificationService.levelProgress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      progressColor: Colors.white,
                      height: 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: context.responsiveValue(mobile: 12, tablet: 16)),
          
          // Active Challenges
          if (_gamificationService.activeChallengesOnly.isNotEmpty) ...[
            ResponsiveText(
              'Today\'s Challenges',
              mobileStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              tabletStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.responsiveValue(mobile: 8, tablet: 12)),
            ...(_gamificationService.activeChallengesOnly.take(2).map((challenge) => 
              SlideInAnimation(
                delay: Duration(milliseconds: 200 * _gamificationService.activeChallengesOnly.indexOf(challenge)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getChallengeIcon(challenge.category),
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ResponsiveText(
                              challenge.title,
                              mobileStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              tabletStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          ResponsiveText(
                            '${challenge.rewardPoints} pts',
                            mobileStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                            tabletStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedProgressBar(
                        progress: challenge.progress,
                        backgroundColor: Colors.grey[200],
                        progressColor: AppColors.primary,
                        height: 4,
                      ),
                      const SizedBox(height: 4),
                      ResponsiveText(
                        '${challenge.currentProgress}/${challenge.targetValue} completed',
                        mobileStyle: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        tabletStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  IconData _getChallengeIcon(String category) {
    switch (category) {
      case 'trees':
        return Icons.park;
      case 'ewaste':
        return Icons.recycling;
      case 'carbon':
        return Icons.co2;
      default:
        return Icons.eco;
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildActionCard(
                icon: Icons.add_location_alt,
                title: 'Plant Tree',
                subtitle: 'Add new tree',
                gradient: [Colors.green[400]!, Colors.green[600]!],
                onTap: () => context.go(RouteNames.treePlanting),
              ),
              _buildActionCard(
                icon: Icons.camera_alt,
                title: 'Scan E-Waste',
                subtitle: 'AI identification',
                gradient: [Colors.blue[400]!, Colors.blue[600]!],
                onTap: () => context.go(RouteNames.arScanner),
              ),
              _buildActionCard(
                icon: Icons.calculate,
                title: 'Carbon Calc',
                subtitle: 'Track footprint',
                gradient: [Colors.orange[400]!, Colors.orange[600]!],
                onTap: () => context.go(RouteNames.carbonCalculator),
              ),
              _buildActionCard(
                icon: Icons.school,
                title: 'Learn',
                subtitle: 'Eco education',
                gradient: [Colors.purple[400]!, Colors.purple[600]!],
                onTap: () => context.go(RouteNames.education),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendations(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'AI Recommendations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            icon: Icons.lightbulb,
            title: 'Reduce Energy Usage',
            description: 'Switch to LED bulbs to save 75% energy and reduce CO₂ by 12kg/year',
            impact: '+50 points',
            color: Colors.yellow[600]!,
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            icon: Icons.directions_bike,
            title: 'Bike to Work Challenge',
            description: 'Try biking twice this week to reduce 8kg CO₂ emissions',
            impact: '+100 points',
            color: Colors.green[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String description,
    required String impact,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    impact,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _buildRecentActivities(BuildContext context) {
    final activities = _pointsService.recentActivities.take(3).toList();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activities list
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activities.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.eco,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start your eco journey!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plant your first tree or scan e-waste to begin',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActivityColorByEnum(activity.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActivityIconByEnum(activity.type),
              color: _getActivityColorByEnum(activity.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${activity.points}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomAppBar(
        height: ResponsiveHelper.getBottomNavHeight(context) + 10,
        color: Colors.white,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true, () {}),
            _buildNavItem(Icons.eco, 'Impact', false, () => context.go(RouteNames.treePlanting)),
            _buildNavItem(Icons.recycling, 'eWaste', false, () => context.go(RouteNames.ewaste)),
            _buildNavItem(Icons.people, 'Community', false, () => context.go(RouteNames.community)),
            _buildNavItem(Icons.person, 'Profile', false, () => context.go(RouteNames.profile)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isTallScreen(context) ? 3 : 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[400],
              size: ResponsiveHelper.getResponsiveIconSize(context, 20),
            ),
            SizedBox(height: ResponsiveHelper.isTallScreen(context) ? 0.5 : 1),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 9),
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartFAB(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showSmartActions(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        mini: true,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showSmartActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: Icons.camera_alt,
                  label: 'Scan',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.arScanner);
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.add_location_alt,
                  label: 'Plant',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.treePlanting);
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.calculate,
                  label: 'Calculate',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.carbonCalculator);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'tree_planted':
        return Icons.park;
      case 'ewaste_recycled':
        return Icons.recycling;
      case 'carbon_calculated':
        return Icons.co2;
      default:
        return Icons.eco;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'tree_planted':
        return Colors.green;
      case 'ewaste_recycled':
        return Colors.blue;
      case 'carbon_calculated':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getActivityIconByEnum(ActivityType type) {
    switch (type) {
      case ActivityType.treePlanting:
        return Icons.park;
      case ActivityType.ewasteRecycling:
        return Icons.recycling;
      case ActivityType.carbonCalculation:
        return Icons.co2;
      case ActivityType.sortingGame:
        return Icons.videogame_asset;
    }
  }

  Color _getActivityColorByEnum(ActivityType type) {
    switch (type) {
      case ActivityType.treePlanting:
        return Colors.green;
      case ActivityType.ewasteRecycling:
        return Colors.blue;
      case ActivityType.carbonCalculation:
        return Colors.orange;
      case ActivityType.sortingGame:
        return AppColors.primary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
