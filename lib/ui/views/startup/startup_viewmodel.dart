import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/user_model.dart';

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
      // Try to fetch user data first (to check Firestore `isAdmin` flag)
      final userId = _authService.userId;
      UserModel? user;
      if (userId != null) {
        try {
          user = await _userService.getUserById(userId);
        } catch (e) {
          user = null;
        }
      }

      // Admin users bypass KYC - check both auth email and Firestore flag
      final bool isAdmin = _authService.isAdmin || (user?.isAdmin ?? false);
      if (isAdmin) {
        await _navigationService.replaceWith(Routes.homeView);
        return;
      }

      // If we have user data, use it to decide KYC routing
      if (user != null) {
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
        // User data not found - fallback to auth-only check
        // If auth says admin, go home, otherwise go to KYC
        if (_authService.isAdmin) {
          await _navigationService.replaceWith(Routes.homeView);
        } else {
          await _navigationService.replaceWith(Routes.kycView);
        }
      }
    } else {
      // Navigate to login
      await _navigationService.replaceWith(Routes.loginView);
    }
  }
}
