import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/fund_transaction_model.dart';
import '../core/enums/enums.dart';

class FundService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _transactionsCollection = 'fundTransactions';
  static const String _usersCollection = 'users';

  /// Create a pending transaction for Razorpay payment
  /// Returns the transaction ID to be used with Razorpay checkout
  Future<FundTransactionModel> createPendingDeposit({
    required String userId,
    required double amount,
    required PaymentMethod paymentMethod,
    String? description,
  }) async {
    final docRef = _firestore.collection(_transactionsCollection).doc();

    final transaction = FundTransactionModel(
      id: docRef.id,
      userId: userId,
      type: FundTransactionType.deposit,
      amount: amount,
      paymentMethod: paymentMethod,
      status: FundTransactionStatus.pending,
      description: description ?? 'Deposit via Razorpay - ${paymentMethod.displayName}',
      createdAt: DateTime.now(),
    );

    await docRef.set(transaction.toJson());
    return transaction;
  }

  /// Mark transaction as completed and update wallet balance
  Future<void> completeDeposit({
    required String transactionId,
    required String userId,
    required double amount,
    String? razorpayPaymentId,
  }) async {
    // Update transaction status
    await _firestore.collection(_transactionsCollection).doc(transactionId).update({
      'status': FundTransactionStatus.completed.name,
      'completedAt': Timestamp.now(),
      'referenceId': razorpayPaymentId ?? 'TXN${DateTime.now().millisecondsSinceEpoch}',
    });

    // Update wallet balance
    await _updateWalletBalance(userId, amount);
  }

  /// Mark transaction as failed
  Future<void> failDeposit({
    required String transactionId,
    String? reason,
  }) async {
    await _firestore.collection(_transactionsCollection).doc(transactionId).update({
      'status': FundTransactionStatus.failed.name,
      'failureReason': reason ?? 'Payment failed',
    });
  }

  // Legacy method - Add funds without Razorpay (for testing/demo)
  Future<FundTransactionModel> addFundsDemo({
    required String userId,
    required double amount,
    required PaymentMethod paymentMethod,
    String? description,
  }) async {
    // Create transaction record
    final docRef = _firestore.collection(_transactionsCollection).doc();

    final transaction = FundTransactionModel(
      id: docRef.id,
      userId: userId,
      type: FundTransactionType.deposit,
      amount: amount,
      paymentMethod: paymentMethod,
      status: FundTransactionStatus.processing,
      description: description ?? 'Deposit via ${paymentMethod.displayName}',
      createdAt: DateTime.now(),
    );

    // Save transaction
    await docRef.set(transaction.toJson());

    // Simulate payment processing
    await _processDeposit(docRef.id, userId, amount);

    // Return updated transaction
    final updatedDoc = await docRef.get();
    return FundTransactionModel.fromJson(updatedDoc.data()!);
  }

  // Withdraw funds from wallet
  Future<FundTransactionModel> withdrawFunds({
    required String userId,
    required double amount,
    required PaymentMethod paymentMethod,
    String? description,
  }) async {
    // Check if user has sufficient balance
    final currentBalance = await getWalletBalance(userId);
    if (currentBalance < amount) {
      throw Exception('Insufficient balance. Available: $currentBalance');
    }

    // Create transaction record
    final docRef = _firestore.collection(_transactionsCollection).doc();

    final transaction = FundTransactionModel(
      id: docRef.id,
      userId: userId,
      type: FundTransactionType.withdrawal,
      amount: amount,
      paymentMethod: paymentMethod,
      status: FundTransactionStatus.processing,
      description: description ?? 'Withdrawal via ${paymentMethod.displayName}',
      createdAt: DateTime.now(),
    );

    // Save transaction
    await docRef.set(transaction.toJson());

    // Process withdrawal
    await _processWithdrawal(docRef.id, userId, amount);

    // Return updated transaction
    final updatedDoc = await docRef.get();
    return FundTransactionModel.fromJson(updatedDoc.data()!);
  }

  // Get wallet balance
  Future<double> getWalletBalance(String userId) async {
    final doc = await _firestore.collection(_usersCollection).doc(userId).get();
    if (doc.exists) {
      return (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0;
    }
    return 0;
  }

  // Update wallet balance (internal use)
  Future<void> _updateWalletBalance(String userId, double amount) async {
    await _firestore.collection(_usersCollection).doc(userId).update({
      'walletBalance': FieldValue.increment(amount),
      'updatedAt': Timestamp.now(),
    });
  }

  // Process deposit (simulate payment gateway)
  Future<void> _processDeposit(String transactionId, String userId, double amount) async {
    try {
      // Simulate payment gateway delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Update wallet balance
      await _updateWalletBalance(userId, amount);

      // Update transaction status to completed
      await _firestore.collection(_transactionsCollection).doc(transactionId).update({
        'status': FundTransactionStatus.completed.name,
        'completedAt': Timestamp.now(),
        'referenceId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
      });
    } catch (e) {
      // Mark transaction as failed
      await _firestore.collection(_transactionsCollection).doc(transactionId).update({
        'status': FundTransactionStatus.failed.name,
        'failureReason': e.toString(),
      });
      rethrow;
    }
  }

  // Process withdrawal
  Future<void> _processWithdrawal(String transactionId, String userId, double amount) async {
    try {
      // Simulate processing delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Deduct from wallet balance
      await _updateWalletBalance(userId, -amount);

      // Update transaction status to completed
      await _firestore.collection(_transactionsCollection).doc(transactionId).update({
        'status': FundTransactionStatus.completed.name,
        'completedAt': Timestamp.now(),
        'referenceId': 'WDR${DateTime.now().millisecondsSinceEpoch}',
      });
    } catch (e) {
      // Mark transaction as failed
      await _firestore.collection(_transactionsCollection).doc(transactionId).update({
        'status': FundTransactionStatus.failed.name,
        'failureReason': e.toString(),
      });
      rethrow;
    }
  }

  // Get transaction history for user
  Future<List<FundTransactionModel>> getTransactionHistory(String userId) async {
    final snapshot = await _firestore
        .collection(_transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FundTransactionModel.fromJson(doc.data()))
        .toList();
  }

  // Stream transaction history
  Stream<List<FundTransactionModel>> streamTransactionHistory(String userId) {
    return _firestore
        .collection(_transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FundTransactionModel.fromJson(doc.data()))
            .toList());
  }

  // Get single transaction
  Future<FundTransactionModel?> getTransaction(String transactionId) async {
    final doc = await _firestore
        .collection(_transactionsCollection)
        .doc(transactionId)
        .get();

    if (doc.exists) {
      return FundTransactionModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Stream wallet balance
  Stream<double> streamWalletBalance(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0;
          }
          return 0.0;
        });
  }
}
