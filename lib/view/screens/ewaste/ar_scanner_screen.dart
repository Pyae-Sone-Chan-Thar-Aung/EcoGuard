import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../../core/theme/app_colors.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/common/bottom_nav.dart';

class ARScannerScreen extends StatefulWidget {
  const ARScannerScreen({super.key});

  @override
  State<ARScannerScreen> createState() => _ARScannerScreenState();
}

class _ARScannerScreenState extends State<ARScannerScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isScanning = false;
  String? _detectedItem;
  final Random _random = Random();
  final PointsService _pointsService = PointsService();

  // Mock e-waste items that can be "detected"
  final List<Map<String, dynamic>> _ewasteItems = [
    {
      'name': 'Smartphone',
      'category': 'Mobile Devices',
      'recyclingTip': 'Remove battery and SIM card before recycling',
      'points': 15,
      'materials': ['Plastic', 'Metal', 'Glass', 'Rare Earth Elements']
    },
    {
      'name': 'Laptop Computer',
      'category': 'Computers',
      'recyclingTip': 'Wipe hard drive and remove battery',
      'points': 25,
      'materials': ['Plastic', 'Metal', 'Glass', 'Lithium', 'Gold']
    },
    {
      'name': 'LED Television',
      'category': 'Displays',
      'recyclingTip': 'Handle carefully due to fragile screen',
      'points': 30,
      'materials': ['Plastic', 'Metal', 'Glass', 'LED Components']
    },
    {
      'name': 'Wireless Headphones',
      'category': 'Audio Devices',
      'recyclingTip': 'Separate charging case from headphones',
      'points': 10,
      'materials': ['Plastic', 'Metal', 'Lithium Battery']
    },
    {
      'name': 'Gaming Console',
      'category': 'Gaming',
      'recyclingTip': 'Remove all cables and controllers',
      'points': 35,
      'materials': ['Plastic', 'Metal', 'Circuit Boards']
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras.first,
          ResolutionPreset.high,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _detectedItem = null;
    });

    // Simulate scanning process
    await Future.delayed(const Duration(seconds: 2));

    if (_random.nextBool()) {
      // Simulate successful detection
      final item = _ewasteItems[_random.nextInt(_ewasteItems.length)];
      setState(() {
        _detectedItem = item['name'];
        _isScanning = false;
      });
      _showDetectionDialog(item);
    } else {
      // Simulate no detection
      setState(() {
        _isScanning = false;
      });
      _showNoDetectionDialog();
    }
  }

  void _showDetectionDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            const Text('Item Detected!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Category: ${item['category']}'),
            const SizedBox(height: 8),
            Text('Recycling Tip: ${item['recyclingTip']}'),
            const SizedBox(height: 8),
            Text('Materials: ${item['materials'].join(', ')}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.eco, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    '+${item['points']} Eco Points',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Scan Again'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Record the recycling activity in points service
              await _pointsService.addEwasteRecyclingActivity(
                item['name'],
                item['points'],
              );
              
              context.pop(); // Return to e-waste hub
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showNoDetectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('No Item Detected'),
          ],
        ),
        content: const Text(
          'Try pointing the camera at an electronic device. Make sure the item is well-lit and clearly visible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AR E-Waste Scanner'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isInitialized
          ? Stack(
              children: [
                // Camera preview
                CameraPreview(_controller!),
                
                // Overlay UI
                Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    
                    // Instructions
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Point your camera at an electronic device',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          
                          // Scan button
                          ElevatedButton.icon(
                            onPressed: _isScanning ? null : _startScanning,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            icon: _isScanning
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.camera_alt),
                            label: Text(
                              _isScanning ? 'Scanning...' : 'Scan Item',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Scanning overlay
                if (_isScanning)
                  Container(
                    color: Colors.green.withOpacity(0.3),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 4,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Analyzing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 16),
                  Text(
                    'Initializing Camera...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
