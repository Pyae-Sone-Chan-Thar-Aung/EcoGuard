import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'app_logger.dart';

/// Global error handler for the application
/// 
/// This class provides centralized error handling for both
/// Flutter framework errors and uncaught asynchronous errors.
class ErrorHandler {
  ErrorHandler._();

  static final AppLogger _logger = AppLogger('ErrorHandler');

  /// Initialize the global error handler
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.error(
        'Flutter Error',
        error: details.exception,
        stackTrace: details.stack,
      );

      // In production, you might want to send this to a crash reporting service
      if (AppConfig.enableCrashReporting) {
        _sendToCrashReporting(details.exception, details.stack);
      }

      // Show error in debug mode
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _logger.error(
        'Uncaught Async Error',
        error: error,
        stackTrace: stack,
      );

      if (AppConfig.enableCrashReporting) {
        _sendToCrashReporting(error, stack);
      }

      return true;
    };
  }

  /// Handle API errors
  static String handleApiError(dynamic error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your internet connection.';
    }

    if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please try again.';
    }

    if (error.toString().contains('401') || 
        error.toString().contains('Unauthorized')) {
      return 'Session expired. Please log in again.';
    }

    if (error.toString().contains('403') || 
        error.toString().contains('Forbidden')) {
      return 'Access denied. You do not have permission.';
    }

    if (error.toString().contains('404') || 
        error.toString().contains('Not Found')) {
      return 'Resource not found.';
    }

    if (error.toString().contains('500') || 
        error.toString().contains('Internal Server Error')) {
      return 'Server error. Please try again later.';
    }

    _logger.error('API Error', error: error);
    return 'An unexpected error occurred. Please try again.';
  }

  /// Show error dialog to user
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Send error to crash reporting service
  /// This is a placeholder - implement with your preferred service
  /// (e.g., Firebase Crashlytics, Sentry, etc.)
  static void _sendToCrashReporting(Object error, StackTrace? stack) {
    // TODO: Implement crash reporting integration
    // Example: FirebaseCrashlytics.instance.recordError(error, stack);
    _logger.debug('Would send to crash reporting: $error');
  }

  /// Log and handle error with retry logic
  static Future<T?> withErrorHandling<T>({
    required Future<T> Function() operation,
    String operationName = 'Operation',
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        attempts++;
        return await operation();
      } catch (e, stackTrace) {
        _logger.error(
          '$operationName failed (attempt $attempts/$maxRetries)',
          error: e,
          stackTrace: stackTrace,
        );

        // Check if we should retry
        final bool retry = shouldRetry?.call(e) ?? true;
        
        if (attempts >= maxRetries || !retry) {
          rethrow;
        }

        // Wait before retrying
        await Future<void>.delayed(retryDelay * attempts);
      }
    }

    return null;
  }
}
