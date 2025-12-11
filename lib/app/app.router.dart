// GENERATED CODE - DO NOT MODIFY BY HAND

// This is a manually created router file for the stock trading app
// In production, run: flutter pub run build_runner build

import 'package:flutter/material.dart';

import '../ui/views/startup/startup_view.dart';
import '../ui/views/auth/login_view.dart';
import '../ui/views/auth/kyc_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/market/market_view.dart';
import '../ui/views/portfolio/portfolio_view.dart';
import '../ui/views/watchlist/watchlist_view.dart';
import '../ui/views/stock_details/stock_details_view.dart';
import '../ui/views/trading/trading_view.dart';
import '../ui/views/news/news_view.dart';
import '../ui/views/education/education_view.dart';
import '../ui/views/ai_suggestions/ai_suggestions_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/order_history/order_history_view.dart';

class Routes {
  static const String startupView = '/';
  static const String loginView = '/login-view';
  static const String kycView = '/kyc-view';
  static const String homeView = '/home-view';
  static const String marketView = '/market-view';
  static const String portfolioView = '/portfolio-view';
  static const String watchlistView = '/watchlist-view';
  static const String stockDetailsView = '/stock-details-view';
  static const String tradingView = '/trading-view';
  static const String newsView = '/news-view';
  static const String educationView = '/education-view';
  static const String aiSuggestionsView = '/ai-suggestions-view';
  static const String profileView = '/profile-view';
  static const String searchView = '/search-view';
  static const String settingsView = '/settings-view';
  static const String orderHistoryView = '/order-history-view';

  static const all = <String>{
    startupView,
    loginView,
    kycView,
    homeView,
    marketView,
    portfolioView,
    watchlistView,
    stockDetailsView,
    tradingView,
    newsView,
    educationView,
    aiSuggestionsView,
    profileView,
    searchView,
    settingsView,
    orderHistoryView,
  };
}

class StackedRouter extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.startupView:
      return MaterialPageRoute(
        builder: (_) => const StartupView(),
        settings: settings,
      );
    case Routes.loginView:
      return MaterialPageRoute(
        builder: (_) => const LoginView(),
        settings: settings,
      );
    case Routes.kycView:
      return MaterialPageRoute(
        builder: (_) => const KycView(),
        settings: settings,
      );
    case Routes.homeView:
      return MaterialPageRoute(
        builder: (_) => const HomeView(),
        settings: settings,
      );
    case Routes.marketView:
      return MaterialPageRoute(
        builder: (_) => const MarketView(),
        settings: settings,
      );
    case Routes.portfolioView:
      return MaterialPageRoute(
        builder: (_) => const PortfolioView(),
        settings: settings,
      );
    case Routes.watchlistView:
      return MaterialPageRoute(
        builder: (_) => const WatchlistView(),
        settings: settings,
      );
    case Routes.stockDetailsView:
      final args = settings.arguments as StockDetailsViewArguments;
      return MaterialPageRoute(
        builder: (_) => StockDetailsView(symbol: args.symbol),
        settings: settings,
      );
    case Routes.tradingView:
      final args = settings.arguments as TradingViewArguments;
      return MaterialPageRoute(
        builder: (_) => TradingView(
          symbol: args.symbol,
          isBuy: args.isBuy,
        ),
        settings: settings,
      );
    case Routes.newsView:
      return MaterialPageRoute(
        builder: (_) => const NewsView(),
        settings: settings,
      );
    case Routes.educationView:
      return MaterialPageRoute(
        builder: (_) => const EducationView(),
        settings: settings,
      );
    case Routes.aiSuggestionsView:
      return MaterialPageRoute(
        builder: (_) => const AiSuggestionsView(),
        settings: settings,
      );
    case Routes.profileView:
      return MaterialPageRoute(
        builder: (_) => const ProfileView(),
        settings: settings,
      );
    case Routes.searchView:
      return MaterialPageRoute(
        builder: (_) => const SearchView(),
        settings: settings,
      );
    case Routes.settingsView:
      return MaterialPageRoute(
        builder: (_) => const SettingsView(),
        settings: settings,
      );
    case Routes.orderHistoryView:
      return MaterialPageRoute(
        builder: (_) => const OrderHistoryView(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

// Arguments classes
class StockDetailsViewArguments {
  final String symbol;

  StockDetailsViewArguments({required this.symbol});
}

class TradingViewArguments {
  final String symbol;
  final bool isBuy;

  TradingViewArguments({
    required this.symbol,
    this.isBuy = true,
  });
}
