import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioModel {
  final String id;
  final String odersId;
  final double totalInvestment;
  final double currentValue;
  final double totalProfitLoss;
  final double totalProfitLossPercent;
  final double todayProfitLoss;
  final double todayProfitLossPercent;
  final List<HoldingModel> holdings;
  final DateTime lastUpdated;

  PortfolioModel({
    required this.id,
    required this.odersId,
    required this.totalInvestment,
    required this.currentValue,
    required this.totalProfitLoss,
    required this.totalProfitLossPercent,
    required this.todayProfitLoss,
    required this.todayProfitLossPercent,
    required this.holdings,
    required this.lastUpdated,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] as String,
      odersId: json['userId'] as String,
      totalInvestment: (json['totalInvestment'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      totalProfitLoss: (json['totalProfitLoss'] as num).toDouble(),
      totalProfitLossPercent: (json['totalProfitLossPercent'] as num).toDouble(),
      todayProfitLoss: (json['todayProfitLoss'] as num).toDouble(),
      todayProfitLossPercent: (json['todayProfitLossPercent'] as num).toDouble(),
      holdings: (json['holdings'] as List?)
              ?.map((e) => HoldingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': odersId,
      'totalInvestment': totalInvestment,
      'currentValue': currentValue,
      'totalProfitLoss': totalProfitLoss,
      'totalProfitLossPercent': totalProfitLossPercent,
      'todayProfitLoss': todayProfitLoss,
      'todayProfitLossPercent': todayProfitLossPercent,
      'holdings': holdings.map((e) => e.toJson()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory PortfolioModel.empty(String userId) {
    return PortfolioModel(
      id: '',
      odersId: userId,
      totalInvestment: 0,
      currentValue: 0,
      totalProfitLoss: 0,
      totalProfitLossPercent: 0,
      todayProfitLoss: 0,
      todayProfitLossPercent: 0,
      holdings: [],
      lastUpdated: DateTime.now(),
    );
  }
}

class HoldingModel {
  final String id;
  final String symbol;
  final String name;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final double investedValue;
  final double currentValue;
  final double profitLoss;
  final double profitLossPercent;
  final double todayChange;
  final double todayChangePercent;
  final DateTime purchaseDate;

  HoldingModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    double? investedValue,
    double? currentValue,
    double? profitLoss,
    double? profitLossPercent,
    this.todayChange = 0,
    this.todayChangePercent = 0,
    required this.purchaseDate,
  })  : investedValue = investedValue ?? (quantity * averagePrice),
        currentValue = currentValue ?? (quantity * currentPrice),
        profitLoss = profitLoss ?? ((currentPrice - averagePrice) * quantity),
        profitLossPercent = profitLossPercent ??
            ((averagePrice != 0)
                ? ((currentPrice - averagePrice) / averagePrice) * 100
                : 0);

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      investedValue: (json['investedValue'] as num?)?.toDouble(),
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      profitLoss: (json['profitLoss'] as num?)?.toDouble(),
      profitLossPercent: (json['profitLossPercent'] as num?)?.toDouble(),
      todayChange: (json['todayChange'] as num?)?.toDouble() ?? 0,
      todayChangePercent: (json['todayChangePercent'] as num?)?.toDouble() ?? 0,
      purchaseDate: json['purchaseDate'] is Timestamp
          ? (json['purchaseDate'] as Timestamp).toDate()
          : DateTime.parse(json['purchaseDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'investedValue': investedValue,
      'currentValue': currentValue,
      'profitLoss': profitLoss,
      'profitLossPercent': profitLossPercent,
      'todayChange': todayChange,
      'todayChangePercent': todayChangePercent,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
    };
  }

  bool get isProfit => profitLoss >= 0;

  HoldingModel copyWith({
    String? id,
    String? symbol,
    String? name,
    int? quantity,
    double? averagePrice,
    double? currentPrice,
    double? investedValue,
    double? currentValue,
    double? profitLoss,
    double? profitLossPercent,
    double? todayChange,
    double? todayChangePercent,
    DateTime? purchaseDate,
  }) {
    return HoldingModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      averagePrice: averagePrice ?? this.averagePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      investedValue: investedValue ?? this.investedValue,
      currentValue: currentValue ?? this.currentValue,
      profitLoss: profitLoss ?? this.profitLoss,
      profitLossPercent: profitLossPercent ?? this.profitLossPercent,
      todayChange: todayChange ?? this.todayChange,
      todayChangePercent: todayChangePercent ?? this.todayChangePercent,
      purchaseDate: purchaseDate ?? this.purchaseDate,
    );
  }
}

// Portfolio History for charts
class PortfolioHistory {
  final DateTime date;
  final double value;

  PortfolioHistory({
    required this.date,
    required this.value,
  });

  factory PortfolioHistory.fromJson(Map<String, dynamic> json) {
    return PortfolioHistory(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }
}
