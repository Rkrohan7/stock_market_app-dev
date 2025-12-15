import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../data/models/user_model.dart';

class AdminVerificationViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  List<UserModel> _pendingUsers = [];
  List<UserModel> get pendingUsers => _pendingUsers;

  StreamSubscription<List<UserModel>>? _usersSubscription;

  bool get isAdmin => _authService.isAdmin;
  String? get adminId => _authService.userId;

  Future<void> initialize() async {
    if (!isAdmin) {
      _snackbarService.showSnackbar(
        message: 'You do not have admin access',
        duration: const Duration(seconds: 3),
      );
      _navigationService.back();
      return;
    }

    setBusy(true);
    _setupStream();
    setBusy(false);
  }

  void _setupStream() {
    _usersSubscription = _userService.streamPendingVerificationUsers().listen(
      (users) {
        _pendingUsers = users;
        notifyListeners();
      },
      onError: (error) {
        _snackbarService.showSnackbar(
          message: 'Error loading pending users: $error',
          duration: const Duration(seconds: 3),
        );
        print('Error loading pending users: $error');
      },
    );
  }

  Future<void> verifyUser(UserModel user) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Verify User',
      description:
          'Are you sure you want to verify ${user.displayName ?? user.email}?\n\nThis will allow the user to buy and sell stocks.',
      confirmationTitle: 'Verify',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed ?? false) {
      try {
        await _userService.verifyUser(userId: user.uid, adminId: adminId!);
        _snackbarService.showSnackbar(
          message: '${user.displayName ?? user.email} has been verified',
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        _snackbarService.showSnackbar(
          message: 'Failed to verify user: $e',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> rejectUser(UserModel user) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Reject User',
      description:
          'Are you sure you want to reject ${user.displayName ?? user.email}?\n\nThe user will not be able to trade.',
      confirmationTitle: 'Reject',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed ?? false) {
      try {
        await _userService.rejectUserVerification(
          userId: user.uid,
          reason: 'Rejected by admin',
        );
        _snackbarService.showSnackbar(
          message: '${user.displayName ?? user.email} has been rejected',
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        _snackbarService.showSnackbar(
          message: 'Failed to reject user: $e',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void goBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }
}
