import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/watchlist_service.dart';
import '../../../services/stock_service.dart';
import '../../../data/models/watchlist_model.dart';

class WatchlistViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _watchlistService = locator<WatchlistService>();
  final _stockService = locator<StockService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  List<WatchlistItem> _watchlistItems = [];
  List<WatchlistItem> get watchlistItems => _watchlistItems;

  WatchlistModel? _currentWatchlist;
  WatchlistModel? get currentWatchlist => _currentWatchlist;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  Future<void> initialize() async {
    setBusy(true);
    await _loadWatchlist();
    setBusy(false);
  }

  Future<void> refreshData() async {
    await _loadWatchlist();
    notifyListeners();
  }

  Future<void> _loadWatchlist() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      // Get or create default watchlist from Firebase
      _currentWatchlist = await _watchlistService.getOrCreateDefaultWatchlist(userId);
      _watchlistItems = _currentWatchlist?.items ?? [];

      // Update prices from live API
      await _updatePricesFromApi();
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to load watchlist');
    }
    notifyListeners();
  }

  // Update watchlist items with live prices
  Future<void> _updatePricesFromApi() async {
    if (_watchlistItems.isEmpty) return;

    try {
      final stocks = await _stockService.getAllStocks();
      final updatedItems = <WatchlistItem>[];

      for (final item in _watchlistItems) {
        final stock = stocks.firstWhere(
          (s) => s.symbol == item.symbol,
          orElse: () => stocks.first,
        );

        if (stock.symbol == item.symbol) {
          updatedItems.add(item.copyWith(
            currentPrice: stock.currentPrice,
            change: stock.change,
            changePercent: stock.changePercent,
          ));
        } else {
          updatedItems.add(item);
        }
      }

      _watchlistItems = updatedItems;
    } catch (e) {
      // Keep existing prices on error
    }
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  // Add stock to watchlist
  Future<void> addToWatchlist(String symbol, String name, double price, double change, double changePercent) async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      // Get or create default watchlist
      _currentWatchlist ??= await _watchlistService.getOrCreateDefaultWatchlist(userId);

      // Check if already in watchlist
      if (_currentWatchlist!.containsStock(symbol)) {
        _snackbarService.showSnackbar(message: '$symbol is already in watchlist');
        return;
      }

      final item = WatchlistItem(
        symbol: symbol,
        name: name,
        currentPrice: price,
        change: change,
        changePercent: changePercent,
        addedAt: DateTime.now(),
      );

      // Add to Firebase
      await _watchlistService.addToWatchlist(_currentWatchlist!.id, item);

      // Update local list
      _watchlistItems.add(item);
      _snackbarService.showSnackbar(message: '$symbol added to watchlist');
      notifyListeners();
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to add to watchlist');
    }
  }

  // Remove stock from watchlist
  Future<void> removeFromWatchlist(String symbol) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Remove from Watchlist',
      description: 'Are you sure you want to remove this stock from your watchlist?',
      confirmationTitle: 'Remove',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed ?? false) {
      try {
        if (_currentWatchlist != null) {
          // Remove from Firebase
          await _watchlistService.removeFromWatchlist(_currentWatchlist!.id, symbol);
        }

        // Update local list
        _watchlistItems.removeWhere((item) => item.symbol == symbol);
        _snackbarService.showSnackbar(message: '$symbol removed from watchlist');
        notifyListeners();
      } catch (e) {
        _snackbarService.showSnackbar(message: 'Failed to remove from watchlist');
      }
    }
  }

  // Check if stock is in watchlist
  bool isInWatchlist(String symbol) {
    return _watchlistItems.any((item) => item.symbol == symbol);
  }

  Future<void> openStockDetails(String symbol) async {
    await _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
    // Refresh watchlist when returning from stock details
    await refreshData();
  }

  Future<void> openSearch() async {
    await _navigationService.navigateTo(Routes.searchView);
    // Refresh watchlist when returning from search (user might have added stocks)
    await refreshData();
  }
}
