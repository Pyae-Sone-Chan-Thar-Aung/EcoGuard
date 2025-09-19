import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageCtrl = PageController();
  int _index = 0;

  final _pages = const [
    _WelcomePage(icon: Icons.eco, title: 'Track Eco Points', text: 'Earn points for planet-friendly actions.'),
    _WelcomePage(icon: Icons.forest, title: 'Plant Trees', text: 'Build your personal forest and offset emissions.'),
    _WelcomePage(icon: Icons.recycling, title: 'Recycle E-Waste', text: 'Dispose e-waste responsibly and learn.'),
  ];

  @override void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: _pageCtrl,
              onPageChanged: (i) => setState(() => _index = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _pages[i],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Row(children: List.generate(_pages.length, (i) =>
                Container(margin: const EdgeInsets.all(4), width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _index ? AppColors.primaryGreen : Colors.grey[400],
                  )))),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _index == _pages.length - 1
                    ? context.go(RouteNames.dashboard)
                    : _pageCtrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut),
                child: Text(_index == _pages.length - 1 ? 'Get Started' : 'Next'),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final IconData icon; final String title; final String text;
  const _WelcomePage({required this.icon, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 72, color: AppColors.primaryGreen),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
        ]),
      ),
    );
  }
}
