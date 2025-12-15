import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../core/enums/enums.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
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
      // Admin users bypass KYC - go directly to home
      if (_authService.isAdmin) {
        await _navigationService.replaceWith(Routes.homeView);
        return;
      }

      // Get user data to check KYC status
      final userId = _authService.userId;
      if (userId != null) {
        final user = await _userService.getUserById(userId);

        if (user != null) {
          // Check KYC status and redirect accordingly
          if (user.kycStatus == KycStatus.pending) {
            // KYC not started - redirect to KYC
            await _navigationService.replaceWith(Routes.kycView);
          } else if (user.kycStatus == KycStatus.rejected) {
            // KYC was rejected - redirect to KYC for resubmission
            await _navigationService.replaceWith(Routes.kycView);
          } else {
            // KYC submitted or verified - go to home
            await _navigationService.replaceWith(Routes.homeView);
          }
        } else {
          // User data not found - redirect to KYC
          await _navigationService.replaceWith(Routes.kycView);
        }
      } else {
        // No user ID - navigate to login
        await _navigationService.replaceWith(Routes.loginView);
      }
    } else {
      // Navigate to login
      await _navigationService.replaceWith(Routes.loginView);
    }
  }
}
