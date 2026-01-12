// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i27;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i29;
import 'package:stock_trading_app/data/models/education_model.dart' as _i28;
import 'package:stock_trading_app/ui/views/about/about_view.dart' as _i22;
import 'package:stock_trading_app/ui/views/ai_suggestions/ai_suggestions_view.dart'
    as _i13;
import 'package:stock_trading_app/ui/views/auth/login_view.dart' as _i3;
import 'package:stock_trading_app/ui/views/blog_detail/blog_detail_view.dart'
    as _i12;
import 'package:stock_trading_app/ui/views/education/education_view.dart'
    as _i11;
import 'package:stock_trading_app/ui/views/fund/add_funds_view.dart' as _i18;
import 'package:stock_trading_app/ui/views/fund/fund_view.dart' as _i17;
import 'package:stock_trading_app/ui/views/fund/withdraw_funds_view.dart'
    as _i19;
import 'package:stock_trading_app/ui/views/help_support/help_support_view.dart'
    as _i21;
import 'package:stock_trading_app/ui/views/home/home_view.dart' as _i4;
import 'package:stock_trading_app/ui/views/market/market_view.dart' as _i5;
import 'package:stock_trading_app/ui/views/news/news_view.dart' as _i10;
import 'package:stock_trading_app/ui/views/news_alerts/news_alerts_view.dart'
    as _i24;
import 'package:stock_trading_app/ui/views/order_history/order_history_view.dart'
    as _i20;
import 'package:stock_trading_app/ui/views/portfolio/portfolio_view.dart'
    as _i6;
import 'package:stock_trading_app/ui/views/price_alerts/price_alerts_view.dart'
    as _i23;
import 'package:stock_trading_app/ui/views/privacy_policy/privacy_policy_view.dart'
    as _i25;
import 'package:stock_trading_app/ui/views/profile/profile_view.dart' as _i14;
import 'package:stock_trading_app/ui/views/search/search_view.dart' as _i15;
import 'package:stock_trading_app/ui/views/settings/settings_view.dart' as _i16;
import 'package:stock_trading_app/ui/views/startup/startup_view.dart' as _i2;
import 'package:stock_trading_app/ui/views/stock_details/stock_details_view.dart'
    as _i8;
import 'package:stock_trading_app/ui/views/terms_of_service/terms_of_service_view.dart'
    as _i26;
import 'package:stock_trading_app/ui/views/trading/trading_view.dart' as _i9;
import 'package:stock_trading_app/ui/views/watchlist/watchlist_view.dart'
    as _i7;

class Routes {
  static const startupView = '/';

  static const loginView = '/login-view';

  static const homeView = '/home-view';

  static const marketView = '/market-view';

  static const portfolioView = '/portfolio-view';

  static const watchlistView = '/watchlist-view';

  static const stockDetailsView = '/stock-details-view';

  static const tradingView = '/trading-view';

  static const newsView = '/news-view';

  static const educationView = '/education-view';

  static const blogDetailView = '/blog-detail-view';

  static const aiSuggestionsView = '/ai-suggestions-view';

  static const profileView = '/profile-view';

  static const searchView = '/search-view';

  static const settingsView = '/settings-view';

  static const fundView = '/fund-view';

  static const addFundsView = '/add-funds-view';

  static const withdrawFundsView = '/withdraw-funds-view';

  static const orderHistoryView = '/order-history-view';

  static const helpSupportView = '/help-support-view';

  static const aboutView = '/about-view';

  static const priceAlertsView = '/price-alerts-view';

  static const newsAlertsView = '/news-alerts-view';

  static const privacyPolicyView = '/privacy-policy-view';

  static const termsOfServiceView = '/terms-of-service-view';

  static const all = <String>{
    startupView,
    loginView,
    homeView,
    marketView,
    portfolioView,
    watchlistView,
    stockDetailsView,
    tradingView,
    newsView,
    educationView,
    blogDetailView,
    aiSuggestionsView,
    profileView,
    searchView,
    settingsView,
    fundView,
    addFundsView,
    withdrawFundsView,
    orderHistoryView,
    helpSupportView,
    aboutView,
    priceAlertsView,
    newsAlertsView,
    privacyPolicyView,
    termsOfServiceView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i4.HomeView,
    ),
    _i1.RouteDef(
      Routes.marketView,
      page: _i5.MarketView,
    ),
    _i1.RouteDef(
      Routes.portfolioView,
      page: _i6.PortfolioView,
    ),
    _i1.RouteDef(
      Routes.watchlistView,
      page: _i7.WatchlistView,
    ),
    _i1.RouteDef(
      Routes.stockDetailsView,
      page: _i8.StockDetailsView,
    ),
    _i1.RouteDef(
      Routes.tradingView,
      page: _i9.TradingView,
    ),
    _i1.RouteDef(
      Routes.newsView,
      page: _i10.NewsView,
    ),
    _i1.RouteDef(
      Routes.educationView,
      page: _i11.EducationView,
    ),
    _i1.RouteDef(
      Routes.blogDetailView,
      page: _i12.BlogDetailView,
    ),
    _i1.RouteDef(
      Routes.aiSuggestionsView,
      page: _i13.AiSuggestionsView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i14.ProfileView,
    ),
    _i1.RouteDef(
      Routes.searchView,
      page: _i15.SearchView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i16.SettingsView,
    ),
    _i1.RouteDef(
      Routes.fundView,
      page: _i17.FundView,
    ),
    _i1.RouteDef(
      Routes.addFundsView,
      page: _i18.AddFundsView,
    ),
    _i1.RouteDef(
      Routes.withdrawFundsView,
      page: _i19.WithdrawFundsView,
    ),
    _i1.RouteDef(
      Routes.orderHistoryView,
      page: _i20.OrderHistoryView,
    ),
    _i1.RouteDef(
      Routes.helpSupportView,
      page: _i21.HelpSupportView,
    ),
    _i1.RouteDef(
      Routes.aboutView,
      page: _i22.AboutView,
    ),
    _i1.RouteDef(
      Routes.priceAlertsView,
      page: _i23.PriceAlertsView,
    ),
    _i1.RouteDef(
      Routes.newsAlertsView,
      page: _i24.NewsAlertsView,
    ),
    _i1.RouteDef(
      Routes.privacyPolicyView,
      page: _i25.PrivacyPolicyView,
    ),
    _i1.RouteDef(
      Routes.termsOfServiceView,
      page: _i26.TermsOfServiceView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.LoginView(),
        settings: data,
      );
    },
    _i4.HomeView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.HomeView(),
        settings: data,
      );
    },
    _i5.MarketView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.MarketView(),
        settings: data,
      );
    },
    _i6.PortfolioView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.PortfolioView(),
        settings: data,
      );
    },
    _i7.WatchlistView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.WatchlistView(),
        settings: data,
      );
    },
    _i8.StockDetailsView: (data) {
      final args = data.getArgs<StockDetailsViewArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.StockDetailsView(key: args.key, symbol: args.symbol),
        settings: data,
      );
    },
    _i9.TradingView: (data) {
      final args = data.getArgs<TradingViewArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.TradingView(
            key: args.key, symbol: args.symbol, isBuy: args.isBuy),
        settings: data,
      );
    },
    _i10.NewsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.NewsView(),
        settings: data,
      );
    },
    _i11.EducationView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.EducationView(),
        settings: data,
      );
    },
    _i12.BlogDetailView: (data) {
      final args = data.getArgs<BlogDetailViewArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i12.BlogDetailView(key: args.key, blog: args.blog),
        settings: data,
      );
    },
    _i13.AiSuggestionsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.AiSuggestionsView(),
        settings: data,
      );
    },
    _i14.ProfileView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.ProfileView(),
        settings: data,
      );
    },
    _i15.SearchView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.SearchView(),
        settings: data,
      );
    },
    _i16.SettingsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.SettingsView(),
        settings: data,
      );
    },
    _i17.FundView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.FundView(),
        settings: data,
      );
    },
    _i18.AddFundsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.AddFundsView(),
        settings: data,
      );
    },
    _i19.WithdrawFundsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i19.WithdrawFundsView(),
        settings: data,
      );
    },
    _i20.OrderHistoryView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i20.OrderHistoryView(),
        settings: data,
      );
    },
    _i21.HelpSupportView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.HelpSupportView(),
        settings: data,
      );
    },
    _i22.AboutView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.AboutView(),
        settings: data,
      );
    },
    _i23.PriceAlertsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.PriceAlertsView(),
        settings: data,
      );
    },
    _i24.NewsAlertsView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i24.NewsAlertsView(),
        settings: data,
      );
    },
    _i25.PrivacyPolicyView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.PrivacyPolicyView(),
        settings: data,
      );
    },
    _i26.TermsOfServiceView: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i26.TermsOfServiceView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StockDetailsViewArguments {
  const StockDetailsViewArguments({
    this.key,
    required this.symbol,
  });

  final _i27.Key? key;

  final String symbol;

  @override
  String toString() {
    return '{"key": "$key", "symbol": "$symbol"}';
  }

  @override
  bool operator ==(covariant StockDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.symbol == symbol;
  }

  @override
  int get hashCode {
    return key.hashCode ^ symbol.hashCode;
  }
}

class TradingViewArguments {
  const TradingViewArguments({
    this.key,
    required this.symbol,
    required this.isBuy,
  });

  final _i27.Key? key;

  final String symbol;

  final bool isBuy;

  @override
  String toString() {
    return '{"key": "$key", "symbol": "$symbol", "isBuy": "$isBuy"}';
  }

  @override
  bool operator ==(covariant TradingViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.symbol == symbol && other.isBuy == isBuy;
  }

  @override
  int get hashCode {
    return key.hashCode ^ symbol.hashCode ^ isBuy.hashCode;
  }
}

class BlogDetailViewArguments {
  const BlogDetailViewArguments({
    this.key,
    required this.blog,
  });

  final _i27.Key? key;

  final _i28.BlogModel blog;

  @override
  String toString() {
    return '{"key": "$key", "blog": "$blog"}';
  }

  @override
  bool operator ==(covariant BlogDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.blog == blog;
  }

  @override
  int get hashCode {
    return key.hashCode ^ blog.hashCode;
  }
}

extension NavigatorStateExtension on _i29.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMarketView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.marketView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPortfolioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.portfolioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWatchlistView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.watchlistView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStockDetailsView({
    _i27.Key? key,
    required String symbol,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.stockDetailsView,
        arguments: StockDetailsViewArguments(key: key, symbol: symbol),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTradingView({
    _i27.Key? key,
    required String symbol,
    required bool isBuy,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.tradingView,
        arguments: TradingViewArguments(key: key, symbol: symbol, isBuy: isBuy),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.newsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEducationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.educationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBlogDetailView({
    _i27.Key? key,
    required _i28.BlogModel blog,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.blogDetailView,
        arguments: BlogDetailViewArguments(key: key, blog: blog),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAiSuggestionsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.aiSuggestionsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFundView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.fundView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddFundsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addFundsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWithdrawFundsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.withdrawFundsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.orderHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHelpSupportView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.helpSupportView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAboutView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.aboutView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPriceAlertsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.priceAlertsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsAlertsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.newsAlertsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPrivacyPolicyView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.privacyPolicyView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTermsOfServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.termsOfServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMarketView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.marketView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPortfolioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.portfolioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWatchlistView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.watchlistView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStockDetailsView({
    _i27.Key? key,
    required String symbol,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.stockDetailsView,
        arguments: StockDetailsViewArguments(key: key, symbol: symbol),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTradingView({
    _i27.Key? key,
    required String symbol,
    required bool isBuy,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.tradingView,
        arguments: TradingViewArguments(key: key, symbol: symbol, isBuy: isBuy),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.newsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEducationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.educationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBlogDetailView({
    _i27.Key? key,
    required _i28.BlogModel blog,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.blogDetailView,
        arguments: BlogDetailViewArguments(key: key, blog: blog),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAiSuggestionsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.aiSuggestionsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFundView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.fundView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddFundsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addFundsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWithdrawFundsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.withdrawFundsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.orderHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHelpSupportView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.helpSupportView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAboutView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.aboutView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPriceAlertsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.priceAlertsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsAlertsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.newsAlertsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPrivacyPolicyView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.privacyPolicyView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTermsOfServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.termsOfServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
