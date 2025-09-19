import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

  @override void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => context.go(RouteNames.welcome));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            CircleAvatar(radius: 60, backgroundColor: Colors.white, child: Icon(Icons.eco, size: 56, color: AppColors.primaryGreen)),
            SizedBox(height: 24),
            Text('EcoGuard', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text('Protecting Our Planet Together', style: TextStyle(fontSize: 16, color: Colors.white70)),
          ]),
        ),
      ),
    );
  }
}
