import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/error/error_handler.dart';
import 'core/error/app_logger.dart';
import 'services/notifications/notification_service.dart';
import 'services/points/points_service.dart';
import 'services/performance/performance_service.dart';
import 'services/cache/cache_service.dart';
import 'services/ai/ai_recommendation_service.dart';
import 'services/gamification/gamification_service.dart';

/// Application entry point
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global error handler
  ErrorHandler.initialize();

  final AppLogger logger = AppLogger('Main');

  try {
    logger.info('Initializing EcoGuard application...');

    // Initialize Hive for local storage
    await _initializeHive(logger);

    // Initialize Supabase
    await _initializeSupabase(logger);

    // Initialize services
    await _initializeServices(logger);

    logger.info('Application initialization complete');

    // Run the app
    runApp(const ProviderScope(child: EcoGuardApp()));
  } catch (e, stackTrace) {
    logger.error(
      'Failed to initialize application',
      error: e,
      stackTrace: stackTrace,
    );
    
    // Show error to user
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to start EcoGuard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${e.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Initialize Hive local storage
Future<void> _initializeHive(AppLogger logger) async {
  try {
    logger.debug('Initializing Hive...');
    await Hive.initFlutter();
    logger.info('Hive initialized successfully');
  } catch (e, stackTrace) {
    logger.error(
      'Failed to initialize Hive',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Initialize Supabase
Future<void> _initializeSupabase(AppLogger logger) async {
  try {
    logger.debug('Initializing Supabase...');
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    logger.info('Supabase initialized successfully');
  } catch (e, stackTrace) {
    logger.error(
      'Failed to initialize Supabase',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Initialize all application services
Future<void> _initializeServices(AppLogger logger) async {
  final List<Future<void>> serviceInits = <Future<void>>[
    _initializeService(
      'NotificationService',
      () => NotificationService().initialize(),
      logger,
    ),
    _initializeService(
      'PointsService',
      () => PointsService().initialize(),
      logger,
    ),
    _initializeService(
      'PerformanceService',
      () => PerformanceService().initialize(),
      logger,
    ),
    _initializeService(
      'CacheService',
      () => CacheService().initialize(),
      logger,
    ),
    _initializeService(
      'AIRecommendationService',
      () => AIRecommendationService().initialize(),
      logger,
    ),
    _initializeService(
      'GamificationService',
      () => GamificationService().initialize(),
      logger,
    ),
  ];

  await Future.wait(serviceInits);
  logger.info('All services initialized successfully');
}

/// Initialize a single service with error handling
Future<void> _initializeService(
  String serviceName,
  Future<void> Function() initFunction,
  AppLogger logger,
) async {
  try {
    logger.debug('Initializing $serviceName...');
    await initFunction();
    logger.info('$serviceName initialized successfully');
  } catch (e, stackTrace) {
    logger.warning(
      'Failed to initialize $serviceName (continuing anyway)',
      error: e,
      stackTrace: stackTrace,
    );
    // Don't rethrow - allow app to continue with degraded functionality
  }
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

      // Localization support
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
