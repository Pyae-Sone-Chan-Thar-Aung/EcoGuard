import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive_helper.dart';

class EcoBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap; // ✅ make onTap optional

  const EcoBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      selectedFontSize: ResponsiveHelper.isTallScreen(context) ? 9 : 10,
      unselectedFontSize: ResponsiveHelper.isTallScreen(context) ? 8 : 9,
      iconSize: ResponsiveHelper.getResponsiveIconSize(context, 20),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Trees'),
        BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'E-Waste'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Carbon'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Community'),
      ],
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          // default behavior
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
        }
      },
    );
  }
}

