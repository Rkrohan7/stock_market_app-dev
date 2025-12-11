import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/ai_service.dart';
import '../../../data/models/ai_model.dart';

class AiSuggestionsViewModel extends BaseViewModel {
  final _aiService = locator<AiService>();
  final _navigationService = locator<NavigationService>();

  List<StockRecommendation> _recommendations = [];
  List<StockRecommendation> get recommendations => _recommendations;

  MarketSentiment? _marketSentiment;
  MarketSentiment? get marketSentiment => _marketSentiment;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  final List<String> filters = ['All', 'Buy', 'Hold', 'Sell'];

  Future<void> initialize() async {
    setBusy(true);
    await Future.wait([
      _loadRecommendations(),
      _loadMarketSentiment(),
    ]);
    setBusy(false);
  }

  Future<void> _loadRecommendations() async {
    _recommendations = await _aiService.getStockRecommendations();
    notifyListeners();
  }

  Future<void> _loadMarketSentiment() async {
    _marketSentiment = await _aiService.getMarketSentiment();
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<StockRecommendation> get filteredRecommendations {
    if (_selectedFilter == 'All') return _recommendations;
    return _recommendations.where((r) => r.recommendation == _selectedFilter).toList();
  }

  void openStockDetails(String symbol) {
    _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
  }
}
