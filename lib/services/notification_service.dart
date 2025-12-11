import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize notifications
  Future<void> initialize() async {
    // Local Notifications Setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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

    // Firebase Messaging Setup
    await _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    showNotification(
      title: message.notification?.title ?? 'Stock Alert',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Handle navigation based on message data
    print('Message opened app: ${message.data}');
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  // Show local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'stock_alerts',
      'Stock Alerts',
      channelDescription: 'Notifications for stock price alerts',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
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
  Future<void> showPriceAlert({
    required String symbol,
    required double price,
    required bool isUp,
  }) async {
    final direction = isUp ? 'UP' : 'DOWN';
    await showNotification(
      title: '$symbol Price Alert',
      body: '$symbol is $direction at ₹${price.toStringAsFixed(2)}',
      payload: 'stock:$symbol',
    );
  }

  // Show order notification
  Future<void> showOrderNotification({
    required String symbol,
    required String status,
    required int quantity,
  }) async {
    await showNotification(
      title: 'Order $status',
      body: 'Your order for $quantity shares of $symbol has been $status',
      payload: 'order:$symbol',
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
      payload: 'market',
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
}

// Background message handler (must be top-level function)
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}
