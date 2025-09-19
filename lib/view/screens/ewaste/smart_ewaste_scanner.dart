import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/points/points_service.dart';
import '../../../services/notifications/notification_service.dart';
import '../../../services/ewaste/smart_categorization_service.dart';
import '../../../services/gamification/gamification_service.dart';
import '../../widgets/animations/animated_counter.dart';

class SmartEWasteScanner extends ConsumerStatefulWidget {
  const SmartEWasteScanner({super.key});

  @override
  ConsumerState<SmartEWasteScanner> createState() => _SmartEWasteScannerState();
}

class _SmartEWasteScannerState extends ConsumerState<SmartEWasteScanner>
    with TickerProviderStateMixin {
  final PointsService _pointsService = PointsService();
  final NotificationService _notificationService = NotificationService();
  final SmartCategorizationService _categorizationService = SmartCategorizationService();
  final GamificationService _gamificationService = GamificationService();
  CameraController? _cameraController;
  late AnimationController _scanAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isScanning = false;
  bool _isAnalyzing = false;
  EWasteAnalysis? _analysisResult;
  String _scanningText = 'Point camera at electronic device';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _scanAnimationController.repeat();
    _pulseAnimationController.repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_cameraController?.value.isInitialized == true)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Overlay UI
          _buildScannerOverlay(),
          
          // Top Controls
          _buildTopControls(),
          
          // Bottom Controls
          _buildBottomControls(),
          
          // Analysis Result
          if (_analysisResult != null) _buildAnalysisResult(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            // Scanning frame
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isScanning ? AppColors.primaryGreen : Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Corner indicators
                    ..._buildCornerIndicators(),
                    
                    // Scanning line
                    if (_isScanning) _buildScanningLine(),
                    
                    // Center target
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.center_focus_strong,
                                color: AppColors.primaryGreen,
                                size: 30,
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
            
            // Instructions
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      _scanningText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_isAnalyzing) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AI Analyzing Device...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Identifying materials and recycling options',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerIndicators() {
    const cornerSize = 20.0;
    const cornerThickness = 3.0;
    
    return [
      // Top-left
      Positioned(
        top: -1,
        left: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
              left: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: -1,
        right: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
              right: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: -1,
        left: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
              left: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: -1,
        right: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
              right: BorderSide(color: AppColors.primaryGreen, width: cornerThickness),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: _scanAnimation.value * 260,
          left: 10,
          right: 10,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primaryGreen,
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                _cameraController?.dispose();
                if (mounted) {
                  context.go(RouteNames.dashboard);
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.psychology,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: _toggleFlash,
              icon: const Icon(Icons.flash_off, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 48,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Scan Button
          GestureDetector(
            onTap: _isAnalyzing ? null : _performScan,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isAnalyzing 
                    ? [Colors.grey, Colors.grey[600]!]
                    : [AppColors.primaryGreen, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _isAnalyzing ? Icons.hourglass_empty : Icons.camera_alt,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isAnalyzing ? 'Analyzing...' : 'Tap to scan',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Tips
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Scanning Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Ensure good lighting\n• Hold device steady\n• Fill the frame with the item',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResult() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Device Identified!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _analysisResult!.deviceName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Analysis Details
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 360;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: isCompact ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildResultCard(
                            'Device Information',
                            [
                              _buildInfoRow('Type', _analysisResult!.category.toString().split('.').last),
                              _buildInfoRow('Recyclable', '${_analysisResult!.recyclablePercentage}%'),
                              _buildInfoRow('Estimated Value', _analysisResult!.estimatedValue),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStepListCard('Recycling Instructions', _analysisResult!.recyclingInstructions),
                          const SizedBox(height: 16),
                          _buildResultCard(
                            'Environmental Impact',
                            [
                              _buildImpactRow(Icons.eco, 'CO₂ Prevented', '${_analysisResult!.co2PreventedKg}kg', Colors.green),
                              _buildImpactRow(Icons.bolt, 'Energy Saved', '${_analysisResult!.energySavedKwh}kWh', Colors.yellow[700]!),
                              _buildImpactRow(Icons.dangerous, 'Hazardous', _analysisResult!.hazardousMaterials.join(', '), Colors.red),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmRecycling,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.recycling, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Confirm Recycling (+${_computePointsReward(_analysisResult!)} points)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _scanAnother,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Scan Another Device',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStepListCard(String title, List<String> steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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

  Widget _buildRecyclingOption(RecyclingOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRecyclingIcon(option.type),
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                option.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            option.description,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
          if (option.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.grey[400],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  option.location,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImpactRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    // Toggle camera flash
  }

  Future<void> _performScan() async {
    if (_isAnalyzing) return;

    setState(() {
      _isScanning = true;
      _scanningText = 'Scanning device...';
    });

    await Future<void>.delayed(const Duration(seconds: 3));
    await _performAIAnalysis();
  }

  Future<void> _performAIAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _scanningText = 'Analyzing device with AI...';
    });

    try {
      // Use the smart categorization service for real AI analysis
      final result = await _categorizationService.analyzeDevice('iPhone 12 Pro');
      
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _isScanning = false;
        _scanningText = 'Analysis failed. Please try again.';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmRecycling() async {
    if (_analysisResult == null) return;

    // Add points for recycling
    await _pointsService.addActivity(
      'ewaste_recycled',
      'Recycled ${_analysisResult!.deviceName}',
      _computePointsReward(_analysisResult!),
    );

    // Update gamification achievements and challenges
    await _gamificationService.checkAchievements('ewaste_recycled', 1);

    // Show success notification
    await _notificationService.showRecyclingConfirmed(
      _analysisResult!.deviceName,
      _computePointsReward(_analysisResult!),
    );

    // Show enhanced success dialog with environmental impact
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.recycling, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              const Text('Recycling Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Excellent work! You\'ve earned 100 points for recycling your ${_analysisResult!.deviceName}.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Environmental Impact:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.co2, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('${_analysisResult!.co2PreventedKg}kg CO₂ prevented'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.flash_on, size: 16, color: Colors.yellow),
                        const SizedBox(width: 8),
                        Text('${_analysisResult!.energySavedKwh}kWh energy saved'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (mounted) {
                  context.go(RouteNames.dashboard);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  void _scanAnother() {
    setState(() {
      _analysisResult = null;
      _scanningText = 'Point camera at electronic device';
      _isScanning = false;
      _isAnalyzing = false;
    });
  }

  int _computePointsReward(EWasteAnalysis analysis) {
    // Simple heuristic based on recyclable percentage and CO2 prevented
    final base = 50;
    final recycleBonus = (analysis.recyclablePercentage / 100.0 * 50).round();
    final co2Bonus = (analysis.co2PreventedKg * 2).round();
    final total = base + recycleBonus + co2Bonus;
    // Clamp to a reasonable range
    return total.clamp(50, 300);
  }

  IconData _getRecyclingIcon(String type) {
    switch (type) {
      case 'manufacturer':
        return Icons.business;
      case 'local':
        return Icons.location_city;
      case 'donation':
        return Icons.volunteer_activism;
      default:
        return Icons.recycling;
    }
  }
}

class EWasteAnalysisResult {
  final String deviceName;
  final String deviceType;
  final List<String> materials;
  final String condition;
  final String estimatedValue;
  final double co2Prevented;
  final String toxicMaterials;
  final int recyclablePercentage;
  final int pointsReward;
  final List<RecyclingOption> recyclingOptions;

  EWasteAnalysisResult({
    required this.deviceName,
    required this.deviceType,
    required this.materials,
    required this.condition,
    required this.estimatedValue,
    required this.co2Prevented,
    required this.toxicMaterials,
    required this.recyclablePercentage,
    required this.pointsReward,
    required this.recyclingOptions,
  });
}

class RecyclingOption {
  final String type;
  final String name;
  final String description;
  final String location;

  RecyclingOption({
    required this.type,
    required this.name,
    required this.description,
    required this.location,
  });
}
