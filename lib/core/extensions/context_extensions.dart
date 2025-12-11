import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Media Query shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get bottomPadding => padding.bottom;
  double get topPadding => padding.top;

  // Orientation
  Orientation get orientation => mediaQuery.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Brightness
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  // Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop(result);

  Future<T?> push<T>(Widget page) => navigator.push<T>(
        MaterialPageRoute(builder: (_) => page),
      );

  Future<T?> pushReplacement<T>(Widget page) => navigator.pushReplacement<T, void>(
        MaterialPageRoute(builder: (_) => page),
      );

  Future<T?> pushAndRemoveUntil<T>(Widget page, bool Function(Route<dynamic>) predicate) =>
      navigator.pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        predicate,
      );

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();

  // Responsive helpers
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // Responsive value helper
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
