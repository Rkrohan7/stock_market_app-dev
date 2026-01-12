import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  Future<void> signInWithGoogle() async {
    setBusy(true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        // All users go directly to home after login
        await _navigationService.clearStackAndShow(Routes.homeView);
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
