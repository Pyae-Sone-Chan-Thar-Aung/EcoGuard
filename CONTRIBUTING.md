# Contributing to EcoGuard

First off, thank you for considering contributing to EcoGuard! It's people like you that make EcoGuard such a great tool for promoting environmental sustainability.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template:**
```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - Device: [e.g. iPhone 13, Pixel 6]
 - OS: [e.g. iOS 15, Android 12]
 - App Version: [e.g. 1.0.0]

**Additional context**
Add any other context about the problem here.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful** to most users
- **List any similar features** in other apps if applicable

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the code standards
3. **Add tests** if you've added code that should be tested
4. **Ensure the test suite passes** (`flutter test`)
5. **Make sure your code lints** (`flutter analyze`)
6. **Format your code** (`flutter format .`)
7. **Write a clear commit message**
8. **Create a Pull Request**

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Git
- An IDE (VS Code, Android Studio, or IntelliJ)

### Setup Steps

1. Fork and clone the repository
   ```bash
   git clone https://github.com/YOUR_USERNAME/EcoGuard_Project.git
   cd EcoGuard_Project
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Create environment file
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. Generate code
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app
   ```bash
   flutter run
   ```

## Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

- Use **trailing commas** for better formatting
- Use **const** constructors when possible
- Prefer **final** over **var** for immutable variables
- Use **meaningful variable names**
- Keep functions **small and focused**

### Code Organization

```dart
// 1. Imports (grouped and sorted)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecoguard/core/theme/app_colors.dart';
import 'package:ecoguard/models/user/user_profile.dart';

// 2. Class definition with documentation
/// A widget that displays user profile information.
/// 
/// This widget shows the user's name, email, and eco points.
class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Implementation
  }
}
```

### Documentation

- Add **dartdoc comments** to all public APIs
- Use `///` for documentation comments
- Include **examples** for complex functions
- Document **parameters** and **return values**

Example:
```dart
/// Calculates the environmental impact of a device.
///
/// This method analyzes the [deviceType], [ageInYears], and [condition]
/// to determine the environmental footprint.
///
/// Returns an [EnvironmentalImpact] object with detailed metrics.
///
/// Example:
/// ```dart
/// final impact = calculateImpact(
///   deviceType: DeviceType.smartphone,
///   ageInYears: 3,
///   condition: DeviceCondition.good,
/// );
/// ```
EnvironmentalImpact calculateImpact({
  required DeviceType deviceType,
  required int ageInYears,
  required DeviceCondition condition,
}) {
  // Implementation
}
```

### Testing

Write tests for:
- **Business logic** (services, utilities)
- **State management** (providers, notifiers)
- **Widget behavior** (key user interactions)

```dart
// Test structure
void main() {
  group('ServiceName', () {
    late ServiceName service;

    setUp(() {
      service = ServiceName();
    });

    test('should return expected result', () {
      // Arrange
      final input = 'test';

      // Act
      final result = service.method(input);

      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(ewaste): add smart categorization service

Implemented AI-powered categorization for e-waste items
using machine learning model.

Closes #123
```

```
fix(auth): resolve session expiration issue

Fixed bug where users were logged out prematurely.

Fixes #456
```

### Branch Naming

Use descriptive branch names:
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `refactor/what-is-refactored` - Code refactoring
- `docs/what-is-documented` - Documentation updates

Examples:
- `feature/carbon-calculator`
- `fix/login-validation`
- `refactor/state-management`
- `docs/api-documentation`

## Review Process

1. **Automated checks** must pass (linting, tests)
2. **Code review** by at least one maintainer
3. **Discussion** of any concerns or suggestions
4. **Approval** and merge

## Performance Guidelines

- **Avoid unnecessary rebuilds** - Use `const` constructors
- **Optimize images** - Compress and cache images
- **Lazy load** - Load data only when needed
- **Profile regularly** - Use Flutter DevTools
- **Minimize dependencies** - Only add what's necessary

## Security Guidelines

- **Never commit secrets** - Use environment variables
- **Validate all inputs** - Use InputValidator
- **Sanitize user data** - Prevent XSS and injection
- **Use HTTPS** - Always use secure connections
- **Handle errors gracefully** - Don't expose sensitive info

## Accessibility Guidelines

- Add **semantic labels** to interactive widgets
- Ensure **sufficient color contrast**
- Support **screen readers**
- Test with **TalkBack/VoiceOver**
- Provide **alternative text** for images

## Getting Help

- **Discord**: Join our community server
- **GitHub Discussions**: Ask questions
- **Stack Overflow**: Tag with `ecoguard`
- **Email**: dev@ecoguard.app

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Hall of Fame (for significant contributions)

Thank you for contributing to a more sustainable future! 🌱
