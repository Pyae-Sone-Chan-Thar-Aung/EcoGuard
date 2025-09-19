# EcoGuard UI/UX Design Documentation

## Design Philosophy

EcoGuard follows Material Design 3 principles with a focus on environmental sustainability, user engagement, and accessibility. The design emphasizes clean interfaces, intuitive navigation, and gamification elements to encourage eco-friendly behaviors.

## Design System

### Color Palette

#### Primary Colors
- **Primary Green**: `#2E7D32` - Main brand color, used for primary actions
- **Light Green**: `#4CAF50` - Secondary actions, success states
- **Leaf Green**: `#8BC34A` - Accent color, highlights
- **Dark Green**: `#1B5E20` - Dark theme primary, headers

#### Supporting Colors
- **Background Light**: `#FAFAFA` - Light theme background
- **Background Dark**: `#121212` - Dark theme background
- **Surface**: `#FFFFFF` / `#1E1E1E` - Card backgrounds
- **Error**: `#D32F2F` - Error states
- **Warning**: `#FF9800` - Warning states
- **Success**: `#4CAF50` - Success feedback

### Typography

#### Font Hierarchy
```
Headline Large: 32px, Bold - Page titles
Headline Medium: 24px, SemiBold - Section headers
Title Large: 20px, SemiBold - Card titles
Title Medium: 16px, Medium - Subsections
Body Large: 16px, Regular - Primary text
Body Medium: 14px, Regular - Secondary text
Caption: 12px, Regular - Helper text
```

#### Font Weights
- **Bold (700)**: Headlines, emphasis
- **SemiBold (600)**: Titles, buttons
- **Medium (500)**: Subtitles
- **Regular (400)**: Body text

### Spacing System

#### Base Unit: 4px
- **XS**: 4px - Tight spacing
- **SM**: 8px - Close elements
- **MD**: 16px - Standard spacing
- **LG**: 24px - Section spacing
- **XL**: 32px - Page margins
- **XXL**: 48px - Major sections

### Component Library

#### Cards
```dart
CardTheme(
  elevation: 4,
  shadowColor: Colors.black.withOpacity(0.1),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
)
```

#### Buttons
```dart
ElevatedButton.styleFrom(
  backgroundColor: AppColors.primaryGreen,
  foregroundColor: Colors.white,
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
)
```

#### Input Fields
```dart
InputDecorationTheme(
  filled: true,
  fillColor: Colors.grey[50],
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey[300]),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
  ),
)
```

## Screen Layouts

### Dashboard Layout
```
┌─────────────────────────────────┐
│ AppBar: Welcome + Notifications │
├─────────────────────────────────┤
│ Points Card    │ Streak Card    │
├─────────────────────────────────┤
│ Today's Challenge Progress      │
├─────────────────────────────────┤
│ Quick Actions Grid (2x2)        │
├─────────────────────────────────┤
│ Recent Activity List            │
└─────────────────────────────────┘
```

### Feature Hub Layout
```
┌─────────────────────────────────┐
│ AppBar: Feature Title           │
├─────────────────────────────────┤
│ Hero Card: Feature Description  │
├─────────────────────────────────┤
│ Feature Grid (2x3)              │
├─────────────────────────────────┤
│ Statistics Card                 │
├─────────────────────────────────┤
│ Tips & Guidelines               │
└─────────────────────────────────┘
```

## Navigation Design

### Bottom Navigation
- **5 Tabs**: Dashboard, Trees, E-Waste, Carbon, Community
- **Active State**: Primary green with icon fill
- **Inactive State**: Grey with outline icons
- **Badge Support**: Notification counts

### App Bar Design
- **Centered Title**: Feature name or greeting
- **Actions**: Notifications, Profile, Settings
- **Elevation**: 0 for modern flat design
- **Background**: Primary green with white text

## Gamification Elements

### Progress Indicators
- **Linear Progress**: Challenge completion
- **Circular Progress**: Goal achievement
- **Step Progress**: Multi-step processes
- **Animated Counters**: Points and statistics

### Achievement System
- **Badges**: Circular icons with achievement graphics
- **Progress Rings**: Completion percentages
- **Celebration Animations**: Success feedback
- **Leaderboard Cards**: Competitive elements

### Feedback Design
- **Success States**: Green checkmarks, positive messages
- **Error States**: Red indicators, helpful guidance
- **Loading States**: Skeleton screens, progress indicators
- **Empty States**: Encouraging illustrations and CTAs

## Responsive Design

### Breakpoints
- **Mobile**: 0-599px (Primary target)
- **Tablet**: 600-1023px (Adaptive layout)
- **Desktop**: 1024px+ (Web version)

### Adaptive Elements
- **Grid Columns**: 2 on mobile, 3+ on tablet/desktop
- **Card Sizing**: Full width on mobile, constrained on larger screens
- **Navigation**: Bottom nav on mobile, side nav on desktop
- **Typography**: Scaled font sizes for different screen densities

## Accessibility Features

### Color Accessibility
- **Contrast Ratio**: Minimum 4.5:1 for normal text
- **Color Independence**: No color-only information
- **High Contrast**: Dark theme support
- **Color Blind Support**: Pattern and icon differentiation

### Interaction Accessibility
- **Touch Targets**: Minimum 44px tap targets
- **Focus Indicators**: Clear keyboard navigation
- **Screen Reader**: Semantic markup and labels
- **Gesture Alternatives**: Button alternatives for swipe actions

### Text Accessibility
- **Font Scaling**: Support for system font sizes
- **Reading Level**: Simple, clear language
- **Internationalization**: RTL language support
- **Content Structure**: Proper heading hierarchy

## Animation Guidelines

### Micro-Interactions
- **Duration**: 200-300ms for UI feedback
- **Easing**: Material motion curves
- **Purpose**: Provide feedback, guide attention
- **Performance**: 60fps smooth animations

### Page Transitions
- **Shared Elements**: Hero animations between screens
- **Slide Transitions**: Horizontal navigation flow
- **Fade Transitions**: Modal and overlay appearances
- **Scale Transitions**: Card expansions and focus states

### Loading Animations
- **Skeleton Screens**: Content placeholders
- **Progress Indicators**: Linear and circular
- **Shimmer Effects**: Loading state feedback
- **Staggered Animations**: List item appearances

## Component Specifications

### EcoPointsCard
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primaryGreen, AppColors.lightGreen],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      Icon(Icons.eco, size: 32, color: Colors.white),
      Text('Eco Points', style: TextStyle(color: Colors.white70)),
      Text('1,250', style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )),
    ],
  ),
)
```

### StreakCounter
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.orange.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.orange.withOpacity(0.3)),
  ),
  child: Column(
    children: [
      Icon(Icons.local_fire_department, size: 32, color: Colors.orange),
      Text('Current Streak', style: TextStyle(color: Colors.orange[700])),
      Text('15 days', style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.orange[800],
      )),
    ],
  ),
)
```

### QuickActionCard
```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primaryGreen),
          ),
          SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    ),
  ),
)
```

## Dark Theme Considerations

### Color Adaptations
- **Surface Colors**: Dark grey backgrounds (#1E1E1E)
- **Text Colors**: White and light grey variants
- **Accent Colors**: Maintain brand green with adjusted opacity
- **Elevation**: Increased shadow opacity for depth

### Contrast Adjustments
- **Primary Text**: White (#FFFFFF)
- **Secondary Text**: Light grey (#FFFFFF70)
- **Disabled Text**: Dark grey (#FFFFFF60)
- **Dividers**: Dark grey (#FFFFFF12)

## Performance Considerations

### Image Optimization
- **Format**: WebP for web, optimized PNG/JPEG for mobile
- **Sizing**: Multiple resolutions for different densities
- **Lazy Loading**: Deferred loading for non-critical images
- **Caching**: Efficient image cache management

### Layout Performance
- **Widget Rebuilds**: Minimize unnecessary rebuilds
- **List Performance**: Lazy loading for large datasets
- **Animation Performance**: Hardware acceleration
- **Memory Management**: Proper disposal of resources

## Future Enhancements

### Advanced Features
- **Personalization**: User-customizable themes
- **Accessibility**: Voice navigation support
- **Internationalization**: Multi-language support
- **Platform Integration**: Native platform features

### Design Evolution
- **Material You**: Dynamic color theming
- **Adaptive Icons**: Platform-specific iconography
- **Advanced Animations**: Lottie animation integration
- **AR/VR Elements**: Immersive experience features

This design system ensures consistency, accessibility, and scalability while maintaining the environmental focus that makes EcoGuard unique and engaging for users committed to sustainability.
