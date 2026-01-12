import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/enums/enums.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Razorpay API credentials - Get from https://dashboard.razorpay.com/app/keys
  static const String _keyId = 'rzp_test_Rq72xNPez55mbO'; // Test key
  static const String _keySecret = 'm8xaorSpn4j3CG2IUb5165NU'; // Test secret
  // static const String _keyId = 'rzp_live_YOUR_KEY_ID'; // Live key (for production)
  // static const String _keySecret = 'YOUR_LIVE_KEY_SECRET'; // Live secret (for production)

  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onFailure;
  Function(ExternalWalletResponse)? _onExternalWallet;

  String? _currentTransactionId;
  String? _currentUserId;

  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onExternalWallet = onExternalWallet;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Update transaction in Firestore
    if (_currentTransactionId != null) {
      _updateTransactionStatus(
        _currentTransactionId!,
        FundTransactionStatus.completed,
        razorpayPaymentId: response.paymentId,
        razorpayOrderId: response.orderId,
        razorpaySignature: response.signature,
      );
    }
    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Update transaction in Firestore
    if (_currentTransactionId != null) {
      _updateTransactionStatus(
        _currentTransactionId!,
        FundTransactionStatus.failed,
        failureReason: '${response.code}: ${response.message}',
      );
    }
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onExternalWallet?.call(response);
  }

  Future<void> _updateTransactionStatus(
    String transactionId,
    FundTransactionStatus status, {
    String? razorpayPaymentId,
    String? razorpayOrderId,
    String? razorpaySignature,
    String? failureReason,
  }) async {
    final updateData = <String, dynamic>{'status': status.name};

    if (razorpayPaymentId != null) {
      updateData['razorpayPaymentId'] = razorpayPaymentId;
      updateData['referenceId'] = razorpayPaymentId;
      updateData['completedAt'] = Timestamp.now();
    }
    if (razorpayOrderId != null) {
      updateData['razorpayOrderId'] = razorpayOrderId;
    }
    if (razorpaySignature != null) {
      updateData['razorpaySignature'] = razorpaySignature;
    }
    if (failureReason != null) {
      updateData['failureReason'] = failureReason;
    }

    await _firestore
        .collection('fundTransactions')
        .doc(transactionId)
        .update(updateData);

    // If payment successful, update wallet balance
    if (status == FundTransactionStatus.completed && _currentUserId != null) {
      final transactionDoc = await _firestore
          .collection('fundTransactions')
          .doc(transactionId)
          .get();

      if (transactionDoc.exists) {
        final amount =
            (transactionDoc.data()?['amount'] as num?)?.toDouble() ?? 0;
        final type = transactionDoc.data()?['type'] as String?;

        if (type == FundTransactionType.deposit.name) {
          await _firestore.collection('users').doc(_currentUserId).update({
            'walletBalance': FieldValue.increment(amount),
            'updatedAt': Timestamp.now(),
          });
        }
      }
    }
  }

  /// Open Razorpay checkout for adding funds
  void openCheckout({
    required double amount,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String transactionId,
    required String userId,
    String? description,
  }) {
    _currentTransactionId = transactionId;
    _currentUserId = userId;

    // Amount should be in paise (multiply by 100)
    final amountInPaise = (amount * 100).toInt();

    var options = {
      'key': _keyId,
      'amount': amountInPaise,
      'name': 'Stock Trading App',
      'description': description ?? 'Add Funds to Wallet',
      'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
      'theme': {'color': '#6C5CE7'},
      'notes': {'transaction_id': transactionId, 'user_id': userId},
      // Uncomment to restrict payment methods
      // 'method': {
      //   'upi': true,
      //   'card': true,
      //   'netbanking': true,
      //   'wallet': true,
      // },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _onFailure?.call(
        PaymentFailureResponse(
          Razorpay.UNKNOWN_ERROR,
          'Failed to open Razorpay: $e',
          null,
        ),
      );
    }
  }

  /// Get the key secret (for server-side verification if needed)
  static String get keySecret => _keySecret;

  /// Create a Razorpay order (for server-side order creation)
  /// Note: In production, orders should be created on your backend server
  /// This is a placeholder for the order creation flow
  Future<String?> createOrder({
    required double amount,
    required String receipt,
  }) async {
    // In production, make an API call to your backend server
    // which will create an order using Razorpay Orders API
    // and return the order_id

    // For now, return null (will use auto-capture mode)
    return null;
  }

  void dispose() {
    _razorpay.clear();
  }
}

/// Extension to create PaymentFailureResponse for internal errors
extension PaymentFailureResponseExtension on PaymentFailureResponse {
  static PaymentFailureResponse create(int code, String message) {
    return PaymentFailureResponse(code, message, null);
  }
}
