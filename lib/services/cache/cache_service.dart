import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  late Box<Map> _cacheBox;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _cacheBox = await Hive.openBox<Map>('app_cache');
      _isInitialized = true;
      
      // Clean expired cache on startup
      await _cleanExpiredCache();
    } catch (e) {
      debugPrint('Error initializing CacheService: $e');
    }
  }

  // Cache data with expiration
  Future<void> cacheData(String key, dynamic data, {Duration? expiration}) async {
    if (!_isInitialized) await initialize();
    
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    
    await _cacheBox.put(key, cacheItem);
  }

  // Get cached data
  T? getCachedData<T>(String key) {
    if (!_isInitialized) return null;
    
    final cacheItem = _cacheBox.get(key);
    if (cacheItem == null) return null;
    
    // Check if cache has expired
    final timestamp = cacheItem['timestamp'] as int?;
    final expiration = cacheItem['expiration'] as int?;
    
    if (timestamp != null && expiration != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expirationTime = cacheTime.add(Duration(milliseconds: expiration));
      
      if (DateTime.now().isAfter(expirationTime)) {
        // Cache expired, remove it
        _cacheBox.delete(key);
        return null;
      }
    }
    
    return cacheItem['data'] as T?;
  }

  // Check if data is cached and valid
  bool isCached(String key) {
    return getCachedData(key) != null;
  }

  // Remove specific cache entry
  Future<void> removeCache(String key) async {
    if (!_isInitialized) return;
    await _cacheBox.delete(key);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    if (!_isInitialized) return;
    await _cacheBox.clear();
  }

  // Clean expired cache entries
  Future<void> _cleanExpiredCache() async {
    if (!_isInitialized) return;
    
    final keysToRemove = <String>[];
    final now = DateTime.now();
    
    for (final key in _cacheBox.keys) {
      final cacheItem = _cacheBox.get(key);
      if (cacheItem == null) continue;
      
      final timestamp = cacheItem['timestamp'] as int?;
      final expiration = cacheItem['expiration'] as int?;
      
      if (timestamp != null && expiration != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final expirationTime = cacheTime.add(Duration(milliseconds: expiration));
        
        if (now.isAfter(expirationTime)) {
          keysToRemove.add(key.toString());
        }
      }
    }
    
    // Remove expired entries
    for (final key in keysToRemove) {
      await _cacheBox.delete(key);
    }
    
    if (keysToRemove.isNotEmpty) {
      debugPrint('Cleaned ${keysToRemove.length} expired cache entries');
    }
  }

  // Get cache statistics
  CacheStatistics getCacheStatistics() {
    if (!_isInitialized) {
      return CacheStatistics(totalEntries: 0, totalSize: 0, hitRate: 0.0);
    }
    
    return CacheStatistics(
      totalEntries: _cacheBox.length,
      totalSize: _calculateCacheSize(),
      hitRate: 0.0, // Would need hit/miss tracking for accurate calculation
    );
  }

  int _calculateCacheSize() {
    // Rough estimation of cache size
    return _cacheBox.length * 1024; // Assume 1KB per entry on average
  }

  // Preload commonly used data
  Future<void> preloadCommonData() async {
    // This would typically load frequently accessed data
    // For now, it's a placeholder for future implementation
    debugPrint('Preloading common data...');
  }
}

class CacheStatistics {
  final int totalEntries;
  final int totalSize;
  final double hitRate;

  CacheStatistics({
    required this.totalEntries,
    required this.totalSize,
    required this.hitRate,
  });
}
