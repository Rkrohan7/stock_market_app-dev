import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/order_model.dart';
import '../data/models/portfolio_model.dart';
import '../core/enums/enums.dart';
import 'fund_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FundService _fundService = FundService();

  // Place new order
  Future<String> placeOrder(OrderModel order) async {
    // Calculate total cost including charges
    final charges = calculateCharges(order.totalValue, order.isBuy);
    final totalCost = order.isBuy
        ? order.totalValue + (charges['totalCharges'] ?? 0)
        : order.totalValue - (charges['totalCharges'] ?? 0);

    // For buy orders, check if user has sufficient balance
    if (order.isBuy) {
      final currentBalance = await _fundService.getWalletBalance(order.odersId);
      if (currentBalance < totalCost) {
        throw Exception(
            'Insufficient balance. You need ₹${totalCost.toStringAsFixed(2)} but have ₹${currentBalance.toStringAsFixed(2)}. Please add funds first.');
      }
    }

    final docRef = await _firestore.collection('orders').add(order.toJson());

    // Simulate order execution for demo
    await Future.delayed(const Duration(seconds: 1));

    // Update order status to executed (in production, this would be handled by broker API)
    await _firestore.collection('orders').doc(docRef.id).update({
      'id': docRef.id,
      'status': OrderStatus.executed.name,
      'executedAt': Timestamp.now(),
      'executedPrice': order.price,
      'filledQuantity': order.quantity,
    });

    // Create transaction record
    await _createTransaction(docRef.id, order);

    // Update portfolio based on order type (buy/sell)
    await _updatePortfolio(order);

    // Update wallet balance
    await _updateWalletBalance(order);

    return docRef.id;
  }

  // Update wallet balance after order execution
  Future<void> _updateWalletBalance(OrderModel order) async {
    final charges = calculateCharges(order.totalValue, order.isBuy);
    final totalCharges = charges['totalCharges'] ?? 0;

    if (order.isBuy) {
      // Deduct from wallet for buy orders
      final totalDeduction = order.totalValue + totalCharges;
      await _firestore.collection('users').doc(order.odersId).update({
        'walletBalance': FieldValue.increment(-totalDeduction),
        'updatedAt': Timestamp.now(),
      });
    } else {
      // Add to wallet for sell orders (minus charges)
      final totalCredit = order.totalValue - totalCharges;
      await _firestore.collection('users').doc(order.odersId).update({
        'walletBalance': FieldValue.increment(totalCredit),
        'updatedAt': Timestamp.now(),
      });
    }
  }

  // Update portfolio after order execution
  Future<void> _updatePortfolio(OrderModel order) async {
    final portfolioRef = _firestore.collection('portfolios').doc(order.odersId);
    final portfolioDoc = await portfolioRef.get();

    if (order.isBuy) {
      // Add holding to portfolio
      final newHolding = HoldingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        symbol: order.symbol,
        name: order.stockName,
        quantity: order.quantity,
        averagePrice: order.price,
        currentPrice: order.price,
        purchaseDate: DateTime.now(),
      );

      if (portfolioDoc.exists) {
        final existingHoldings = (portfolioDoc.data()?['holdings'] as List?) ?? [];
        final existingIndex = existingHoldings.indexWhere(
          (h) => h['symbol'] == order.symbol,
        );

        if (existingIndex >= 0) {
          // Update existing holding with average price
          final existing = HoldingModel.fromJson(existingHoldings[existingIndex]);
          final newQuantity = existing.quantity + order.quantity;
          final newAveragePrice =
              ((existing.averagePrice * existing.quantity) +
                  (order.price * order.quantity)) /
              newQuantity;

          existingHoldings[existingIndex] = existing
              .copyWith(
                quantity: newQuantity,
                averagePrice: newAveragePrice,
                currentPrice: order.price,
              )
              .toJson();

          await portfolioRef.update({
            'holdings': existingHoldings,
            'lastUpdated': Timestamp.now(),
          });
        } else {
          // Add new holding
          await portfolioRef.update({
            'holdings': FieldValue.arrayUnion([newHolding.toJson()]),
            'lastUpdated': Timestamp.now(),
          });
        }
      } else {
        // Create new portfolio
        await portfolioRef.set({
          'userId': order.odersId,
          'holdings': [newHolding.toJson()],
          'totalInvestment': newHolding.investedValue,
          'currentValue': newHolding.currentValue,
          'totalProfitLoss': 0,
          'totalProfitLossPercent': 0,
          'todayProfitLoss': 0,
          'todayProfitLossPercent': 0,
          'lastUpdated': Timestamp.now(),
        });
      }
    } else {
      // Reduce/remove holding from portfolio (SELL)
      if (portfolioDoc.exists) {
        final holdings = (portfolioDoc.data()?['holdings'] as List?) ?? [];
        final holdingIndex = holdings.indexWhere((h) => h['symbol'] == order.symbol);

        if (holdingIndex >= 0) {
          final holding = HoldingModel.fromJson(holdings[holdingIndex]);

          if (order.quantity >= holding.quantity) {
            // Remove entire holding
            holdings.removeAt(holdingIndex);
          } else {
            // Reduce quantity
            holdings[holdingIndex] = holding
                .copyWith(quantity: holding.quantity - order.quantity)
                .toJson();
          }

          await portfolioRef.update({
            'holdings': holdings,
            'lastUpdated': Timestamp.now(),
          });
        }
      }
    }

    // Recalculate portfolio totals
    await _updatePortfolioTotals(order.odersId);
  }

  // Update portfolio totals
  Future<void> _updatePortfolioTotals(String userId) async {
    final portfolioRef = _firestore.collection('portfolios').doc(userId);
    final doc = await portfolioRef.get();

    if (!doc.exists) return;

    final holdings = (doc.data()?['holdings'] as List?) ?? [];
    if (holdings.isEmpty) {
      await portfolioRef.update({
        'totalInvestment': 0,
        'currentValue': 0,
        'totalProfitLoss': 0,
        'totalProfitLossPercent': 0,
        'lastUpdated': Timestamp.now(),
      });
      return;
    }

    double totalInvestment = 0;
    double currentValue = 0;

    for (final h in holdings) {
      final holding = HoldingModel.fromJson(h);
      totalInvestment += holding.investedValue;
      currentValue += holding.currentValue;
    }

    final profitLoss = currentValue - totalInvestment;
    final profitLossPercent =
        totalInvestment > 0 ? (profitLoss / totalInvestment) * 100 : 0;

    await portfolioRef.update({
      'totalInvestment': totalInvestment,
      'currentValue': currentValue,
      'totalProfitLoss': profitLoss,
      'totalProfitLossPercent': profitLossPercent,
      'lastUpdated': Timestamp.now(),
    });
  }

  // Create transaction record
  Future<void> _createTransaction(String orderId, OrderModel order) async {
    final brokerage = order.totalValue * 0.0003; // 0.03% brokerage
    final taxes = order.totalValue * 0.001; // 0.1% taxes (simplified)
    final netValue = order.isBuy
        ? order.totalValue + brokerage + taxes
        : order.totalValue - brokerage - taxes;

    await _firestore.collection('transactions').add({
      'id': '',
      'orderId': orderId,
      'userId': order.odersId,
      'symbol': order.symbol,
      'stockName': order.stockName,
      'side': order.orderSide.name,
      'quantity': order.quantity,
      'price': order.price,
      'totalValue': order.totalValue,
      'brokerage': brokerage,
      'taxes': taxes,
      'netValue': netValue,
      'timestamp': Timestamp.now(),
    });
  }

  // Get order by ID
  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (doc.exists) {
      return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // Get user's order history
  Future<List<OrderModel>> getOrderHistory(
    String userId, {
    int limit = 50,
    OrderStatus? status,
  }) async {
    try {
      // Query without ordering to avoid composite index requirement
      Query query = _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId);

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      final snapshot = await query.limit(limit).get();

      final orders = snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      // Sort locally by createdAt descending
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  // Stream order updates
  Stream<List<OrderModel>> streamOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          // Sort locally by createdAt descending
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return false;

    final order = OrderModel.fromJson({...doc.data()!, 'id': doc.id});

    // Only pending orders can be cancelled
    if (order.status != OrderStatus.pending) {
      return false;
    }

    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.cancelled.name,
      'updatedAt': Timestamp.now(),
    });

    return true;
  }

  // Get pending orders
  Future<List<OrderModel>> getPendingOrders(String odersId) async {
    return getOrderHistory(odersId, status: OrderStatus.pending);
  }

  // Get today's orders
  Future<List<OrderModel>> getTodaysOrders(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      // Query without ordering to avoid composite index requirement
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .where((order) => order.createdAt.isAfter(startOfDay))
          .toList();

      // Sort locally by createdAt descending
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      return [];
    }
  }

  // Get user's transactions
  Future<List<TransactionModel>> getTransactions(
    String userId, {
    int limit = 50,
  }) async {
    try {
      // Query without ordering to avoid composite index requirement
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort locally by timestamp descending
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return transactions;
    } catch (e) {
      return [];
    }
  }

  // Calculate brokerage (simple)
  double calculateBrokerage(double value, bool isBuy) {
    final charges = calculateCharges(value, isBuy);
    return charges['totalCharges'] ?? 0;
  }

  // Calculate brokerage and charges
  Map<String, double> calculateCharges(double value, bool isBuy) {
    final brokerage = value * 0.0003; // 0.03%
    final stt = isBuy ? 0.0 : value * 0.001; // 0.1% on sell
    final exchangeTax = value * 0.0000345;
    final gst = brokerage * 0.18;
    final sebi = value * 0.000001;
    final stampDuty = isBuy ? value * 0.00015 : 0.0;

    final totalCharges = brokerage + stt + exchangeTax + gst + sebi + stampDuty;

    return {
      'brokerage': brokerage,
      'stt': stt,
      'exchangeTax': exchangeTax,
      'gst': gst,
      'sebi': sebi,
      'stampDuty': stampDuty,
      'totalCharges': totalCharges,
    };
  }
}
