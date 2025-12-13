import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/theme/app_theme.dart';
import 'firebase/firebase_admin.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'services/alert_service.dart';
import 'services/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
    if (Platform.isIOS) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: FireBaseConnectivtyProd.apiKey,
          appId: FireBaseConnectivtyProd.appId,
          messagingSenderId: FireBaseConnectivtyProd.messagingSenderId,
          projectId: FireBaseConnectivtyProd.projectId,
          storageBucket: FireBaseConnectivtyProd.storageBucket,
        ),
      );
    }
  } else {
    Firebase.app(); // Use existing app
  }

  // Setup locator for dependency injection
  await setupLocator();

  // Initialize theme service
  final themeService = locator<ThemeService>();
  await themeService.initialize();

  // Initialize notification service
  final notificationService = locator<NotificationService>();
  await notificationService.initialize();

  // Initialize alert service (this will load saved alerts and start monitoring)
  final alertService = locator<AlertService>();
  await alertService.initialize();

  // Initialize localization service
  final localizationService = locator<LocalizationService>();
  await localizationService.initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const StockMarketApp());
}

class StockMarketApp extends StatefulWidget {
  const StockMarketApp({super.key});

  @override
  State<StockMarketApp> createState() => _StockMarketAppState();
}

class _StockMarketAppState extends State<StockMarketApp> {
  final _themeService = locator<ThemeService>();
  final _localizationService = locator<LocalizationService>();

  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    _themeService.addListener(_onSettingsChanged);
    // Listen to language changes
    _localizationService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onSettingsChanged);
    _localizationService.removeListener(_onSettingsChanged);
    // Dispose alert service timers
    locator<AlertService>().dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    // Rebuild the app when theme or language changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeService.currentTheme,
      // Localization
      locale: _localizationService.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: Routes.startupView,
    );
  }
}
