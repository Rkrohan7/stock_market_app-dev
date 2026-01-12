import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/connectivity_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _themeService = locator<ThemeService>();
  final _connectivityService = locator<ConnectivityService>();

  Future<void> initialize() async {
    // Initialize services
    await _themeService.initialize();
    await _connectivityService.initialize();

    // Simulate loading time for splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    if (_authService.isLoggedIn) {
      // All users go directly to home - KYC is now optional
      await _navigationService.replaceWith(Routes.homeView);
    } else {
      // Navigate to login
      await _navigationService.replaceWith(Routes.loginView);
    }
  }
}
