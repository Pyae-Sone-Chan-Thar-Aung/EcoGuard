import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StreakCounter extends StatelessWidget {
  final int streak;
  const StreakCounter({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          const Icon(Icons.local_fire_department, color: AppColors.warningOrange),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Daily Streak', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$streak days', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ]),
        ]),
      ),
    );
  }
}
