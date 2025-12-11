import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../services/news_service.dart';
import '../../../data/models/news_model.dart';

class NewsViewModel extends BaseViewModel {
  final _newsService = locator<NewsService>();

  List<NewsArticle> _newsArticles = [];
  List<NewsArticle> get newsArticles => _newsArticles;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Market', 'Stocks', 'Economy', 'IPO', 'Crypto'];

  Future<void> initialize() async {
    setBusy(true);
    await _loadNews();
    setBusy(false);
  }

  Future<void> refreshData() async {
    await _loadNews();
    notifyListeners();
  }

  Future<void> _loadNews() async {
    _newsArticles = await _newsService.getLatestNews(limit: 30);
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<NewsArticle> get filteredNews {
    if (_selectedCategory == 'All') return _newsArticles;
    return _newsArticles.where((n) => n.category == _selectedCategory).toList();
  }

  void openArticle(NewsArticle article) {
    // In production, open article URL or detail view
  }
}
