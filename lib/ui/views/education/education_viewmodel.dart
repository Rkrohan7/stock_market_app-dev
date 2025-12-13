import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/education_service.dart';
import '../../../data/models/education_model.dart';

class EducationViewModel extends BaseViewModel {
  final _educationService = locator<EducationService>();
  final _navigationService = locator<NavigationService>();

  List<BlogModel> _blogs = [];
  List<BlogModel> get blogs => _blogs;

  List<BlogModel> _featuredBlogs = [];
  List<BlogModel> get featuredBlogs => _featuredBlogs;

  String _selectedLevel = 'All';
  String get selectedLevel => _selectedLevel;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  List<String> _categories = ['All'];
  List<String> get categories => _categories;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> initialize() async {
    setBusy(true);
    await _loadBlogs();
    setBusy(false);
  }

  Future<void> _loadBlogs() async {
    _blogs = await _educationService.getAllBlogs();
    _featuredBlogs = _blogs.where((b) => b.isFeatured).toList();
    _categories = ['All', ..._educationService.getBlogCategories()];
    notifyListeners();
  }

  void setLevel(String level) {
    _selectedLevel = level;
    _selectedCategory = 'All';
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<BlogModel> get filteredBlogs {
    var filtered = _blogs;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((blog) {
        return blog.title.toLowerCase().contains(lowerQuery) ||
            blog.summary.toLowerCase().contains(lowerQuery) ||
            blog.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    }

    // Filter by level
    if (_selectedLevel != 'All') {
      filtered = filtered.where((b) => b.level == _selectedLevel).toList();
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((b) => b.category == _selectedCategory).toList();
    }

    // Sort by published date (newest first)
    filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return filtered;
  }

  List<String> get availableCategories {
    if (_selectedLevel == 'All') {
      return _categories;
    }
    final levelBlogs = _blogs.where((b) => b.level == _selectedLevel);
    final levelCategories = levelBlogs.map((b) => b.category).toSet().toList();
    return ['All', ...levelCategories];
  }

  void openBlog(BlogModel blog) {
    _navigationService.navigateTo(
      Routes.blogDetailView,
      arguments: BlogDetailViewArguments(blog: blog),
    );
  }

  Future<void> refresh() async {
    await _loadBlogs();
  }
}
