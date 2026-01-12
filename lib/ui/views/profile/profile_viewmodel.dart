import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../data/models/user_model.dart';

class ProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _themeService = locator<ThemeService>();
  final _dialogService = locator<DialogService>();

  UserModel? _user;
  UserModel? get user => _user;

  bool get isDarkMode => _themeService.isDarkMode;

  Future<void> initialize() async {
    setBusy(true);
    await _loadUserProfile();
    setBusy(false);
  }

  Future<void> _loadUserProfile() async {
    _user = await _authService.getUserData();
    notifyListeners();
  }

  void toggleTheme() {
    _themeService.toggleTheme();
    notifyListeners();
  }

  void openSettings() {
    _navigationService.navigateTo(Routes.settingsView);
  }

  void openOrderHistory() {
    _navigationService.navigateTo(Routes.orderHistoryView);
  }

  void openFunds() {
    _navigationService.navigateTo(Routes.fundView);
  }

  void openAlerts() {
    // Navigate to alerts
  }

  void openSupport() {
    _navigationService.navigateTo(Routes.helpSupportView);
  }

  void openAbout() {
    _navigationService.navigateTo(Routes.aboutView);
  }

  Future<void> logout() async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      confirmationTitle: 'Logout',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed ?? false) {
      await _authService.signOut();
      _navigationService.clearStackAndShow(Routes.loginView);
    }
  }
}
