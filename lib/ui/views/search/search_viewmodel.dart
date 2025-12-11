import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/stock_service.dart';
import '../../../data/models/stock_model.dart';

class SearchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _stockService = locator<StockService>();

  final searchController = TextEditingController();

  List<StockModel> _searchResults = [];
  List<StockModel> get searchResults => _searchResults;

  List<String> _recentSearches = ['RELIANCE', 'TCS', 'INFY', 'HDFCBANK'];
  List<String> get recentSearches => _recentSearches;

  List<StockModel> _trendingStocks = [];
  List<StockModel> get trendingStocks => _trendingStocks;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> initialize() async {
    setBusy(true);
    await _loadTrendingStocks();
    setBusy(false);
  }

  Future<void> _loadTrendingStocks() async {
    _trendingStocks = await _stockService.getMostActive(limit: 5);
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    _searchResults = await _stockService.searchStocks(query);
    _isSearching = false;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void addToRecentSearches(String symbol) {
    _recentSearches.remove(symbol);
    _recentSearches.insert(0, symbol);
    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.take(5).toList();
    }
    notifyListeners();
  }

  void removeFromRecentSearches(String symbol) {
    _recentSearches.remove(symbol);
    notifyListeners();
  }

  void openStockDetails(String symbol) {
    addToRecentSearches(symbol);
    _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
  }

  void goBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
