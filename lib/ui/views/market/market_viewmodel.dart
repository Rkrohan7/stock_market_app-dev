import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/stock_service.dart';
import '../../../data/models/stock_model.dart';

class MarketViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _stockService = locator<StockService>();

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  List<StockModel> _allStocks = [];
  List<StockModel> get allStocks => _allStocks;

  List<StockModel> _topGainers = [];
  List<StockModel> get topGainers => _topGainers;

  List<StockModel> _topLosers = [];
  List<StockModel> get topLosers => _topLosers;

  List<StockModel> _mostActive = [];
  List<StockModel> get mostActive => _mostActive;

  Future<void> initialize() async {
    setBusy(true);
    await Future.wait([
      _loadAllStocks(),
      _loadTopGainers(),
      _loadTopLosers(),
      _loadMostActive(),
    ]);
    setBusy(false);
  }

  Future<void> refreshData() async {
    await initialize();
  }

  Future<void> _loadAllStocks() async {
    _allStocks = await _stockService.getAllStocks();
    notifyListeners();
  }

  Future<void> _loadTopGainers() async {
    _topGainers = await _stockService.getTopGainers(limit: 20);
    notifyListeners();
  }

  Future<void> _loadTopLosers() async {
    _topLosers = await _stockService.getTopLosers(limit: 20);
    notifyListeners();
  }

  Future<void> _loadMostActive() async {
    _mostActive = await _stockService.getMostActive(limit: 20);
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void openStockDetails(String symbol) {
    _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
  }
}
