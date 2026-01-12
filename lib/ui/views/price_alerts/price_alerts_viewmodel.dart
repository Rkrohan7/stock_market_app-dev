import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../data/models/alert_model.dart';
import '../../../data/models/stock_model.dart';
import '../../../core/enums/enums.dart';
import '../../../services/alert_service.dart';
import '../../../services/stock_service.dart';

class PriceAlertsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _alertService = locator<AlertService>();
  final _stockService = locator<StockService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  List<AlertModel> get alerts => _alertService.priceAlerts;
  List<AlertModel> get activeAlerts =>
      alerts.where((a) => a.isActive && !a.isTriggered).toList();
  List<AlertModel> get triggeredAlerts =>
      alerts.where((a) => a.isTriggered).toList();

  List<StockModel> _searchResults = [];
  List<StockModel> get searchResults => _searchResults;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  // For creating new alert
  StockModel? _selectedStock;
  StockModel? get selectedStock => _selectedStock;

  AlertType _selectedAlertType = AlertType.priceAbove;
  AlertType get selectedAlertType => _selectedAlertType;

  double _targetValue = 0;
  double get targetValue => _targetValue;

  Future<void> initialize() async {
    setBusy(true);
    await _alertService.loadPriceAlerts();
    setBusy(false);
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

  void selectStock(StockModel stock) {
    _selectedStock = stock;
    _targetValue = stock.currentPrice;
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  void clearSelectedStock() {
    _selectedStock = null;
    _targetValue = 0;
    notifyListeners();
  }

  void setAlertType(AlertType type) {
    _selectedAlertType = type;
    notifyListeners();
  }

  void setTargetValue(double value) {
    _targetValue = value;
    notifyListeners();
  }

  Future<void> createAlert() async {
    if (_selectedStock == null) {
      _snackbarService.showSnackbar(message: 'Please select a stock');
      return;
    }

    if (_targetValue <= 0) {
      _snackbarService.showSnackbar(message: 'Please enter a valid target value');
      return;
    }

    setBusy(true);

    final alert = await _alertService.createPriceAlert(
      symbol: _selectedStock!.symbol,
      stockName: _selectedStock!.name,
      alertType: _selectedAlertType,
      targetValue: _targetValue,
      currentValue: _selectedStock!.currentPrice,
    );

    setBusy(false);

    if (alert != null) {
      _snackbarService.showSnackbar(message: 'Price alert created successfully');
      clearSelectedStock();
      notifyListeners();
    } else {
      _snackbarService.showSnackbar(message: 'Failed to create alert');
    }
  }

  Future<void> toggleAlertActive(String alertId, bool isActive) async {
    final success = await _alertService.togglePriceAlertActive(alertId, isActive);
    if (success) {
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String alertId) async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Delete Alert',
      description: 'Are you sure you want to delete this alert?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed == true) {
      final success = await _alertService.deletePriceAlert(alertId);
      if (success) {
        _snackbarService.showSnackbar(message: 'Alert deleted');
        notifyListeners();
      }
    }
  }

  Future<void> clearTriggeredAlerts() async {
    final triggeredIds = triggeredAlerts.map((a) => a.id).toList();
    for (final id in triggeredIds) {
      await _alertService.deletePriceAlert(id);
    }
    notifyListeners();
    _snackbarService.showSnackbar(message: 'Triggered alerts cleared');
  }

  String getAlertTypeDescription(AlertType type) {
    switch (type) {
      case AlertType.priceAbove:
        return 'Notify when price goes above';
      case AlertType.priceBelow:
        return 'Notify when price goes below';
      case AlertType.percentageChange:
        return 'Notify on percentage change';
      case AlertType.volume:
        return 'Notify when volume exceeds';
    }
  }

  void goBack() {
    _navigationService.back();
  }
}
