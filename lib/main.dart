import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/theme/app_theme.dart';
import 'firebase/firebase_admin.dart';
import 'services/theme_service.dart';

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

  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    // Rebuild the app when theme changes
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
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: Routes.startupView,
    );
  }
}
