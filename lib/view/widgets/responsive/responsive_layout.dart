import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    if (size.width >= 1100) {
      return desktop ?? tablet ?? mobile;
    } else if (size.width >= 650) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: builder);
  }
}

class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int minItemsPerRow;
  final int maxItemsPerRow;
  final double minItemWidth;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.minItemsPerRow = 1,
    this.maxItemsPerRow = 4,
    this.minItemWidth = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemsPerRow = _calculateItemsPerRow(availableWidth);
        
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final itemWidth = (availableWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow;
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  int _calculateItemsPerRow(double availableWidth) {
    int itemsPerRow = (availableWidth / minItemWidth).floor();
    itemsPerRow = itemsPerRow.clamp(minItemsPerRow, maxItemsPerRow);
    return itemsPerRow;
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    
    if (ResponsiveLayout.isDesktop(context)) {
      padding = desktop ?? tablet ?? mobile ?? const EdgeInsets.all(24);
    } else if (ResponsiveLayout.isTablet(context)) {
      padding = tablet ?? mobile ?? const EdgeInsets.all(20);
    } else {
      padding = mobile ?? const EdgeInsets.all(16);
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;
  final TextAlign? textAlign;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.tabletStyle,
    this.desktopStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    
    if (ResponsiveLayout.isDesktop(context)) {
      style = desktopStyle ?? tabletStyle ?? mobileStyle ?? const TextStyle();
    } else if (ResponsiveLayout.isTablet(context)) {
      style = tabletStyle ?? mobileStyle ?? const TextStyle();
    } else {
      style = mobileStyle ?? const TextStyle();
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}

extension ResponsiveExtensions on BuildContext {
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  EdgeInsets get safePadding => MediaQuery.of(this).padding;
  
  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
