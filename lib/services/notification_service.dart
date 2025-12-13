import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Notification channel IDs
  static const String _priceAlertChannelId = 'price_alerts';
  static const String _newsAlertChannelId = 'news_alerts';
  static const String _orderChannelId = 'order_notifications';
  static const String _marketChannelId = 'market_notifications';

  // Callback for handling notification taps
  Function(String? payload)? onNotificationTapped;

  // Initialize notifications
  Future<void> initialize() async {
    // Local Notifications Setup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    // Firebase Messaging Setup
    await _setupFirebaseMessaging();
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Price Alerts Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _priceAlertChannelId,
          'Price Alerts',
          description: 'Notifications for stock price alerts',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );

      // News Alerts Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _newsAlertChannelId,
          'News Alerts',
          description: 'Notifications for market news and updates',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );

      // Order Notifications Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _orderChannelId,
          'Order Notifications',
          description: 'Notifications for order status updates',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );

      // Market Notifications Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _marketChannelId,
          'Market Notifications',
          description: 'General market notifications',
          importance: Importance.defaultImportance,
          enableVibration: true,
          playSound: true,
        ),
      );
    }
  }

  Future<void> _setupFirebaseMessaging() async {
    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken');
        // TODO: Send new token to your server if needed
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a notification
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final notification = message.notification;

    if (notification != null) {
      // Determine notification type from data
      final type = data['type'] ?? 'general';

      switch (type) {
        case 'price_alert':
          showPriceAlertNotification(
            symbol: data['symbol'] ?? '',
            stockName: data['stockName'] ?? '',
            message: notification.body ?? '',
            price: double.tryParse(data['price'] ?? '0') ?? 0,
            isUp: data['isUp'] == 'true',
          );
          break;
        case 'news_alert':
          showNewsAlertNotification(
            newsId: data['newsId'] ?? '',
            title: notification.title ?? 'News Alert',
            body: notification.body ?? '',
            source: data['source'] ?? '',
          );
          break;
        case 'order':
          showOrderNotification(
            symbol: data['symbol'] ?? '',
            status: data['status'] ?? '',
            quantity: int.tryParse(data['quantity'] ?? '0') ?? 0,
          );
          break;
        default:
          showNotification(
            title: notification.title ?? 'Stock Alert',
            body: notification.body ?? '',
            payload: jsonEncode(data),
          );
      }
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final payload = jsonEncode(message.data);
    onNotificationTapped?.call(payload);
  }

  void _onNotificationTapped(NotificationResponse response) {
    onNotificationTapped?.call(response.payload);
  }

  // Get FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Show generic local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = _marketChannelId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Show price alert notification
  Future<void> showPriceAlertNotification({
    required String symbol,
    required String stockName,
    required String message,
    required double price,
    required bool isUp,
  }) async {
    final payload = jsonEncode({
      'type': 'price_alert',
      'symbol': symbol,
      'stockName': stockName,
      'price': price.toString(),
      'isUp': isUp.toString(),
    });

    final direction = isUp ? '📈' : '📉';

    await showNotification(
      title: '$direction $stockName Price Alert',
      body: message,
      payload: payload,
      channelId: _priceAlertChannelId,
    );
  }

  // Show price alert (backward compatible)
  Future<void> showPriceAlert({
    required String symbol,
    required double price,
    required bool isUp,
  }) async {
    final direction = isUp ? 'UP' : 'DOWN';
    await showPriceAlertNotification(
      symbol: symbol,
      stockName: symbol,
      message: '$symbol is $direction at ₹${price.toStringAsFixed(2)}',
      price: price,
      isUp: isUp,
    );
  }

  // Show news alert notification
  Future<void> showNewsAlertNotification({
    required String newsId,
    required String title,
    required String body,
    required String source,
  }) async {
    final payload = jsonEncode({
      'type': 'news_alert',
      'newsId': newsId,
      'source': source,
    });

    await showNotification(
      title: '📰 $title',
      body: '$body\n- $source',
      payload: payload,
      channelId: _newsAlertChannelId,
    );
  }

  // Show order notification
  Future<void> showOrderNotification({
    required String symbol,
    required String status,
    required int quantity,
  }) async {
    final payload = jsonEncode({
      'type': 'order',
      'symbol': symbol,
      'status': status,
      'quantity': quantity.toString(),
    });

    String emoji;
    switch (status.toLowerCase()) {
      case 'executed':
        emoji = '✅';
        break;
      case 'cancelled':
        emoji = '❌';
        break;
      case 'rejected':
        emoji = '⚠️';
        break;
      default:
        emoji = '📋';
    }

    await showNotification(
      title: '$emoji Order $status',
      body: 'Your order for $quantity shares of $symbol has been $status',
      payload: payload,
      channelId: _orderChannelId,
    );
  }

  // Show market notification
  Future<void> showMarketNotification({
    required String title,
    required String body,
  }) async {
    await showNotification(
      title: title,
      body: body,
      channelId: _marketChannelId,
    );
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Subscribe to stock alerts
  Future<void> subscribeToStockAlerts(String symbol) async {
    await subscribeToTopic('stock_$symbol');
  }

  // Unsubscribe from stock alerts
  Future<void> unsubscribeFromStockAlerts(String symbol) async {
    await unsubscribeFromTopic('stock_$symbol');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Helper methods
  String _getChannelName(String channelId) {
    switch (channelId) {
      case _priceAlertChannelId:
        return 'Price Alerts';
      case _newsAlertChannelId:
        return 'News Alerts';
      case _orderChannelId:
        return 'Order Notifications';
      case _marketChannelId:
        return 'Market Notifications';
      default:
        return 'Notifications';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case _priceAlertChannelId:
        return 'Notifications for stock price alerts';
      case _newsAlertChannelId:
        return 'Notifications for market news and updates';
      case _orderChannelId:
        return 'Notifications for order status updates';
      case _marketChannelId:
        return 'General market notifications';
      default:
        return 'App notifications';
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
  // Handle background message - typically you don't need to show notification
  // as FCM will show it automatically when app is in background
}
