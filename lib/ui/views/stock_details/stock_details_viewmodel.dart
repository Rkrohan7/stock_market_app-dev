import 'package:candlesticks/candlesticks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/stock_service.dart';
import '../../../services/watchlist_service.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/stock_model.dart';
import '../../../data/models/watchlist_model.dart';
import '../../../core/enums/enums.dart';

class StockDetailsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _stockService = locator<StockService>();
  final _watchlistService = locator<WatchlistService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  final String symbol;

  StockDetailsViewModel({required this.symbol});

  StockModel? _stock;
  StockModel? get stock => _stock;

  WatchlistModel? _watchlist;

  bool _isInWatchlist = false;
  bool get isInWatchlist => _isInWatchlist;

  String _selectedTimeframe = '1D';
  String get selectedTimeframe => _selectedTimeframe;

  List<Candle> _candles = [];
  List<Candle> get candles => _candles;

  bool _isLoadingCandles = false;
  bool get isLoadingCandles => _isLoadingCandles;

  final List<String> timeframes = ['1D', '1W', '1M', '3M', '1Y'];

  Future<void> initialize() async {
    setBusy(true);
    await _loadStockDetails();
    await _checkWatchlistStatus();
    await _loadCandleData();
    setBusy(false);
  }

  Future<void> _loadStockDetails() async {
    _stock = await _stockService.getStockDetails(symbol);
    notifyListeners();
  }

  Future<void> _checkWatchlistStatus() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      _watchlist = await _watchlistService.getOrCreateDefaultWatchlist(userId);
      _isInWatchlist = _watchlist?.containsStock(symbol) ?? false;
    } catch (e) {
      _isInWatchlist = false;
    }
    notifyListeners();
  }

  ChartInterval _getIntervalFromTimeframe(String timeframe) {
    switch (timeframe) {
      case '1D':
        return ChartInterval.m5;
      case '1W':
        return ChartInterval.h1;
      case '1M':
        return ChartInterval.d1;
      case '3M':
        return ChartInterval.d1;
      case '1Y':
        return ChartInterval.w1;
      default:
        return ChartInterval.d1;
    }
  }

  Future<void> _loadCandleData() async {
    if (_stock == null) return;

    _isLoadingCandles = true;
    notifyListeners();

    try {
      final interval = _getIntervalFromTimeframe(_selectedTimeframe);
      final candleData = await _stockService.getCandleData(symbol, interval);

      // Convert CandleData to Candle (candlesticks package format)
      _candles = candleData.map((data) => Candle(
        date: data.time,
        high: data.high,
        low: data.low,
        open: data.open,
        close: data.close,
        volume: data.volume.toDouble(),
      )).toList();

      // Sort by date descending (newest first) as required by candlesticks package
      _candles.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      // Keep empty list on error
      _candles = [];
    }

    _isLoadingCandles = false;
    notifyListeners();
  }

  void setTimeframe(String timeframe) {
    _selectedTimeframe = timeframe;
    _loadCandleData();
  }

  Future<void> toggleWatchlist() async {
    if (_stock == null || _watchlist == null) return;

    try {
      if (_isInWatchlist) {
        // Remove from watchlist
        await _watchlistService.removeFromWatchlist(_watchlist!.id, symbol);
        _isInWatchlist = false;
        _snackbarService.showSnackbar(message: 'Removed from watchlist');
      } else {
        // Add to watchlist
        final item = WatchlistItem(
          symbol: _stock!.symbol,
          name: _stock!.name,
          currentPrice: _stock!.currentPrice,
          change: _stock!.change,
          changePercent: _stock!.changePercent,
          addedAt: DateTime.now(),
        );
        await _watchlistService.addToWatchlist(_watchlist!.id, item);
        _isInWatchlist = true;
        _snackbarService.showSnackbar(message: 'Added to watchlist');
      }
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to update watchlist');
    }
    notifyListeners();
  }

  Future<void> openBuyView() async {
    await _navigationService.navigateTo(
      Routes.tradingView,
      arguments: TradingViewArguments(symbol: symbol, isBuy: true),
    );
    // Refresh stock details when returning from trading view
    await _loadStockDetails();
    await _checkWatchlistStatus();
  }

  Future<void> openSellView() async {
    await _navigationService.navigateTo(
      Routes.tradingView,
      arguments: TradingViewArguments(symbol: symbol, isBuy: false),
    );
    // Refresh stock details when returning from trading view
    await _loadStockDetails();
    await _checkWatchlistStatus();
  }

  void goBack() {
    _navigationService.back();
  }
}
