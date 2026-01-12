import 'package:fl_chart/fl_chart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/portfolio_service.dart';
import '../../../services/stock_service.dart';
import '../../../services/order_service.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../data/models/order_model.dart';

class PortfolioViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _portfolioService = locator<PortfolioService>();
  final _stockService = locator<StockService>();
  final _orderService = locator<OrderService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  PortfolioModel? _portfolio;
  PortfolioModel? get portfolio => _portfolio;

  List<HoldingModel> _holdings = [];
  List<HoldingModel> get holdings => _holdings;

  List<OrderModel> _recentOrders = [];
  List<OrderModel> get recentOrders => _recentOrders;

  double get currentValue => _holdings.fold(0, (sum, h) => sum + h.currentValue);
  double get totalInvestment => _holdings.fold(0, (sum, h) => sum + h.investedValue);
  double get totalPnL => currentValue - totalInvestment;
  double get totalPnLPercent => totalInvestment > 0 ? (totalPnL / totalInvestment) * 100 : 0;

  List<FlSpot> _chartData = [];
  List<FlSpot> get chartData => _chartData;

  Future<void> initialize() async {
    setBusy(true);
    await _loadPortfolio();
    await _loadRecentOrders();
    _generateChartData();
    setBusy(false);
  }

  Future<void> refreshData() async {
    await _loadPortfolio();
    await _loadRecentOrders();
    _generateChartData();
    notifyListeners();
  }

  Future<void> _loadPortfolio() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      // Load portfolio from Firebase
      _portfolio = await _portfolioService.getPortfolio(userId);
      _holdings = _portfolio?.holdings ?? [];

      // Update prices from live API
      await _updateHoldingPrices();
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to load portfolio');
    }
    notifyListeners();
  }

  // Update holding prices from live market data
  Future<void> _updateHoldingPrices() async {
    if (_holdings.isEmpty) return;

    try {
      final stocks = await _stockService.getAllStocks();
      final priceMap = <String, double>{};

      for (final stock in stocks) {
        priceMap[stock.symbol] = stock.currentPrice;
      }

      // Update holdings with live prices
      final updatedHoldings = _holdings.map((holding) {
        final livePrice = priceMap[holding.symbol];
        if (livePrice != null) {
          return holding.copyWith(currentPrice: livePrice);
        }
        return holding;
      }).toList();

      _holdings = updatedHoldings;

      // Update prices in Firebase
      final userId = _authService.userId;
      if (userId != null) {
        await _portfolioService.updateHoldingPrices(userId, priceMap);
      }
    } catch (e) {
      // Keep existing prices on error
    }
  }

  // Load recent orders from Firebase
  Future<void> _loadRecentOrders() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      _recentOrders = await _orderService.getOrderHistory(userId, limit: 10);
    } catch (e) {
      // Ignore errors
    }
  }

  void _generateChartData() {
    if (_holdings.isEmpty) {
      // Show demo/placeholder chart for empty portfolio
      _chartData = List.generate(30, (index) {
        // Generate a flat line at 50000 (starting balance)
        return FlSpot(index.toDouble(), 50000.0);
      });
      return;
    }

    // Generate chart data based on portfolio value history
    // For now, we'll simulate a smooth transition from investment to current value
    if (totalInvestment == 0) {
      _chartData = [];
      return;
    }

    _chartData = List.generate(30, (index) {
      final progress = index / 29; // 0 to 1
      final value = totalInvestment + (progress * (currentValue - totalInvestment));
      return FlSpot(index.toDouble(), value);
    });
  }

  void openOrderHistory() {
    // TODO: Navigate to order history when view is created
    _snackbarService.showSnackbar(message: 'Order history coming soon');
  }

  void startInvesting() {
    _navigationService.navigateTo(Routes.searchView);
  }

  Future<void> openStockDetails(String symbol) async {
    await _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
    // Refresh portfolio when returning
    await refreshData();
  }

  // Sell holding
  Future<void> sellHolding(HoldingModel holding) async {
    await _navigationService.navigateTo(
      Routes.tradingView,
      arguments: TradingViewArguments(symbol: holding.symbol, isBuy: false),
    );
    // Refresh portfolio after trade
    await refreshData();
  }

  // Buy more of existing holding
  Future<void> buyMore(String symbol) async {
    await _navigationService.navigateTo(
      Routes.tradingView,
      arguments: TradingViewArguments(symbol: symbol, isBuy: true),
    );
    // Refresh portfolio after trade
    await refreshData();
  }
}
