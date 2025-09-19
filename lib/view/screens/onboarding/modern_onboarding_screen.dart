import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive_helper.dart';

class ModernOnboardingScreen extends ConsumerStatefulWidget {
  const ModernOnboardingScreen({super.key});

  @override
  ConsumerState<ModernOnboardingScreen> createState() => _ModernOnboardingScreenState();
}

class _ModernOnboardingScreenState extends ConsumerState<ModernOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _progressController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Save Our Planet',
      subtitle: 'Join millions in the fight against climate change',
      description: 'Track your environmental impact, plant trees, and make a real difference with AI-powered insights.',
      imagePath: 'assets/images/onboarding_1.png',
      primaryColor: AppColors.primaryGreen,
      secondaryColor: Colors.green[300]!,
      icon: Icons.public,
    ),
    OnboardingPage(
      title: 'Smart E-Waste Management',
      subtitle: 'Turn trash into treasure with AI',
      description: 'Scan electronics with our AI camera to get instant recycling guidance and earn rewards.',
      imagePath: 'assets/images/onboarding_2.png',
      primaryColor: Colors.blue[600]!,
      secondaryColor: Colors.blue[300]!,
      icon: Icons.camera_alt,
    ),
    OnboardingPage(
      title: 'Plant Trees, Earn Points',
      subtitle: 'Gamified environmental action',
      description: 'Every tree planted, every item recycled earns you points. Compete with friends and save the planet.',
      imagePath: 'assets/images/onboarding_3.png',
      primaryColor: Colors.orange[600]!,
      secondaryColor: Colors.orange[300]!,
      icon: Icons.park,
    ),
    OnboardingPage(
      title: 'Track Your Impact',
      subtitle: 'See your environmental footprint',
      description: 'Monitor your carbon footprint, track CO₂ savings, and get personalized recommendations.',
      imagePath: 'assets/images/onboarding_4.png',
      primaryColor: Colors.purple[600]!,
      secondaryColor: Colors.purple[300]!,
      icon: Icons.analytics,
    ),
  ];

  @override
  void initState() {
    super.initState();
    try {
      _pageController = PageController();
      
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      
      _progressController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    } catch (e) {
      debugPrint('Error initializing animation controllers: $e');
    }

    try {
      _fadeAnimations = List.generate(
        _pages.length,
        (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.2,
              (index * 0.2) + 0.6,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      );

      _slideAnimations = List.generate(
        _pages.length,
        (index) => Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.2,
              (index * 0.2) + 0.6,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      );

      _animationController.forward();
    } catch (e) {
      debugPrint('Error setting up animations: $e');
    }
  }

  @override
  void dispose() {
    try {
      _pageController.dispose();
      _animationController.dispose();
      _progressController.dispose();
    } catch (e) {
      debugPrint('Error disposing animation controllers: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _pages[_currentPage].primaryColor.withOpacity(0.1),
              _pages[_currentPage].secondaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Navigation
              _buildTopNavigation(),
              
              // Page Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    try {
                      return _buildPageContent(index, screenHeight, screenWidth);
                    } catch (e, st) {
                      debugPrint('Onboarding page build error: $e\n$st');
                      return const Center(child: Text('Loading...', style: TextStyle(color: Colors.black)));
                    }
                  },
                ),
              ),
              
              // Bottom Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryGreen],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'EcoGuard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          // Skip Button
          if (!_isLastPage)
            TextButton(
              onPressed: _skipToEnd,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index, double screenHeight, double screenWidth) {
    final page = _pages[index];
    
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Illustration
                SizedBox(
                  height: screenHeight * 0.4,
                  child: _buildIllustration(page),
                ),
                
                const SizedBox(height: 40),
                
                // Content
                Column(
                  children: [
                    Text(
                      page.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      page.subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: page.primaryColor,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(OnboardingPage page) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            page.primaryColor.withOpacity(0.1),
            page.secondaryColor.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          ...List.generate(3, (index) {
            return Positioned(
              child: Container(
                width: 200 - (index * 40),
                height: 200 - (index * 40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: page.primaryColor.withOpacity(0.1 - (index * 0.03)),
                ),
              ),
            );
          }),
          
          // Main icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [page.primaryColor, page.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: Colors.white,
            ),
          ),
          
          // Floating elements
          ..._buildFloatingElements(page),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingElements(OnboardingPage page) {
    return [
      Positioned(
        top: 50,
        right: 30,
        child: _buildFloatingIcon(Icons.eco, page.secondaryColor),
      ),
      Positioned(
        bottom: 60,
        left: 40,
        child: _buildFloatingIcon(Icons.recycling, page.primaryColor),
      ),
      Positioned(
        top: 80,
        left: 20,
        child: _buildFloatingIcon(Icons.energy_savings_leaf, page.secondaryColor),
      ),
      Positioned(
        bottom: 40,
        right: 50,
        child: _buildFloatingIcon(Icons.public, page.primaryColor),
      ),
    ];
  }

  Widget _buildFloatingIcon(IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 3),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (0.5 - (value - 0.5).abs())),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getResponsiveSpacing(context, 3)),
                width: _currentPage == index ? ResponsiveHelper.getResponsiveSpacing(context, 28) : ResponsiveHelper.getResponsiveSpacing(context, 6),
                height: ResponsiveHelper.getResponsiveSpacing(context, 6),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? _pages[_currentPage].primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveSpacing(context, 3)),
                ),
              );
            }),
          ),
          
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 20)),
          
          // Action Buttons
          Row(
            children: [
              // Previous Button
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPage,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _pages[_currentPage].primaryColor),
                      padding: ResponsiveHelper.getButtonPadding(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveSpacing(context, 12)),
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        color: _pages[_currentPage].primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              if (_currentPage > 0) const SizedBox(width: 16),
              
              // Next/Get Started Button
              Expanded(
                flex: _currentPage == 0 ? 1 : 2,
                child: ElevatedButton(
                  onPressed: _isLastPage ? _getStarted : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].primaryColor,
                      padding: ResponsiveHelper.getButtonPadding(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveSpacing(context, 12)),
                      ),
                      elevation: 0,
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == _pages.length - 1;
    });
    
    try {
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      debugPrint('Error with animation controller: $e');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      try {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        debugPrint('Error navigating to next page: $e');
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      // Guard against page view rebuilds during transition
      if (!mounted) return;
      try {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        debugPrint('Error navigating to previous page: $e');
      }
    }
  }

  void _skipToEnd() {
    // Safely jump to last page without triggering viewport assertion issues
    if (!mounted) return;
    try {
      _pageController.jumpToPage(_pages.length - 1);
      setState(() {
        _currentPage = _pages.length - 1;
        _isLastPage = true;
      });
    } catch (e) {
      debugPrint('Error skipping to end: $e');
    }
  }

  void _getStarted() {
    // Mark onboarding as completed and navigate to dashboard
    context.go(RouteNames.dashboard);
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}
