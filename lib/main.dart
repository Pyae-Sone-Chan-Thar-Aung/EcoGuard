import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/notifications/notification_service.dart';
import 'services/points/points_service.dart';
import 'services/performance/performance_service.dart';
import 'services/cache/cache_service.dart';
import 'services/ai/ai_recommendation_service.dart';
import 'services/gamification/gamification_service.dart';
import 'services/ewaste/smart_categorization_service.dart';


// ⚡ Supabase config
const supabaseUrl = 'https://tlawzidglriindqvhayo.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsYXd6aWRnbHJpaW5kcXZoYXlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNTEyNzEsImV4cCI6MjA3MjgyNzI3MX0.cxPwfzO-xsQQY7-Ofp8sAp49Rp6NsuPs5Hz1XXEidag';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  // Initialize services
  await NotificationService().initialize();
  await PointsService().initialize();
  await PerformanceService().initialize();
  await CacheService().initialize();
  await AIRecommendationService().initialize();
  await GamificationService().initialize();

  runApp(const ProviderScope(child: EcoGuardApp()));
}

class EcoGuardApp extends ConsumerWidget {
  const EcoGuardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'EcoGuard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,

      // ✅ Basic localization support (without missing AppLocalizations)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
        Locale('zh', 'CN'), // Simplified Chinese
        Locale('zh', 'TW'), // Traditional Chinese
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('pt'), // Portuguese
        Locale('ru'), // Russian
        Locale('hi'), // Hindi
        Locale('ar'), // Arabic
        Locale('it'), // Italian
      ],
    );
  }
}
