import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../app/app.locator.dart';
import '../../../services/fund_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/razorpay_service.dart';
import '../../../data/models/fund_transaction_model.dart';
import '../../../core/enums/enums.dart';

class FundViewModel extends BaseViewModel {
  final _fundService = locator<FundService>();
  final _authService = locator<AuthService>();
  final _razorpayService = locator<RazorpayService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  double _walletBalance = 0;
  double get walletBalance => _walletBalance;

  List<FundTransactionModel> _transactions = [];
  List<FundTransactionModel> get transactions => _transactions;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.upi;
  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;

  String _amount = '';
  String get amount => _amount;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  StreamSubscription<double>? _balanceSubscription;
  StreamSubscription<List<FundTransactionModel>>? _transactionsSubscription;

  String? get userId => _authService.currentUser?.uid;
  String? get userEmail => _authService.currentUser?.email;
  String? get userName => _authService.currentUser?.displayName;
  String? get userPhone => _authService.currentUser?.phoneNumber;

  // Current pending transaction for Razorpay
  FundTransactionModel? _pendingTransaction;

  Future<void> initialize() async {
    setBusy(true);
    _initializeRazorpay();
    await _loadData();
    _setupStreams();
    setBusy(false);
  }

  void _initializeRazorpay() {
    _razorpayService.initialize(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_pendingTransaction != null && userId != null) {
      await _fundService.completeDeposit(
        transactionId: _pendingTransaction!.id,
        userId: userId!,
        amount: _pendingTransaction!.amount,
        razorpayPaymentId: response.paymentId,
      );

      _snackbarService.showSnackbar(
        message: 'Payment successful! Rs. ${_pendingTransaction!.amount.toStringAsFixed(2)} added to wallet.',
        duration: const Duration(seconds: 3),
      );

      _pendingTransaction = null;
      _amount = '';
      _isProcessing = false;
      notifyListeners();

      // Wait a moment for the balance to update in real-time, then navigate back
      await Future.delayed(const Duration(milliseconds: 500));
      _navigationService.back();
    }
  }

  void _handlePaymentFailure(PaymentFailureResponse response) async {
    if (_pendingTransaction != null) {
      await _fundService.failDeposit(
        transactionId: _pendingTransaction!.id,
        reason: '${response.code}: ${response.message}',
      );
    }

    _snackbarService.showSnackbar(
      message: 'Payment failed: ${response.message ?? 'Unknown error'}',
      duration: const Duration(seconds: 3),
    );

    _pendingTransaction = null;
    _isProcessing = false;
    notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _snackbarService.showSnackbar(
      message: 'External wallet selected: ${response.walletName}',
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _loadData() async {
    if (userId == null) return;

    _walletBalance = await _fundService.getWalletBalance(userId!);
    _transactions = await _fundService.getTransactionHistory(userId!);
    notifyListeners();
  }

  void _setupStreams() {
    if (userId == null) return;

    _balanceSubscription = _fundService.streamWalletBalance(userId!).listen((balance) {
      _walletBalance = balance;
      notifyListeners();
    });

    _transactionsSubscription = _fundService.streamTransactionHistory(userId!).listen((transactions) {
      _transactions = transactions;
      notifyListeners();
    });
  }

  void setAmount(String value) {
    _amount = value;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  double? get parsedAmount {
    if (_amount.isEmpty) return null;
    return double.tryParse(_amount);
  }

  bool get canProceed {
    final amt = parsedAmount;
    return amt != null && amt > 0;
  }

  bool get canWithdraw {
    final amt = parsedAmount;
    return amt != null && amt > 0 && amt <= _walletBalance;
  }

  /// Add funds using Razorpay payment gateway
  Future<void> addFunds() async {
    if (!canProceed || userId == null) return;

    _isProcessing = true;
    notifyListeners();

    try {
      // Create a pending transaction in Firestore
      _pendingTransaction = await _fundService.createPendingDeposit(
        userId: userId!,
        amount: parsedAmount!,
        paymentMethod: _selectedPaymentMethod,
      );

      // Open Razorpay checkout
      _razorpayService.openCheckout(
        amount: parsedAmount!,
        userName: userName ?? 'User',
        userEmail: userEmail ?? 'user@example.com',
        userPhone: userPhone ?? '9999999999',
        transactionId: _pendingTransaction!.id,
        userId: userId!,
        description: 'Add Funds to Trading Wallet',
      );
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      _snackbarService.showSnackbar(
        message: 'Failed to initiate payment: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Add funds without Razorpay (for demo/testing)
  Future<void> addFundsDemo() async {
    if (!canProceed || userId == null) return;

    _isProcessing = true;
    notifyListeners();

    try {
      await _fundService.addFundsDemo(
        userId: userId!,
        amount: parsedAmount!,
        paymentMethod: _selectedPaymentMethod,
      );

      _snackbarService.showSnackbar(
        message: 'Funds added successfully!',
        duration: const Duration(seconds: 2),
      );

      _amount = '';
      _navigationService.back();
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to add funds: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> withdrawFunds() async {
    if (!canWithdraw || userId == null) return;

    // Confirm withdrawal
    final result = await _dialogService.showConfirmationDialog(
      title: 'Confirm Withdrawal',
      description: 'Are you sure you want to withdraw Rs. ${parsedAmount!.toStringAsFixed(2)}?',
      confirmationTitle: 'Withdraw',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed != true) return;

    _isProcessing = true;
    notifyListeners();

    try {
      await _fundService.withdrawFunds(
        userId: userId!,
        amount: parsedAmount!,
        paymentMethod: _selectedPaymentMethod,
      );

      _snackbarService.showSnackbar(
        message: 'Withdrawal successful!',
        duration: const Duration(seconds: 2),
      );

      _amount = '';
      _navigationService.back();
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to withdraw: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void setQuickAmount(double value) {
    _amount = value.toStringAsFixed(0);
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    _balanceSubscription?.cancel();
    _transactionsSubscription?.cancel();
    _razorpayService.dispose();
    super.dispose();
  }
}
