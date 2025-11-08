import 'package:flutter/foundation.dart';
import '../error/app_logger.dart';

/// Performance utilities for optimizing app performance
class PerformanceUtils {
  PerformanceUtils._();

  static final AppLogger _logger = AppLogger('PerformanceUtils');

  /// Debounce function execution
  /// Useful for search inputs, scroll events, etc.
  static void Function() debounce(
    void Function() callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    DateTime? lastCallTime;
    
    return () {
      final DateTime now = DateTime.now();
      
      if (lastCallTime == null ||
          now.difference(lastCallTime!) > delay) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// Throttle function execution
  /// Ensures function is called at most once per duration
  static void Function() throttle(
    void Function() callback, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    DateTime? lastCallTime;
    
    return () {
      final DateTime now = DateTime.now();
      
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// Measure execution time of a function
  static Future<T> measureExecutionTime<T>({
    required String operationName,
    required Future<T> Function() operation,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    
    try {
      final T result = await operation();
      stopwatch.stop();
      
      _logger.debug(
        '$operationName completed in ${stopwatch.elapsedMilliseconds}ms',
      );
      
      return result;
    } catch (e) {
      stopwatch.stop();
      _logger.warning(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
      );
      rethrow;
    }
  }

  /// Measure execution time (synchronous)
  static T measureExecutionTimeSync<T>({
    required String operationName,
    required T Function() operation,
  }) {
    final Stopwatch stopwatch = Stopwatch()..start();
    
    try {
      final T result = operation();
      stopwatch.stop();
      
      _logger.debug(
        '$operationName completed in ${stopwatch.elapsedMilliseconds}ms',
      );
      
      return result;
    } catch (e) {
      stopwatch.stop();
      _logger.warning(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
      );
      rethrow;
    }
  }

  /// Batch async operations
  /// Processes items in batches to avoid overwhelming the system
  static Future<List<R>> batchProcess<T, R>({
    required List<T> items,
    required Future<R> Function(T item) processor,
    int batchSize = 10,
    Duration? delayBetweenBatches,
  }) async {
    final List<R> results = <R>[];
    
    for (int i = 0; i < items.length; i += batchSize) {
      final int end = (i + batchSize < items.length)
          ? i + batchSize
          : items.length;
      
      final List<T> batch = items.sublist(i, end);
      
      _logger.debug(
        'Processing batch ${i ~/ batchSize + 1} of ${(items.length / batchSize).ceil()}',
      );
      
      final List<R> batchResults = await Future.wait(
        batch.map((T item) => processor(item)),
      );
      
      results.addAll(batchResults);
      
      if (delayBetweenBatches != null && end < items.length) {
        await Future<void>.delayed(delayBetweenBatches);
      }
    }
    
    return results;
  }

  /// Check if running in release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Check if running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if running in profile mode
  static bool get isProfileMode => kProfileMode;

  /// Log performance warning if operation takes too long
  static void warnIfSlow({
    required String operationName,
    required int elapsedMs,
    int thresholdMs = 1000,
  }) {
    if (elapsedMs > thresholdMs) {
      _logger.warning(
        'Performance warning: $operationName took ${elapsedMs}ms (threshold: ${thresholdMs}ms)',
      );
    }
  }
}

/// Mixin for adding performance tracking to classes
mixin PerformanceTracking {
  final AppLogger _perfLogger = const AppLogger('Performance');

  /// Track method execution time
  Future<T> trackPerformance<T>({
    required String methodName,
    required Future<T> Function() method,
  }) async {
    return PerformanceUtils.measureExecutionTime<T>(
      operationName: '${runtimeType.toString()}.$methodName',
      operation: method,
    );
  }

  /// Track synchronous method execution time
  T trackPerformanceSync<T>({
    required String methodName,
    required T Function() method,
  }) {
    return PerformanceUtils.measureExecutionTimeSync<T>(
      operationName: '${runtimeType.toString()}.$methodName',
      operation: method,
    );
  }
}
