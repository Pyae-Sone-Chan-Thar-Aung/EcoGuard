import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../../core/theme/app_colors.dart';
import '../../../services/points/points_service.dart';

class SortingGameScreen extends StatefulWidget {
  const SortingGameScreen({super.key});

  @override
  State<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen>
    with TickerProviderStateMixin {
  int _currentRound = 1;
  int _score = 0;
  int _correctAnswers = 0;
  bool _gameComplete = false;
  bool _showFeedback = false;
  String _feedbackMessage = '';
  bool _isCorrect = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;
  final PointsService _pointsService = PointsService();

  final List<Map<String, dynamic>> _gameItems = [
    {
      'name': '📱 Smartphone',
      'category': 'Electronics',
      'description': 'Contains precious metals and batteries',
    },
    {
      'name': '🔋 Battery',
      'category': 'Batteries',
      'description': 'Hazardous chemicals require special handling',
    },
    {
      'name': '💻 Laptop',
      'category': 'Electronics',
      'description': 'Complex device with multiple recyclable components',
    },
    {
      'name': '📺 TV',
      'category': 'Large Appliances',
      'description': 'Contains glass and electronic components',
    },
    {
      'name': '🔌 Cable',
      'category': 'Accessories',
      'description': 'Copper wiring can be recycled',
    },
    {
      'name': '🎮 Gaming Console',
      'category': 'Electronics',
      'description': 'Contains circuit boards and plastic components',
    },
    {
      'name': '🖱️ Computer Mouse',
      'category': 'Accessories',
      'description': 'Small electronic accessory',
    },
    {
      'name': '🔊 Speaker',
      'category': 'Electronics',
      'description': 'Contains magnets and electronic components',
    },
    {
      'name': '⌚ Smart Watch',
      'category': 'Electronics',
      'description': 'Contains battery and precious metals',
    },
    {
      'name': '🔦 Flashlight',
      'category': 'Batteries',
      'description': 'Usually contains batteries that need special disposal',
    },
  ];

  final List<String> _categories = [
    'Electronics',
    'Batteries',
    'Large Appliances',
    'Accessories',
  ];

  late Map<String, dynamic> _currentItem;
  List<String> _shuffledCategories = [];

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _startNewRound();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _startNewRound() {
    if (_currentRound > 10) {
      _completeGame();
      return;
    }

    final random = Random();
    _currentItem = _gameItems[random.nextInt(_gameItems.length)];
    _shuffledCategories = List.from(_categories)..shuffle();
    
    setState(() {
      _showFeedback = false;
    });
  }

  void _selectCategory(String selectedCategory) {
    final correctCategory = _currentItem['category'];
    final isCorrect = selectedCategory == correctCategory;
    
    setState(() {
      _isCorrect = isCorrect;
      _showFeedback = true;
      
      if (isCorrect) {
        _score += 10;
        _correctAnswers++;
        _feedbackMessage = 'Correct! 🎉';
      } else {
        _feedbackMessage = 'Incorrect. The correct category is: $correctCategory';
      }
    });

    _feedbackController.forward().then((_) {
      _feedbackController.reset();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _currentRound++;
        });
        _startNewRound();
      });
    });
  }

  void _completeGame() async {
    // Record the game completion in points service
    await _pointsService.addSortingGameActivity(
      _score,
      _correctAnswers,
      10, // Total questions
    );
    
    setState(() {
      _gameComplete = true;
    });
  }

  void _restartGame() {
    setState(() {
      _currentRound = 1;
      _score = 0;
      _correctAnswers = 0;
      _gameComplete = false;
      _showFeedback = false;
    });
    _startNewRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Waste Sorting Game'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Score: $_score',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _gameComplete ? _buildGameComplete() : _buildGamePlay(),
    );
  }

  Widget _buildGamePlay() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Round $_currentRound/10',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Correct: $_correctAnswers',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentRound - 1) / 10,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
          ),
          const SizedBox(height: 32),

          // Item to categorize
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.1),
                    AppColors.lightGreen.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _currentItem['name'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentItem['description'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Category options
          const Text(
            'Which category does this belong to?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemCount: _shuffledCategories.length,
              itemBuilder: (context, index) {
                final category = _shuffledCategories[index];
                return _buildCategoryButton(category);
              },
            ),
          ),

          // Feedback overlay
          if (_showFeedback)
            AnimatedBuilder(
              animation: _feedbackAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _feedbackAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isCorrect
                          ? AppColors.primaryGreen
                          : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _feedbackMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: _showFeedback ? null : () => _selectCategory(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGameComplete() {
    final percentage = (_correctAnswers / 10 * 100).round();
    String message;
    IconData icon;
    Color color;

    if (percentage >= 80) {
      message = 'Excellent! You\'re an E-Waste sorting expert! 🏆';
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (percentage >= 60) {
      message = 'Good job! You\'re learning fast! 👍';
      icon = Icons.thumb_up;
      color = AppColors.primaryGreen;
    } else {
      message = 'Keep practicing to become an expert! 💪';
      icon = Icons.school;
      color = Colors.blue;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: color,
            ),
            const SizedBox(height: 24),
            const Text(
              'Game Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Final Score:', style: TextStyle(fontSize: 18)),
                        Text(
                          '$_score points',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Accuracy:', style: TextStyle(fontSize: 18)),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Correct Answers:', style: TextStyle(fontSize: 18)),
                        Text(
                          '$_correctAnswers/10',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _restartGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Play Again'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Hub'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
