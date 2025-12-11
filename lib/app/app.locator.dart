// GENERATED CODE - DO NOT MODIFY BY HAND

// This is a manually created locator file for the stock trading app
// In production, run: flutter pub run build_runner build

import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/stock_service.dart';
import '../services/portfolio_service.dart';
import '../services/watchlist_service.dart';
import '../services/order_service.dart';
import '../services/news_service.dart';
import '../services/education_service.dart';
import '../services/ai_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';
import '../services/connectivity_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Stacked Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());

  // App Services
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => StockService());
  locator.registerLazySingleton(() => PortfolioService());
  locator.registerLazySingleton(() => WatchlistService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => NewsService());
  locator.registerLazySingleton(() => EducationService());
  locator.registerLazySingleton(() => AiService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => ConnectivityService());
}
