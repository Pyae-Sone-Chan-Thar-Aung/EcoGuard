import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  Future<void> initialize() async {
    // Initialize performance monitoring
    debugPrint('PerformanceService initialized');
  }

  final Map<String, DateTime> _screenStartTimes = {};
  final Map<String, Duration> _screenDurations = {};
  final List<PerformanceMetric> _metrics = [];

  // Track screen navigation performance
  void startScreenTimer(String screenName) {
    _screenStartTimes[screenName] = DateTime.now();
  }

  void endScreenTimer(String screenName) {
    final startTime = _screenStartTimes[screenName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _screenDurations[screenName] = duration;
      
      // Log performance if screen takes too long to load
      if (duration.inMilliseconds > 1000) {
        debugPrint('Performance Warning: $screenName took ${duration.inMilliseconds}ms to load');
      }
      
      _screenStartTimes.remove(screenName);
    }
  }

  // Track memory usage
  void trackMemoryUsage(String context) {
    if (kDebugMode) {
      // In a real implementation, you would use platform channels
      // to get actual memory usage from native code
      _addMetric(PerformanceMetric(
        type: MetricType.memory,
        value: 0.0, // Placeholder
        context: context,
        timestamp: DateTime.now(),
      ));
    }
  }

  // Track network request performance
  void trackNetworkRequest(String endpoint, Duration duration, bool success) {
    _addMetric(PerformanceMetric(
      type: MetricType.network,
      value: duration.inMilliseconds.toDouble(),
      context: '$endpoint - ${success ? 'Success' : 'Failed'}',
      timestamp: DateTime.now(),
    ));
  }

  // Track database operation performance
  void trackDatabaseOperation(String operation, Duration duration) {
    _addMetric(PerformanceMetric(
      type: MetricType.database,
      value: duration.inMilliseconds.toDouble(),
      context: operation,
      timestamp: DateTime.now(),
    ));
  }

  // Track user interaction response time
  void trackUserInteraction(String interaction, Duration responseTime) {
    _addMetric(PerformanceMetric(
      type: MetricType.interaction,
      value: responseTime.inMilliseconds.toDouble(),
      context: interaction,
      timestamp: DateTime.now(),
    ));

    // Warn if interaction is too slow
    if (responseTime.inMilliseconds > 100) {
      debugPrint('Performance Warning: $interaction took ${responseTime.inMilliseconds}ms to respond');
    }
  }

  void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    
    // Keep only last 100 metrics to prevent memory issues
    if (_metrics.length > 100) {
      _metrics.removeAt(0);
    }
  }

  // Get performance summary
  PerformanceSummary getPerformanceSummary() {
    final networkMetrics = _metrics.where((m) => m.type == MetricType.network).toList();
    final databaseMetrics = _metrics.where((m) => m.type == MetricType.database).toList();
    final interactionMetrics = _metrics.where((m) => m.type == MetricType.interaction).toList();

    return PerformanceSummary(
      averageNetworkTime: _calculateAverage(networkMetrics),
      averageDatabaseTime: _calculateAverage(databaseMetrics),
      averageInteractionTime: _calculateAverage(interactionMetrics),
      screenLoadTimes: Map.from(_screenDurations),
      totalMetrics: _metrics.length,
    );
  }

  double _calculateAverage(List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) return 0.0;
    final sum = metrics.fold<double>(0.0, (sum, metric) => sum + metric.value);
    return sum / metrics.length;
  }

  // Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _screenDurations.clear();
    _screenStartTimes.clear();
  }

  // Optimize app performance
  void optimizePerformance() {
    // Force garbage collection
    if (kDebugMode) {
      debugPrint('Running performance optimization...');
    }
    
    // Clear old metrics
    if (_metrics.length > 50) {
      _metrics.removeRange(0, _metrics.length - 50);
    }
  }
}

class PerformanceMetric {
  final MetricType type;
  final double value;
  final String context;
  final DateTime timestamp;

  PerformanceMetric({
    required this.type,
    required this.value,
    required this.context,
    required this.timestamp,
  });
}

class PerformanceSummary {
  final double averageNetworkTime;
  final double averageDatabaseTime;
  final double averageInteractionTime;
  final Map<String, Duration> screenLoadTimes;
  final int totalMetrics;

  PerformanceSummary({
    required this.averageNetworkTime,
    required this.averageDatabaseTime,
    required this.averageInteractionTime,
    required this.screenLoadTimes,
    required this.totalMetrics,
  });
}

enum MetricType {
  memory,
  network,
  database,
  interaction,
  screen,
}
