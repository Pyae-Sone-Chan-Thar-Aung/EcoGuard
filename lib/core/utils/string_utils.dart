/// String utility functions for the application
class StringUtils {
  StringUtils._();

  /// Capitalize first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Truncate string with ellipsis
  static String truncate(
    String text, {
    int maxLength = 50,
    String ellipsis = '...',
  }) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  /// Remove all whitespace from string
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string is email
  static bool isEmail(String text) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(text);
  }

  /// Check if string is URL
  static bool isUrl(String text) {
    try {
      final Uri uri = Uri.parse(text);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// Check if string is numeric
  static bool isNumeric(String text) {
    return double.tryParse(text) != null;
  }

  /// Check if string is alphanumeric
  static bool isAlphanumeric(String text) {
    final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(text);
  }

  /// Convert string to slug (URL-friendly)
  static String toSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  /// Format number with thousand separators
  static String formatNumber(num number, {int decimals = 0}) {
    final String formatted = number.toStringAsFixed(decimals);
    final List<String> parts = formatted.split('.');
    
    String integerPart = parts[0];
    final String decimalPart = parts.length > 1 ? parts[1] : '';
    
    // Add thousand separators
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }
    
    if (decimals > 0 && decimalPart.isNotEmpty) {
      return '${buffer.toString()}.$decimalPart';
    }
    
    return buffer.toString();
  }

  /// Format file size in human-readable format
  static String formatFileSize(int bytes) {
    const List<String> units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  /// Generate random string
  static String randomString({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = false,
  }) {
    String chars = '';
    
    if (includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeLowercase) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (includeNumbers) chars += '0123456789';
    if (includeSymbols) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    if (chars.isEmpty) chars = 'abcdefghijklmnopqrstuvwxyz';
    
    final StringBuffer buffer = StringBuffer();
    final int charsLength = chars.length;
    
    for (int i = 0; i < length; i++) {
      buffer.write(chars[DateTime.now().microsecondsSinceEpoch % charsLength]);
    }
    
    return buffer.toString();
  }

  /// Check if string contains only letters
  static bool isAlpha(String text) {
    final RegExp alphaRegex = RegExp(r'^[a-zA-Z]+$');
    return alphaRegex.hasMatch(text);
  }

  /// Count words in a string
  static int wordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Extract numbers from string
  static List<int> extractNumbers(String text) {
    final RegExp numberRegex = RegExp(r'\d+');
    final Iterable<Match> matches = numberRegex.allMatches(text);
    
    return matches.map((Match match) {
      return int.parse(match.group(0)!);
    }).toList();
  }

  /// Reverse a string
  static String reverse(String text) {
    return text.split('').reversed.join();
  }

  /// Check if string is palindrome
  static bool isPalindrome(String text) {
    final String normalized = text.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    return normalized == reverse(normalized);
  }

  /// Convert camelCase to snake_case
  static String camelToSnake(String text) {
    return text
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (Match match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert snake_case to camelCase
  static String snakeToCamel(String text) {
    return text.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (Match match) => match.group(1)!.toUpperCase(),
    );
  }

  /// Mask sensitive data (e.g., credit card, email)
  static String mask(
    String text, {
    int visibleStart = 0,
    int visibleEnd = 0,
    String maskChar = '*',
  }) {
    if (text.length <= visibleStart + visibleEnd) return text;
    
    final String start = text.substring(0, visibleStart);
    final String end = text.substring(text.length - visibleEnd);
    final int maskedLength = text.length - visibleStart - visibleEnd;
    final String masked = maskChar * maskedLength;
    
    return '$start$masked$end';
  }

  /// Get initials from name
  static String getInitials(String name, {int maxInitials = 2}) {
    final List<String> words = name.trim().split(RegExp(r'\s+'));
    final StringBuffer initials = StringBuffer();
    
    for (int i = 0; i < words.length && i < maxInitials; i++) {
      if (words[i].isNotEmpty) {
        initials.write(words[i][0].toUpperCase());
      }
    }
    
    return initials.toString();
  }

  /// Remove HTML tags from string
  static String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Escape HTML special characters
  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Check if string is empty or null
  static bool isNullOrEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  /// Check if string is blank (empty or only whitespace)
  static bool isBlank(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Get default value if string is null or empty
  static String defaultIfEmpty(String? text, String defaultValue) {
    return isNullOrEmpty(text) ? defaultValue : text!;
  }
}
