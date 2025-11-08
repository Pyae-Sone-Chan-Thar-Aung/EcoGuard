import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Application logger with different log levels
/// 
/// Provides structured logging with support for different log levels
/// and optional filtering based on environment.
class AppLogger {
  final String name;

  const AppLogger(this.name);

  /// Log a debug message
  /// Only shown in development mode
  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (AppConfig.enableDebugLogging) {
      _log(
        level: LogLevel.debug,
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log an info message
  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (AppConfig.enableVerboseLogging) {
      _log(
        level: LogLevel.info,
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a warning message
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.warning,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Internal log method
  void _log({
    required LogLevel level,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String timestamp = DateTime.now().toIso8601String();
    final String levelString = level.toString().split('.').last.toUpperCase();
    final String logMessage = '[$timestamp] [$levelString] [$name] $message';

    if (kDebugMode) {
      // Use developer.log for better integration with dev tools
      developer.log(
        message,
        time: DateTime.now(),
        level: _getLevelValue(level),
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
    }

    // Also print for console visibility
    if (AppConfig.enableVerboseLogging) {
      // ignore: avoid_print
      print(logMessage);
      
      if (error != null) {
        // ignore: avoid_print
        print('Error: $error');
      }
      
      if (stackTrace != null) {
        // ignore: avoid_print
        print('StackTrace: $stackTrace');
      }
    }
  }

  int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
}
