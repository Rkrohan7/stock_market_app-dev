import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../services/notification_service.dart';
import '../../../core/utils/validators.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/user_model.dart';

class KycViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _notificationService = locator<NotificationService>();
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

  // Track if this is a resubmission after rejection
  bool _isResubmission = false;
  bool get isResubmission => _isResubmission;

  String? _rejectionReason;
  String? get rejectionReason => _rejectionReason;

  UserModel? _currentUser;

  bool get canProceedFromPan =>
      panController.text.length == 10 && _panError == null;

  bool get canProceedFromAadhaar =>
      aadhaarController.text.length == 12 && _aadhaarError == null;

  // Selfie is now mandatory - can only proceed if selfie is captured
  bool get canProceedFromSelfie => _selfieUrl != null;

  // Can submit only if all fields are filled including selfie
  bool get canSubmit =>
      panController.text.length == 10 &&
      aadhaarController.text.length == 12 &&
      _selfieUrl != null;

  Future<void> initialize() async {
    setBusy(true);
    try {
      final userId = _authService.userId;
      if (userId != null) {
        _currentUser = await _userService.getUserById(userId);
        if (_currentUser != null && _currentUser!.kycStatus == KycStatus.rejected) {
          _isResubmission = true;
          _rejectionReason = _currentUser!.rejectionReason;
        }
      }
    } catch (e) {
      // Ignore errors during initialization
    }
    setBusy(false);
  }

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
    // Validate before moving to next step
    if (_currentStep == 2 && _selfieUrl == null) {
      _snackbarService.showSnackbar(
        message: 'Please capture your selfie to continue',
        duration: const Duration(seconds: 2),
      );
      return;
    }

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

  void retakeSelfie() {
    _selfieUrl = null;
    notifyListeners();
  }

  Future<void> submitKyc() async {
    // Validate selfie before submission
    if (_selfieUrl == null) {
      _snackbarService.showSnackbar(
        message: 'Selfie is mandatory. Please capture your selfie.',
        duration: const Duration(seconds: 3),
      );
      return;
    }

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

      // Show KYC submitted notification
      await _notificationService.showKycSubmittedNotification();

      _snackbarService.showSnackbar(
        message: _isResubmission
            ? 'KYC resubmitted successfully! Under review.'
            : 'KYC submitted successfully! Under review.',
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

  @override
  void dispose() {
    panController.dispose();
    aadhaarController.dispose();
    super.dispose();
  }
}
