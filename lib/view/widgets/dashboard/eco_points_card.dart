import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EcoPointsCard extends StatelessWidget {
  final int points;
  const EcoPointsCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Eco Points', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$points', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: (points % 100) / 100, backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen)),
          const SizedBox(height: 6),
          const Text('Next reward at +100 pts', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
    );
  }
}
