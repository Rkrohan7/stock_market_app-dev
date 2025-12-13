import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../data/models/education_model.dart';

class BlogDetailViewModel extends BaseViewModel {
  final BlogModel blog;
  final _snackbarService = locator<SnackbarService>();

  BlogDetailViewModel({required this.blog});

  bool _isBookmarked = false;
  bool get isBookmarked => _isBookmarked;

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    _snackbarService.showSnackbar(
      message: _isBookmarked ? 'Blog bookmarked!' : 'Bookmark removed',
      duration: const Duration(seconds: 2),
    );
    notifyListeners();
  }

  Future<void> shareBlog() async {
    final shareText = '${blog.title}\n\n${blog.summary}\n\nRead more about trading!';
    await Clipboard.setData(ClipboardData(text: shareText));
    _snackbarService.showSnackbar(
      message: 'Blog link copied to clipboard!',
      duration: const Duration(seconds: 2),
    );
  }
}
