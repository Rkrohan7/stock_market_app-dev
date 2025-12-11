class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'StockMarket Pro';
  static const String appVersion = '1.0.0';

  // API Endpoints (Demo - Replace with actual API)
  static const String baseUrl = 'https://api.example.com';
  static const String marketDataWsUrl = 'wss://stream.example.com';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String portfolioCollection = 'portfolios';
  static const String watchlistCollection = 'watchlists';
  static const String ordersCollection = 'orders';
  static const String transactionsCollection = 'transactions';
  static const String alertsCollection = 'alerts';
  static const String newsCollection = 'news';
  static const String educationCollection = 'education';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_complete';
  static const String biometricKey = 'biometric_enabled';

  // OTP Settings
  static const int otpLength = 6;
  static const int otpTimeout = 60; // seconds

  // Market Timings (IST)
  static const String marketOpenTime = '09:15';
  static const String marketCloseTime = '15:30';

  // Pagination
  static const int defaultPageSize = 20;

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Chart Intervals
  static const List<String> chartIntervals = [
    '1m', '5m', '15m', '30m', '1h', '4h', '1D', '1W', '1M'
  ];

  // Order Types
  static const List<String> orderTypes = [
    'Market', 'Limit', 'Stop Loss', 'Stop Limit'
  ];
}
