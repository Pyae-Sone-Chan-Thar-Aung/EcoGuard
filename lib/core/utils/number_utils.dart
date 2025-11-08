import 'dart:math' as math;

/// Number utility functions for the application
class NumberUtils {
  NumberUtils._();

  /// Format number with commas
  static String formatWithCommas(num number) {
    final String numberString = number.toString();
    final List<String> parts = numberString.split('.');
    
    String integerPart = parts[0];
    final String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    
    final StringBuffer result = StringBuffer();
    int count = 0;
    
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result.write(',');
      }
      result.write(integerPart[i]);
      count++;
    }
    
    return result.toString().split('').reversed.join() + decimalPart;
  }

  /// Format number as percentage
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  /// Format number as currency
  static String formatCurrency(
    double amount, {
    String symbol = '\$',
    int decimals = 2,
  }) {
    final String formatted = amount.abs().toStringAsFixed(decimals);
    final String withCommas = formatWithCommas(double.parse(formatted));
    final String sign = amount < 0 ? '-' : '';
    
    return '$sign$symbol$withCommas';
  }

  /// Abbreviate large numbers (e.g., 1000 -> 1K, 1000000 -> 1M)
  static String abbreviate(num number, {int decimals = 1}) {
    if (number.abs() < 1000) {
      return number.toString();
    }
    
    const List<String> suffixes = <String>['', 'K', 'M', 'B', 'T'];
    int suffixIndex = 0;
    double value = number.toDouble();
    
    while (value.abs() >= 1000 && suffixIndex < suffixes.length - 1) {
      value /= 1000;
      suffixIndex++;
    }
    
    return '${value.toStringAsFixed(decimals)}${suffixes[suffixIndex]}';
  }

  /// Clamp a number between min and max
  static T clamp<T extends num>(T value, T min, T max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Check if number is within range
  static bool inRange(num value, num min, num max) {
    return value >= min && value <= max;
  }

  /// Round to nearest multiple
  static double roundToNearest(double value, double multiple) {
    return (value / multiple).round() * multiple;
  }

  /// Calculate percentage
  static double percentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate percentage change
  static double percentageChange(num oldValue, num newValue) {
    if (oldValue == 0) return 0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Get average of numbers
  static double average(List<num> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((num a, num b) => a + b) / numbers.length;
  }

  /// Get median of numbers
  static double median(List<num> numbers) {
    if (numbers.isEmpty) return 0;
    
    final List<num> sorted = List<num>.from(numbers)..sort();
    final int middle = sorted.length ~/ 2;
    
    if (sorted.length % 2 == 0) {
      return (sorted[middle - 1] + sorted[middle]) / 2;
    } else {
      return sorted[middle].toDouble();
    }
  }

  /// Get sum of numbers
  static num sum(List<num> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((num a, num b) => a + b);
  }

  /// Get minimum value
  static T min<T extends num>(List<T> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    return numbers.reduce((T a, T b) => a < b ? a : b);
  }

  /// Get maximum value
  static T max<T extends num>(List<T> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    return numbers.reduce((T a, T b) => a > b ? a : b);
  }

  /// Check if number is even
  static bool isEven(int number) => number % 2 == 0;

  /// Check if number is odd
  static bool isOdd(int number) => number % 2 != 0;

  /// Check if number is prime
  static bool isPrime(int number) {
    if (number < 2) return false;
    if (number == 2) return true;
    if (number % 2 == 0) return false;
    
    for (int i = 3; i <= math.sqrt(number); i += 2) {
      if (number % i == 0) return false;
    }
    
    return true;
  }

  /// Calculate factorial
  static int factorial(int n) {
    if (n < 0) throw ArgumentError('n must be non-negative');
    if (n <= 1) return 1;
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    
    return result;
  }

  /// Generate random number in range
  static int randomInt(int min, int max) {
    return min + math.Random().nextInt(max - min + 1);
  }

  /// Generate random double in range
  static double randomDouble(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }

  /// Convert bytes to human-readable format
  static String bytesToSize(int bytes) {
    const List<String> sizes = <String>['B', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) return '0 B';
    
    final int i = (math.log(bytes) / math.log(1024)).floor();
    final double size = bytes / math.pow(1024, i);
    
    return '${size.toStringAsFixed(2)} ${sizes[i]}';
  }

  /// Round up to nearest integer
  static int roundUp(double value) => value.ceil();

  /// Round down to nearest integer
  static int roundDown(double value) => value.floor();

  /// Round to specified decimal places
  static double roundToDecimals(double value, int decimals) {
    final double mod = math.pow(10.0, decimals).toDouble();
    return (value * mod).round() / mod;
  }

  /// Check if two doubles are approximately equal
  static bool approximatelyEqual(
    double a,
    double b, {
    double epsilon = 0.0001,
  }) {
    return (a - b).abs() < epsilon;
  }

  /// Linear interpolation between two values
  static double lerp(double start, double end, double t) {
    return start + (end - start) * clamp(t, 0.0, 1.0);
  }

  /// Map value from one range to another
  static double map(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  /// Check if number is positive
  static bool isPositive(num number) => number > 0;

  /// Check if number is negative
  static bool isNegative(num number) => number < 0;

  /// Check if number is zero
  static bool isZero(num number) => number == 0;

  /// Get absolute value
  static T abs<T extends num>(T number) => number.abs() as T;

  /// Get sign of number (-1, 0, or 1)
  static int sign(num number) {
    if (number > 0) return 1;
    if (number < 0) return -1;
    return 0;
  }

  /// Format ordinal number (1st, 2nd, 3rd, etc.)
  static String ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  /// Calculate compound interest
  static double compoundInterest({
    required double principal,
    required double rate,
    required int years,
    int compoundsPerYear = 1,
  }) {
    return principal *
        math.pow(1 + (rate / compoundsPerYear), compoundsPerYear * years);
  }

  /// Calculate simple interest
  static double simpleInterest({
    required double principal,
    required double rate,
    required int years,
  }) {
    return principal * rate * years;
  }
}
