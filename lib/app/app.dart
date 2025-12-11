import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// Services
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

// Views
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

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: KycView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: MarketView),
    MaterialRoute(page: PortfolioView),
    MaterialRoute(page: WatchlistView),
    MaterialRoute(page: StockDetailsView),
    MaterialRoute(page: TradingView),
    MaterialRoute(page: NewsView),
    MaterialRoute(page: EducationView),
    MaterialRoute(page: AiSuggestionsView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: SettingsView),
  ],
  dependencies: [
    // Stacked Services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),

    // App Services
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: StockService),
    LazySingleton(classType: PortfolioService),
    LazySingleton(classType: WatchlistService),
    LazySingleton(classType: OrderService),
    LazySingleton(classType: NewsService),
    LazySingleton(classType: EducationService),
    LazySingleton(classType: AiService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: ThemeService),
    LazySingleton(classType: ConnectivityService),
  ],
  bottomsheets: [
    // Add bottom sheets here
  ],
  dialogs: [
    // Add dialogs here
  ],
)
class App {}
