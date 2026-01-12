import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/alert_model.dart';
import '../data/models/news_alert_model.dart';
import '../data/models/news_model.dart';
import '../data/models/stock_model.dart';
import '../core/enums/enums.dart';
import 'auth_service.dart';
import 'notification_service.dart';
import 'stock_service.dart';
import 'news_service.dart';
import '../app/app.locator.dart';

class AlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = locator<AuthService>();
  final NotificationService _notificationService = locator<NotificationService>();
  final StockService _stockService = locator<StockService>();
  final NewsService _newsService = locator<NewsService>();

  Timer? _priceCheckTimer;
  Timer? _newsCheckTimer;
  DateTime? _lastNewsCheck;

  // Preference keys
  static const String _pushNotificationsKey = 'push_notifications_enabled';
  static const String _priceAlertsKey = 'price_alerts_enabled';
  static const String _newsAlertsKey = 'news_alerts_enabled';

  // Local cache
  List<AlertModel> _priceAlerts = [];
  List<NewsAlertModel> _newsAlerts = [];

  // Getters
  List<AlertModel> get priceAlerts => _priceAlerts;
  List<NewsAlertModel> get newsAlerts => _newsAlerts;

  String? get _userId => _authService.userId;

  // Initialize the service
  Future<void> initialize() async {
    if (_userId == null) return;

    await loadPriceAlerts();
    await loadNewsAlerts();

    // Start monitoring if alerts are enabled
    final prefs = await SharedPreferences.getInstance();
    final priceAlertsEnabled = prefs.getBool(_priceAlertsKey) ?? true;
    final newsAlertsEnabled = prefs.getBool(_newsAlertsKey) ?? true;

    if (priceAlertsEnabled) {
      startPriceMonitoring();
    }
    if (newsAlertsEnabled) {
      startNewsMonitoring();
    }
  }

  // Dispose timers
  void dispose() {
    _priceCheckTimer?.cancel();
    _newsCheckTimer?.cancel();
  }

  // ==================== PREFERENCES ====================

  Future<bool> getPushNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushNotificationsKey) ?? true;
  }

  Future<void> setPushNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushNotificationsKey, enabled);

    if (enabled) {
      // Subscribe to general topics
      await _notificationService.subscribeToTopic('general');
      await _notificationService.subscribeToTopic('market_updates');
    } else {
      // Unsubscribe from all topics
      await _notificationService.unsubscribeFromTopic('general');
      await _notificationService.unsubscribeFromTopic('market_updates');
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<bool> getPriceAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_priceAlertsKey) ?? true;
  }

  Future<void> setPriceAlertsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_priceAlertsKey, enabled);

    if (enabled) {
      startPriceMonitoring();
    } else {
      stopPriceMonitoring();
    }
  }

  Future<bool> getNewsAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_newsAlertsKey) ?? true;
  }

  Future<void> setNewsAlertsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_newsAlertsKey, enabled);

    if (enabled) {
      startNewsMonitoring();
      await _notificationService.subscribeToTopic('breaking_news');
    } else {
      stopNewsMonitoring();
      await _notificationService.unsubscribeFromTopic('breaking_news');
    }
  }

  // ==================== PRICE ALERTS ====================

  Future<void> loadPriceAlerts() async {
    if (_userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('priceAlerts')
          .orderBy('createdAt', descending: true)
          .get();

      _priceAlerts = snapshot.docs
          .map((doc) => AlertModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error loading price alerts: $e');
    }
  }

  Future<AlertModel?> createPriceAlert({
    required String symbol,
    required String stockName,
    required AlertType alertType,
    required double targetValue,
    double? currentValue,
  }) async {
    if (_userId == null) return null;

    try {
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('priceAlerts')
          .doc();

      final alert = AlertModel(
        id: docRef.id,
        userId: _userId!,
        symbol: symbol,
        stockName: stockName,
        alertType: alertType,
        targetValue: targetValue,
        currentValue: currentValue,
        createdAt: DateTime.now(),
      );

      await docRef.set(alert.toJson());
      _priceAlerts.insert(0, alert);

      // Subscribe to stock topic for FCM
      await _notificationService.subscribeToStockAlerts(symbol);

      return alert;
    } catch (e) {
      print('Error creating price alert: $e');
      return null;
    }
  }

  Future<bool> updatePriceAlert(AlertModel alert) async {
    if (_userId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('priceAlerts')
          .doc(alert.id)
          .update(alert.toJson());

      final index = _priceAlerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        _priceAlerts[index] = alert;
      }
      return true;
    } catch (e) {
      print('Error updating price alert: $e');
      return false;
    }
  }

  Future<bool> deletePriceAlert(String alertId) async {
    if (_userId == null) return false;

    try {
      final alert = _priceAlerts.firstWhere((a) => a.id == alertId);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('priceAlerts')
          .doc(alertId)
          .delete();

      _priceAlerts.removeWhere((a) => a.id == alertId);

      // Check if there are other alerts for this symbol
      final hasOtherAlerts = _priceAlerts.any((a) => a.symbol == alert.symbol);
      if (!hasOtherAlerts) {
        await _notificationService.unsubscribeFromStockAlerts(alert.symbol);
      }

      return true;
    } catch (e) {
      print('Error deleting price alert: $e');
      return false;
    }
  }

  Future<bool> togglePriceAlertActive(String alertId, bool isActive) async {
    final alert = _priceAlerts.firstWhere((a) => a.id == alertId);
    final updatedAlert = alert.copyWith(isActive: isActive);
    return await updatePriceAlert(updatedAlert);
  }

  // ==================== NEWS ALERTS ====================

  Future<void> loadNewsAlerts() async {
    if (_userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('newsAlerts')
          .orderBy('createdAt', descending: true)
          .get();

      _newsAlerts = snapshot.docs
          .map((doc) => NewsAlertModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error loading news alerts: $e');
    }
  }

  Future<NewsAlertModel?> createNewsAlert({
    String? keyword,
    List<String> categories = const [],
    List<String> symbols = const [],
    bool breakingNewsOnly = false,
  }) async {
    if (_userId == null) return null;

    try {
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('newsAlerts')
          .doc();

      final alert = NewsAlertModel(
        id: docRef.id,
        userId: _userId!,
        keyword: keyword,
        categories: categories,
        symbols: symbols,
        breakingNewsOnly: breakingNewsOnly,
        createdAt: DateTime.now(),
      );

      await docRef.set(alert.toJson());
      _newsAlerts.insert(0, alert);

      // Subscribe to relevant topics
      if (breakingNewsOnly) {
        await _notificationService.subscribeToTopic('breaking_news');
      }
      for (final category in categories) {
        await _notificationService.subscribeToTopic('news_$category');
      }
      for (final symbol in symbols) {
        await _notificationService.subscribeToTopic('news_$symbol');
      }

      return alert;
    } catch (e) {
      print('Error creating news alert: $e');
      return null;
    }
  }

  Future<bool> updateNewsAlert(NewsAlertModel alert) async {
    if (_userId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('newsAlerts')
          .doc(alert.id)
          .update(alert.toJson());

      final index = _newsAlerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        _newsAlerts[index] = alert;
      }
      return true;
    } catch (e) {
      print('Error updating news alert: $e');
      return false;
    }
  }

  Future<bool> deleteNewsAlert(String alertId) async {
    if (_userId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('newsAlerts')
          .doc(alertId)
          .delete();

      _newsAlerts.removeWhere((a) => a.id == alertId);
      return true;
    } catch (e) {
      print('Error deleting news alert: $e');
      return false;
    }
  }

  Future<bool> toggleNewsAlertActive(String alertId, bool isActive) async {
    final alert = _newsAlerts.firstWhere((a) => a.id == alertId);
    final updatedAlert = alert.copyWith(isActive: isActive);
    return await updateNewsAlert(updatedAlert);
  }

  // ==================== PRICE MONITORING ====================

  void startPriceMonitoring() {
    _priceCheckTimer?.cancel();
    // Check prices every 30 seconds
    _priceCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkPriceAlerts(),
    );
    // Also check immediately
    _checkPriceAlerts();
  }

  void stopPriceMonitoring() {
    _priceCheckTimer?.cancel();
    _priceCheckTimer = null;
  }

  Future<void> _checkPriceAlerts() async {
    final activeAlerts = _priceAlerts.where((a) => a.isActive && !a.isTriggered).toList();
    if (activeAlerts.isEmpty) return;

    // Group alerts by symbol
    final alertsBySymbol = <String, List<AlertModel>>{};
    for (final alert in activeAlerts) {
      alertsBySymbol.putIfAbsent(alert.symbol, () => []).add(alert);
    }

    // Check each symbol
    for (final entry in alertsBySymbol.entries) {
      try {
        final stock = await _stockService.getStockBySymbol(entry.key);
        if (stock == null) continue;

        for (final alert in entry.value) {
          final triggered = _isAlertTriggered(alert, stock);
          if (triggered) {
            await _triggerPriceAlert(alert, stock);
          }
        }
      } catch (e) {
        print('Error checking price for ${entry.key}: $e');
      }
    }
  }

  bool _isAlertTriggered(AlertModel alert, StockModel stock) {
    switch (alert.alertType) {
      case AlertType.priceAbove:
        return stock.currentPrice >= alert.targetValue;
      case AlertType.priceBelow:
        return stock.currentPrice <= alert.targetValue;
      case AlertType.percentageChange:
        final percentChange = ((stock.currentPrice - stock.previousClose) /
                stock.previousClose *
                100)
            .abs();
        return percentChange >= alert.targetValue;
      case AlertType.volume:
        return stock.volume >= alert.targetValue;
    }
  }

  Future<void> _triggerPriceAlert(AlertModel alert, StockModel stock) async {
    // Update alert as triggered
    final updatedAlert = alert.copyWith(
      isTriggered: true,
      triggeredAt: DateTime.now(),
      currentValue: stock.currentPrice,
    );
    await updatePriceAlert(updatedAlert);

    // Show notification
    final isUp = stock.change >= 0;
    String message;

    switch (alert.alertType) {
      case AlertType.priceAbove:
        message = '${alert.stockName} is now above ₹${alert.targetValue.toStringAsFixed(2)} at ₹${stock.currentPrice.toStringAsFixed(2)}';
        break;
      case AlertType.priceBelow:
        message = '${alert.stockName} is now below ₹${alert.targetValue.toStringAsFixed(2)} at ₹${stock.currentPrice.toStringAsFixed(2)}';
        break;
      case AlertType.percentageChange:
        final percentChange = ((stock.currentPrice - stock.previousClose) /
                stock.previousClose *
                100);
        message = '${alert.stockName} has moved ${percentChange.toStringAsFixed(2)}%';
        break;
      case AlertType.volume:
        message = '${alert.stockName} volume has exceeded ${alert.targetValue.toInt()}';
        break;
    }

    await _notificationService.showPriceAlertNotification(
      symbol: alert.symbol,
      stockName: alert.stockName,
      message: message,
      price: stock.currentPrice,
      isUp: isUp,
    );
  }

  // ==================== NEWS MONITORING ====================

  void startNewsMonitoring() {
    _newsCheckTimer?.cancel();
    _lastNewsCheck = DateTime.now();
    // Check news every 5 minutes
    _newsCheckTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkNewsAlerts(),
    );
  }

  void stopNewsMonitoring() {
    _newsCheckTimer?.cancel();
    _newsCheckTimer = null;
  }

  Future<void> _checkNewsAlerts() async {
    final activeAlerts = _newsAlerts.where((a) => a.isActive).toList();
    if (activeAlerts.isEmpty) return;

    try {
      // Get latest news
      final allNews = await _newsService.getLatestNews(limit: 20);
      final newNews = _lastNewsCheck != null
          ? allNews.where((n) => n.publishedAt.isAfter(_lastNewsCheck!)).toList()
          : allNews;

      if (newNews.isEmpty) {
        _lastNewsCheck = DateTime.now();
        return;
      }

      for (final news in newNews) {
        for (final alert in activeAlerts) {
          if (_newsMatchesAlert(news, alert)) {
            await _triggerNewsAlert(news, alert);
          }
        }
      }

      _lastNewsCheck = DateTime.now();
    } catch (e) {
      print('Error checking news alerts: $e');
    }
  }

  bool _newsMatchesAlert(NewsModel news, NewsAlertModel alert) {
    // Check breaking news filter
    if (alert.breakingNewsOnly && !news.isBreaking) {
      return false;
    }

    // Check keyword match
    if (alert.keyword != null && alert.keyword!.isNotEmpty) {
      final keyword = alert.keyword!.toLowerCase();
      if (!news.title.toLowerCase().contains(keyword) &&
          !news.description.toLowerCase().contains(keyword)) {
        return false;
      }
    }

    // Check category match
    if (alert.categories.isNotEmpty) {
      if (!alert.categories.contains(news.category)) {
        return false;
      }
    }

    // Check symbol match
    if (alert.symbols.isNotEmpty) {
      final hasMatchingSymbol = alert.symbols.any(
        (symbol) => news.relatedSymbols.contains(symbol),
      );
      if (!hasMatchingSymbol) {
        return false;
      }
    }

    return true;
  }

  Future<void> _triggerNewsAlert(NewsModel news, NewsAlertModel alert) async {
    // Update last triggered time
    final updatedAlert = alert.copyWith(lastTriggeredAt: DateTime.now());
    await updateNewsAlert(updatedAlert);

    // Show notification
    await _notificationService.showNewsAlertNotification(
      newsId: news.id,
      title: news.isBreaking ? 'Breaking: ${news.title}' : news.title,
      body: news.description,
      source: news.source,
    );
  }

  // ==================== UTILITY ====================

  Future<void> clearAllAlerts() async {
    if (_userId == null) return;

    // Delete price alerts
    final priceAlertsSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('priceAlerts')
        .get();

    for (final doc in priceAlertsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete news alerts
    final newsAlertsSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('newsAlerts')
        .get();

    for (final doc in newsAlertsSnapshot.docs) {
      await doc.reference.delete();
    }

    _priceAlerts.clear();
    _newsAlerts.clear();
  }

  // Get active alerts count
  int get activePriceAlertsCount =>
      _priceAlerts.where((a) => a.isActive && !a.isTriggered).length;

  int get activeNewsAlertsCount =>
      _newsAlerts.where((a) => a.isActive).length;

  int get totalActiveAlertsCount =>
      activePriceAlertsCount + activeNewsAlertsCount;
}
