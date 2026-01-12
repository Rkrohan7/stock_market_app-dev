import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/stock_service.dart';
import '../../../services/portfolio_service.dart';
import '../../../data/models/stock_model.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../core/utils/helpers.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _stockService = locator<StockService>();
  final _portfolioService = locator<PortfolioService>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String get greeting => Helpers.getGreeting();
  String get userName => _authService.currentUser?.displayName ?? 'Investor';

  bool get isMarketOpen => Helpers.isMarketOpen();
  String get marketStatus => Helpers.getMarketStatusMessage();

  bool get hasNotifications => true; // Demo

  List<MarketIndex> _indices = [];
  List<MarketIndex> get indices => _indices;

  List<StockModel> _topGainers = [];
  List<StockModel> get topGainers => _topGainers;

  List<StockModel> _topLosers = [];
  List<StockModel> get topLosers => _topLosers;

  List<StockModel> _mostActive = [];
  List<StockModel> get mostActive => _mostActive;

  // Portfolio data
  PortfolioModel? _portfolio;
  PortfolioModel? get portfolio => _portfolio;

  double get portfolioValue => _portfolio?.currentValue ?? 0;
  double get todayPnL => _portfolio?.todayProfitLoss ?? 0;
  double get todayPnLPercent => _portfolio?.todayProfitLossPercent ?? 0;
  double get totalPnL => _portfolio?.totalProfitLoss ?? 0;
  double get totalPnLPercent => _portfolio?.totalProfitLossPercent ?? 0;

  Future<void> initialize() async {
    setBusy(true);
    await Future.wait([
      _loadPortfolio(),
      _loadIndices(),
      _loadTopGainers(),
      _loadTopLosers(),
      _loadMostActive(),
    ]);
    setBusy(false);
  }

  Future<void> _loadPortfolio() async {
    final userId = _authService.userId;
    if (userId != null) {
      _portfolio = await _portfolioService.getPortfolio(userId);
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await initialize();
  }

  Future<void> _loadIndices() async {
    _indices = await _stockService.getMarketIndices();
    notifyListeners();
  }

  Future<void> _loadTopGainers() async {
    _topGainers = await _stockService.getTopGainers(limit: 5);
    notifyListeners();
  }

  Future<void> _loadTopLosers() async {
    _topLosers = await _stockService.getTopLosers(limit: 5);
    notifyListeners();
  }

  Future<void> _loadMostActive() async {
    _mostActive = await _stockService.getMostActive(limit: 5);
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();

    switch (index) {
      case 1:
        _navigationService.navigateTo(Routes.marketView);
        break;
      case 2:
        _navigationService.navigateTo(Routes.portfolioView);
        break;
      case 3:
        _navigationService.navigateTo(Routes.watchlistView);
        break;
      case 4:
        _navigationService.navigateTo(Routes.profileView);
        break;
    }
  }

  void openSearch() {
    _navigationService.navigateTo(Routes.searchView);
  }

  void openNotifications() {
    // TODO: Implement notifications view
  }

  void navigateToMarket(String section) {
    _navigationService.navigateTo(Routes.marketView);
  }

  void openBuy() {
    _navigationService.navigateTo(Routes.searchView);
  }

  void openSell() {
    _navigationService.navigateTo(Routes.portfolioView);
  }

  void openPortfolio() {
    _navigationService.navigateTo(Routes.portfolioView);
  }

  void openWatchlist() {
    _navigationService.navigateTo(Routes.watchlistView);
  }

  void openNews() {
    _navigationService.navigateTo(Routes.newsView);
  }

  void openEducation() {
    _navigationService.navigateTo(Routes.educationView);
  }

  void openAiSuggestions() {
    _navigationService.navigateTo(Routes.aiSuggestionsView);
  }

  void openAnalysis() {
    _navigationService.navigateTo(Routes.aiSuggestionsView);
  }

  void openFunds() {
    _navigationService.navigateTo(Routes.fundView);
  }

  Future<void> openStockDetails(String symbol) async {
    await _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
    // Refresh home data when returning (user might have bought/sold)
    await refreshData();
  }
}
