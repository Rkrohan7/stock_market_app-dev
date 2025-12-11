class ApiConstants {
  ApiConstants._();

  // Demo API endpoints (Replace with actual stock market API)
  static const String baseUrl = 'https://api.stockmarket.com/v1';

  // Auth Endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User Endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  static const String kycVerification = '/user/kyc';
  static const String kycStatus = '/user/kyc/status';

  // Market Data Endpoints
  static const String marketOverview = '/market/overview';
  static const String indices = '/market/indices';
  static const String topGainers = '/market/gainers';
  static const String topLosers = '/market/losers';
  static const String mostActive = '/market/active';

  // Stock Endpoints
  static const String stockSearch = '/stocks/search';
  static const String stockDetails = '/stocks/{symbol}';
  static const String stockQuote = '/stocks/{symbol}/quote';
  static const String stockChart = '/stocks/{symbol}/chart';
  static const String stockNews = '/stocks/{symbol}/news';
  static const String stockAnalysis = '/stocks/{symbol}/analysis';

  // Portfolio Endpoints
  static const String portfolio = '/portfolio';
  static const String holdings = '/portfolio/holdings';
  static const String portfolioHistory = '/portfolio/history';

  // Order Endpoints
  static const String placeOrder = '/orders/place';
  static const String orderHistory = '/orders/history';
  static const String cancelOrder = '/orders/{orderId}/cancel';
  static const String orderStatus = '/orders/{orderId}/status';

  // Watchlist Endpoints
  static const String watchlist = '/watchlist';
  static const String addToWatchlist = '/watchlist/add';
  static const String removeFromWatchlist = '/watchlist/remove';

  // News Endpoints
  static const String marketNews = '/news/market';
  static const String newsDetails = '/news/{newsId}';

  // Education Endpoints
  static const String courses = '/education/courses';
  static const String lessons = '/education/lessons';
  static const String quizzes = '/education/quizzes';

  // AI Endpoints
  static const String aiAnalysis = '/ai/analysis';
  static const String aiPredictions = '/ai/predictions';
  static const String aiPortfolioOptimize = '/ai/optimize';

  // WebSocket Endpoints
  static const String wsMarketData = 'wss://stream.stockmarket.com/market';
  static const String wsOrderUpdates = 'wss://stream.stockmarket.com/orders';
}
