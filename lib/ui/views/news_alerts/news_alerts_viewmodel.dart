import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../data/models/news_alert_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/stock_model.dart';
import '../../../services/alert_service.dart';
import '../../../services/stock_service.dart';

class NewsAlertsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _alertService = locator<AlertService>();
  final _stockService = locator<StockService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  List<NewsAlertModel> get alerts => _alertService.newsAlerts;

  // Available categories from NewsModel
  final List<String> availableCategories = NewsCategory.categories;

  // For creating new alert
  String? _keyword;
  String? get keyword => _keyword;

  final List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  final List<String> _selectedSymbols = [];
  List<String> get selectedSymbols => _selectedSymbols;

  bool _breakingNewsOnly = false;
  bool get breakingNewsOnly => _breakingNewsOnly;

  List<StockModel> _searchResults = [];
  List<StockModel> get searchResults => _searchResults;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> initialize() async {
    setBusy(true);
    await _alertService.loadNewsAlerts();
    setBusy(false);
  }

  void setKeyword(String? value) {
    _keyword = value?.isEmpty == true ? null : value;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();

    if (query.length >= 2) {
      _searchStocks(query);
    } else {
      _searchResults = [];
      notifyListeners();
    }
  }

  Future<void> _searchStocks(String query) async {
    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _stockService.searchStocks(query);
    } catch (e) {
      _searchResults = [];
    }

    _isSearching = false;
    notifyListeners();
  }

  void addSymbol(StockModel stock) {
    if (!_selectedSymbols.contains(stock.symbol)) {
      _selectedSymbols.add(stock.symbol);
    }
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  void removeSymbol(String symbol) {
    _selectedSymbols.remove(symbol);
    notifyListeners();
  }

  void toggleBreakingNewsOnly(bool value) {
    _breakingNewsOnly = value;
    notifyListeners();
  }

  void clearForm() {
    _keyword = null;
    _selectedCategories.clear();
    _selectedSymbols.clear();
    _breakingNewsOnly = false;
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  bool get hasValidInput {
    return (_keyword != null && _keyword!.isNotEmpty) ||
        _selectedCategories.isNotEmpty ||
        _selectedSymbols.isNotEmpty ||
        _breakingNewsOnly;
  }

  Future<void> createAlert() async {
    if (!hasValidInput) {
      _snackbarService.showSnackbar(
        message: 'Please add at least one filter criteria',
      );
      return;
    }

    setBusy(true);

    final alert = await _alertService.createNewsAlert(
      keyword: _keyword,
      categories: List.from(_selectedCategories),
      symbols: List.from(_selectedSymbols),
      breakingNewsOnly: _breakingNewsOnly,
    );

    setBusy(false);

    if (alert != null) {
      _snackbarService.showSnackbar(message: 'News alert created successfully');
      clearForm();
    } else {
      _snackbarService.showSnackbar(message: 'Failed to create alert');
    }
  }

  Future<void> toggleAlertActive(String alertId, bool isActive) async {
    final success = await _alertService.toggleNewsAlertActive(alertId, isActive);
    if (success) {
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String alertId) async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Delete Alert',
      description: 'Are you sure you want to delete this news alert?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed == true) {
      final success = await _alertService.deleteNewsAlert(alertId);
      if (success) {
        _snackbarService.showSnackbar(message: 'Alert deleted');
        notifyListeners();
      }
    }
  }

  void goBack() {
    _navigationService.back();
  }
}
