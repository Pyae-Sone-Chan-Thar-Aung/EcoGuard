/// Input validation utilities for the application
/// 
/// Provides validation methods for common input types including
/// email, passwords, names, and other user inputs.
class InputValidator {
  InputValidator._();

  // Regular expressions for validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");

  static final RegExp _phoneRegex = RegExp(
    r'^\+?[\d\s\-\(\)]+$',
  );

  static final RegExp _alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(
    String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }

    if (requireSpecialChar &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate name (first name, last name, etc.)
  static String? validateName(
    String? value, {
    String fieldName = 'Name',
    int minLength = 2,
    int maxLength = 50,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    if (!_nameRegex.hasMatch(value)) {
      return '$fieldName contains invalid characters';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'Phone number is required' : null;
    }

    if (!_phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    // Remove non-digit characters for length check
    final String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate length
  static String? validateLength(
    String? value, {
    required int min,
    required int max,
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }

    if (value.length > max) {
      return '$fieldName must not exceed $max characters';
    }

    return null;
  }

  /// Validate numeric input
  static String? validateNumeric(
    String? value, {
    String fieldName = 'This field',
    double? min,
    double? max,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final double? number = double.tryParse(value);
    
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must not exceed $max';
    }

    return null;
  }

  /// Validate integer input
  static String? validateInteger(
    String? value, {
    String fieldName = 'This field',
    int? min,
    int? max,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final int? number = int.tryParse(value);
    
    if (number == null) {
      return '$fieldName must be a valid integer';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must not exceed $max';
    }

    return null;
  }

  /// Validate alphanumeric input
  static String? validateAlphanumeric(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (!_alphanumericRegex.hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }

    try {
      final Uri uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Please enter a valid URL';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  /// Sanitize input to prevent XSS and injection attacks
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  /// Remove leading/trailing whitespace and normalize spaces
  static String normalizeWhitespace(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
