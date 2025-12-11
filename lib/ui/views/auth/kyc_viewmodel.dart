import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../core/utils/validators.dart';

class KycViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _snackbarService = locator<SnackbarService>();

  final panController = TextEditingController();
  final aadhaarController = TextEditingController();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  String? _panError;
  String? get panError => _panError;

  String? _aadhaarError;
  String? get aadhaarError => _aadhaarError;

  String? _selfieUrl;
  String? get selfieUrl => _selfieUrl;

  bool get canProceedFromPan =>
      panController.text.length == 10 && _panError == null;

  bool get canProceedFromAadhaar =>
      aadhaarController.text.length == 12 && _aadhaarError == null;

  void validatePan() {
    final pan = panController.text;
    if (pan.isEmpty) {
      _panError = null;
    } else if (pan.length == 10) {
      _panError = Validators.validatePan(pan);
    } else {
      _panError = null;
    }
    notifyListeners();
  }

  void validateAadhaar() {
    final aadhaar = aadhaarController.text;
    if (aadhaar.isEmpty) {
      _aadhaarError = null;
    } else if (aadhaar.length == 12) {
      _aadhaarError = Validators.validateAadhaar(aadhaar);
    } else {
      _aadhaarError = null;
    }
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void takeSelfie() {
    // Demo: Set a placeholder URL
    _selfieUrl = 'https://ui-avatars.com/api/?name=User&background=6C5CE7&color=fff&size=200';
    notifyListeners();

    _snackbarService.showSnackbar(
      message: 'Selfie captured successfully!',
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> submitKyc() async {
    setBusy(true);

    try {
      final userId = _authService.userId;
      if (userId == null) throw Exception('User not logged in');

      await _userService.submitKyc(
        odersId: userId,
        panNumber: panController.text,
        aadhaarNumber: aadhaarController.text,
        selfieUrl: _selfieUrl,
      );

      _snackbarService.showSnackbar(
        message: 'KYC submitted successfully! Under review.',
        duration: const Duration(seconds: 3),
      );

      await _navigationService.clearStackAndShow(Routes.homeView);
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to submit KYC. Please try again.',
        duration: const Duration(seconds: 3),
      );
    } finally {
      setBusy(false);
    }
  }

  void skipKyc() {
    _navigationService.clearStackAndShow(Routes.homeView);
  }

  @override
  void dispose() {
    panController.dispose();
    aadhaarController.dispose();
    super.dispose();
  }
}
