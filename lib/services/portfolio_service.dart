import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/portfolio_model.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user portfolio
  Future<PortfolioModel?> getPortfolio(String odersId) async {
    final doc = await _firestore.collection('portfolios').doc(odersId).get();
    if (doc.exists) {
      return PortfolioModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return PortfolioModel.empty(odersId);
  }

  // Stream portfolio
  Stream<PortfolioModel?> streamPortfolio(String odersId) {
    return _firestore.collection('portfolios').doc(odersId).snapshots().map((doc) {
      if (doc.exists) {
        return PortfolioModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return PortfolioModel.empty(odersId);
    });
  }

  // Add holding to portfolio
  Future<void> addHolding(String odersId, HoldingModel holding) async {
    final portfolioRef = _firestore.collection('portfolios').doc(odersId);
    final doc = await portfolioRef.get();

    if (doc.exists) {
      // Check if holding exists
      final existingHoldings = (doc.data()?['holdings'] as List?) ?? [];
      final existingIndex = existingHoldings.indexWhere(
        (h) => h['symbol'] == holding.symbol,
      );

      if (existingIndex >= 0) {
        // Update existing holding (average price calculation)
        final existing = HoldingModel.fromJson(existingHoldings[existingIndex]);
        final newQuantity = existing.quantity + holding.quantity;
        final newAveragePrice =
            ((existing.averagePrice * existing.quantity) +
                (holding.averagePrice * holding.quantity)) /
            newQuantity;

        existingHoldings[existingIndex] = holding
            .copyWith(
              quantity: newQuantity,
              averagePrice: newAveragePrice,
            )
            .toJson();

        await portfolioRef.update({
          'holdings': existingHoldings,
          'lastUpdated': Timestamp.now(),
        });
      } else {
        // Add new holding
        await portfolioRef.update({
          'holdings': FieldValue.arrayUnion([holding.toJson()]),
          'lastUpdated': Timestamp.now(),
        });
      }
    } else {
      // Create new portfolio
      await portfolioRef.set({
        'userId': odersId,
        'holdings': [holding.toJson()],
        'totalInvestment': holding.investedValue,
        'currentValue': holding.currentValue,
        'totalProfitLoss': holding.profitLoss,
        'totalProfitLossPercent': holding.profitLossPercent,
        'todayProfitLoss': 0,
        'todayProfitLossPercent': 0,
        'lastUpdated': Timestamp.now(),
      });
    }

    await _updatePortfolioTotals(odersId);
  }

  // Remove/reduce holding from portfolio
  Future<void> reduceHolding(String odersId, String symbol, int quantity) async {
    final portfolioRef = _firestore.collection('portfolios').doc(odersId);
    final doc = await portfolioRef.get();

    if (!doc.exists) return;

    final holdings = (doc.data()?['holdings'] as List?) ?? [];
    final holdingIndex = holdings.indexWhere((h) => h['symbol'] == symbol);

    if (holdingIndex < 0) return;

    final holding = HoldingModel.fromJson(holdings[holdingIndex]);

    if (quantity >= holding.quantity) {
      // Remove entire holding
      holdings.removeAt(holdingIndex);
    } else {
      // Reduce quantity
      holdings[holdingIndex] = holding
          .copyWith(quantity: holding.quantity - quantity)
          .toJson();
    }

    await portfolioRef.update({
      'holdings': holdings,
      'lastUpdated': Timestamp.now(),
    });

    await _updatePortfolioTotals(odersId);
  }

  // Update portfolio totals
  Future<void> _updatePortfolioTotals(String odersId) async {
    final portfolioRef = _firestore.collection('portfolios').doc(odersId);
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

  // Get portfolio history for charts
  Future<List<PortfolioHistory>> getPortfolioHistory(
    String odersId, {
    int days = 30,
  }) async {
    // Demo data - In production, fetch from API or calculate from transactions
    final List<PortfolioHistory> history = [];
    final now = DateTime.now();
    double baseValue = 100000;

    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      baseValue += (baseValue * 0.01 * (i % 3 == 0 ? -1 : 1));
      history.add(PortfolioHistory(date: date, value: baseValue));
    }

    return history;
  }

  // Update holding prices (called when market data updates)
  Future<void> updateHoldingPrices(
    String odersId,
    Map<String, double> prices,
  ) async {
    final portfolioRef = _firestore.collection('portfolios').doc(odersId);
    final doc = await portfolioRef.get();

    if (!doc.exists) return;

    final holdings = (doc.data()?['holdings'] as List?) ?? [];
    final updatedHoldings = <Map<String, dynamic>>[];

    for (final h in holdings) {
      final holding = HoldingModel.fromJson(h);
      final newPrice = prices[holding.symbol];

      if (newPrice != null) {
        updatedHoldings.add(holding.copyWith(currentPrice: newPrice).toJson());
      } else {
        updatedHoldings.add(h);
      }
    }

    await portfolioRef.update({
      'holdings': updatedHoldings,
      'lastUpdated': Timestamp.now(),
    });

    await _updatePortfolioTotals(odersId);
  }
}
