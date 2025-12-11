import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../services/education_service.dart';
import '../../../data/models/education_model.dart';

class EducationViewModel extends BaseViewModel {
  final _educationService = locator<EducationService>();
  final _navigationService = locator<NavigationService>();

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  List<Course> _featuredCourses = [];
  List<Course> get featuredCourses => _featuredCourses;

  String _selectedLevel = 'All';
  String get selectedLevel => _selectedLevel;

  final List<String> levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  Future<void> initialize() async {
    setBusy(true);
    await _loadCourses();
    setBusy(false);
  }

  Future<void> _loadCourses() async {
    _courses = await _educationService.getAllCourses();
    _featuredCourses = _courses.where((c) => c.isFeatured).toList();
    notifyListeners();
  }

  void setLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  List<Course> get filteredCourses {
    if (_selectedLevel == 'All') return _courses;
    return _courses.where((c) => c.level == _selectedLevel).toList();
  }

  void openCourse(Course course) {
    // Navigate to course detail
  }
}
