# EcoGuard 🌱

EcoGuard is a comprehensive eco-friendly application focused on e-waste management, tree planting, carbon footprint tracking, and environmental education.

## Features

### 🔋 E-Waste Management
- Smart device scanning and categorization
- Device analysis with environmental impact assessment
- Recycling center locator
- Creative handicraft suggestions for upcycling
- Sustainability options (repair, donate, sell, recycle)

### 🌳 Tree Planting
- Virtual and real-world tree planting tracking
- Tree growth visualization
- Environmental impact metrics

### 📊 Carbon Footprint Calculator
- Calculate personal carbon footprint
- Track carbon reduction progress
- Get personalized recommendations

### 🏆 Gamification
- Eco points system
- Achievement badges
- Leaderboard and challenges
- Streak tracking

### 📚 Education
- Interactive eco museum
- Environmental learning modules
- Impact visualization

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Supabase account (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd EcoGuard_Project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Copy `.env.example` to `.env`
   - Fill in your Supabase credentials and other configuration

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── error/              # Error handling and logging
│   ├── localization/       # Internationalization
│   ├── responsive/         # Responsive design utilities
│   ├── router/             # Navigation and routing
│   ├── theme/              # App theming
│   ├── utils/              # Utility functions
│   └── validation/         # Input validation
├── models/                  # Data models
│   ├── carbon/             # Carbon footprint models
│   ├── e_waste/            # E-waste related models
│   ├── tree/               # Tree planting models
│   └── user/               # User profile models
├── services/                # Business logic services
│   ├── ai/                 # AI recommendations
│   ├── cache/              # Caching service
│   ├── data/               # Data services
│   ├── e_waste/            # E-waste services
│   ├── ewaste/             # Smart categorization
│   ├── gamification/       # Gamification logic
│   ├── notifications/      # Push notifications
│   ├── performance/        # Performance monitoring
│   └── points/             # Points system
├── state/                   # State management
│   └── providers/          # Riverpod providers
├── view/                    # UI components
│   ├── screens/            # App screens
│   └── widgets/            # Reusable widgets
└── main.dart               # App entry point
```

## Configuration

### Environment Variables

Create a `.env` file based on `.env.example`:

```env
ENV=development
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
```

### Build Flavors

The app supports different build environments:

```bash
# Development
flutter run --dart-define=ENV=development

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=production
```

## Testing

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test file
```bash
flutter test test/core/config/app_config_test.dart
```

## Code Quality

### Linting

The project uses `flutter_lints` for code quality. Run:

```bash
flutter analyze
```

### Formatting

Format code using:

```bash
flutter format .
```

## Architecture

### State Management
- **Riverpod** for dependency injection and state management

### Routing
- **GoRouter** for declarative routing

### Local Storage
- **Hive** for fast, local key-value storage

### Backend
- **Supabase** for authentication, database, and real-time features

### Key Design Patterns
- **Service Pattern**: Business logic separated into services
- **Provider Pattern**: State management with Riverpod
- **Repository Pattern**: Data access abstraction
- **Singleton Pattern**: Single instance services

## Features in Detail

### Error Handling
- Global error handler for uncaught exceptions
- Structured logging with different log levels
- User-friendly error messages
- Retry logic for network operations

### Performance Optimization
- Image caching
- Lazy loading
- Debouncing and throttling
- Batch processing for large datasets

### Security
- Environment-based configuration
- Input validation and sanitization
- Secure API key management
- XSS and injection attack prevention

### Accessibility
- Semantic widgets
- Screen reader support
- High contrast mode support
- Adjustable font sizes

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- Follow Dart style guide
- Write comprehensive tests
- Document public APIs
- Keep commits atomic and meaningful

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@ecoguard.app or open an issue in the repository.

## Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- All contributors to this project

## Roadmap

- [ ] Offline mode support
- [ ] Social sharing features
- [ ] Advanced analytics dashboard
- [ ] Multi-language support expansion
- [ ] AR features enhancement
- [ ] Community challenges
- [ ] Marketplace for recycled items

---

Made with 💚 for a sustainable future
