import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../core/enums/enums.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _snackbarService = locator<SnackbarService>();

  Future<void> signInWithGoogle() async {
    setBusy(true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        // Get user data to check KYC status
        final user = await _userService.getUserById(userCredential.user!.uid);

        if (user != null) {
          // Check if user needs to complete KYC (first time or rejected)
          if (user.kycStatus == KycStatus.pending) {
            // First time user or KYC not started - redirect to KYC
            await _navigationService.clearStackAndShow(Routes.kycView);
          } else if (user.kycStatus == KycStatus.rejected) {
            // KYC was rejected - redirect to KYC for resubmission
            await _navigationService.clearStackAndShow(Routes.kycView);
          } else {
            // KYC submitted or verified - go to home
            await _navigationService.clearStackAndShow(Routes.homeView);
          }
        } else {
          // New user - redirect to KYC
          await _navigationService.clearStackAndShow(Routes.kycView);
        }
      } else {
        // User cancelled sign-in
        _snackbarService.showSnackbar(
          message: 'Sign in cancelled',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to sign in with Google. Please try again.',
        duration: const Duration(seconds: 3),
      );
    } finally {
      setBusy(false);
    }
  }
}
