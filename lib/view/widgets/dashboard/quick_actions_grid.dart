import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QA(icon: Icons.forest, label: 'Plant Tree', route: RouteNames.treePlanting, color: AppColors.primaryGreen),
      _QA(icon: Icons.recycling, label: 'Recycle', route: RouteNames.ewaste, color: AppColors.lightGreen),
      _QA(icon: Icons.build, label: 'Repair Guide', route: RouteNames.repairAdvisor, color: AppColors.darkGreen),
      _QA(icon: Icons.calculate, label: 'Carbon', route: RouteNames.carbonCalculator, color: AppColors.leafGreen),
      _QA(icon: Icons.school, label: 'Eco Museum', route: RouteNames.ecoMuseum, color: AppColors.primaryGreen),
      _QA(icon: Icons.leaderboard, label: 'Community', route: RouteNames.leaderboard, color: AppColors.lightGreen),
    ];
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.4),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final a = actions[i];
        return InkWell(
          onTap: ()=> context.go(a.route),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                CircleAvatar(backgroundColor: a.color.withOpacity(0.15), child: Icon(a.icon, color: a.color)),
                const SizedBox(width: 12),
                Expanded(child: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w600))),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _QA {
  final IconData icon; final String label; final String route; final Color color;
  _QA({required this.icon, required this.label, required this.route, required this.color});
}
