import 'package:intl/intl.dart';

/// Date and time utilities for the application
class AppDateUtils {
  AppDateUtils._();

  // Date formatters
  static final DateFormat _shortDateFormat = DateFormat('MMM d, y');
  static final DateFormat _longDateFormat = DateFormat('MMMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM d, y h:mm a');
  static final DateFormat _iso8601Format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  /// Format date as short date (e.g., "Jan 15, 2024")
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format date as long date (e.g., "January 15, 2024")
  static String formatLongDate(DateTime date) {
    return _longDateFormat.format(date);
  }

  /// Format time (e.g., "3:45 PM")
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format date and time (e.g., "Jan 15, 2024 3:45 PM")
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Format as ISO 8601 string
  static String formatIso8601(DateTime date) {
    return _iso8601Format.format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "in 3 days")
  static String formatRelativeTime(DateTime date) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.isNegative) {
      return _formatFutureTime(difference.abs());
    } else {
      return _formatPastTime(difference);
    }
  }

  static String _formatPastTime(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final int minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? "minute" : "minutes"} ago';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      return '$hours ${hours == 1 ? "hour" : "hours"} ago';
    } else if (difference.inDays < 7) {
      final int days = difference.inDays;
      return '$days ${days == 1 ? "day" : "days"} ago';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    } else {
      final int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? "year" : "years"} ago';
    }
  }

  static String _formatFutureTime(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'in a few seconds';
    } else if (difference.inMinutes < 60) {
      final int minutes = difference.inMinutes;
      return 'in $minutes ${minutes == 1 ? "minute" : "minutes"}';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      return 'in $hours ${hours == 1 ? "hour" : "hours"}';
    } else if (difference.inDays < 7) {
      final int days = difference.inDays;
      return 'in $days ${days == 1 ? "day" : "days"}';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return 'in $weeks ${weeks == 1 ? "week" : "weeks"}';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? "month" : "months"}';
    } else {
      final int years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? "year" : "years"}';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week
  static DateTime startOfWeek(DateTime date) {
    final int daysToSubtract = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysToSubtract)));
  }

  /// Get end of week
  static DateTime endOfWeek(DateTime date) {
    final int daysToAdd = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToAdd)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    final DateTime nextMonth = DateTime(date.year, date.month + 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }

  /// Calculate age from birthdate
  static int calculateAge(DateTime birthDate) {
    final DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  /// Get days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final DateTime fromDate = startOfDay(from);
    final DateTime toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }

  /// Parse ISO 8601 string safely
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
