// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/ai_service.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/fund_service.dart';
import '../services/razorpay_service.dart';
import '../services/connectivity_service.dart';
import '../services/education_service.dart';
import '../services/localization_service.dart';
import '../services/news_service.dart';
import '../services/notification_service.dart';
import '../services/order_service.dart';
import '../services/portfolio_service.dart';
import '../services/stock_service.dart';
import '../services/theme_service.dart';
import '../services/user_service.dart';
import '../services/watchlist_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
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
  locator.registerLazySingleton(() => AlertService());
  locator.registerLazySingleton(() => FundService());
  locator.registerLazySingleton(() => RazorpayService());
  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => LocalizationService());
}
