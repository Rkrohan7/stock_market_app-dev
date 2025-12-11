import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

class OrderModel {
  final String id;
  final String odersId;
  final String symbol;
  final String stockName;
  final OrderType orderType;
  final OrderSide orderSide;
  final TradingMode tradingMode;
  final OrderStatus status;
  final int quantity;
  final int filledQuantity;
  final double price;
  final double? limitPrice;
  final double? stopPrice;
  final double? triggerPrice;
  final double totalValue;
  final double? executedPrice;
  final DateTime createdAt;
  final DateTime? executedAt;
  final String? rejectionReason;

  OrderModel({
    required this.id,
    required this.odersId,
    required this.symbol,
    required this.stockName,
    required this.orderType,
    required this.orderSide,
    required this.tradingMode,
    required this.status,
    required this.quantity,
    this.filledQuantity = 0,
    required this.price,
    this.limitPrice,
    this.stopPrice,
    this.triggerPrice,
    double? totalValue,
    this.executedPrice,
    required this.createdAt,
    this.executedAt,
    this.rejectionReason,
  }) : totalValue = totalValue ?? (quantity * price);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      odersId: json['userId'] as String,
      symbol: json['symbol'] as String,
      stockName: json['stockName'] as String,
      orderType: OrderType.values.firstWhere(
        (e) => e.name == json['orderType'],
        orElse: () => OrderType.market,
      ),
      orderSide: OrderSide.values.firstWhere(
        (e) => e.name == json['orderSide'],
        orElse: () => OrderSide.buy,
      ),
      tradingMode: TradingMode.values.firstWhere(
        (e) => e.name == json['tradingMode'],
        orElse: () => TradingMode.delivery,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      quantity: (json['quantity'] as num).toInt(),
      filledQuantity: (json['filledQuantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num).toDouble(),
      limitPrice: (json['limitPrice'] as num?)?.toDouble(),
      stopPrice: (json['stopPrice'] as num?)?.toDouble(),
      triggerPrice: (json['triggerPrice'] as num?)?.toDouble(),
      totalValue: (json['totalValue'] as num?)?.toDouble(),
      executedPrice: (json['executedPrice'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      executedAt: json['executedAt'] != null
          ? (json['executedAt'] as Timestamp).toDate()
          : null,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': odersId,
      'symbol': symbol,
      'stockName': stockName,
      'orderType': orderType.name,
      'orderSide': orderSide.name,
      'tradingMode': tradingMode.name,
      'status': status.name,
      'quantity': quantity,
      'filledQuantity': filledQuantity,
      'price': price,
      'limitPrice': limitPrice,
      'stopPrice': stopPrice,
      'triggerPrice': triggerPrice,
      'totalValue': totalValue,
      'executedPrice': executedPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'executedAt': executedAt != null ? Timestamp.fromDate(executedAt!) : null,
      'rejectionReason': rejectionReason,
    };
  }

  bool get isBuy => orderSide == OrderSide.buy;
  bool get isSell => orderSide == OrderSide.sell;
  bool get isPending => status == OrderStatus.pending;
  bool get isExecuted => status == OrderStatus.executed;
  bool get isCancelled => status == OrderStatus.cancelled;

  OrderModel copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? stockName,
    OrderType? orderType,
    OrderSide? orderSide,
    TradingMode? tradingMode,
    OrderStatus? status,
    int? quantity,
    int? filledQuantity,
    double? price,
    double? limitPrice,
    double? stopPrice,
    double? triggerPrice,
    double? totalValue,
    double? executedPrice,
    DateTime? createdAt,
    DateTime? executedAt,
    String? rejectionReason,
  }) {
    return OrderModel(
      id: id ?? this.id,
      odersId: odersId,
      symbol: symbol ?? this.symbol,
      stockName: stockName ?? this.stockName,
      orderType: orderType ?? this.orderType,
      orderSide: orderSide ?? this.orderSide,
      tradingMode: tradingMode ?? this.tradingMode,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      filledQuantity: filledQuantity ?? this.filledQuantity,
      price: price ?? this.price,
      limitPrice: limitPrice ?? this.limitPrice,
      stopPrice: stopPrice ?? this.stopPrice,
      triggerPrice: triggerPrice ?? this.triggerPrice,
      totalValue: totalValue ?? this.totalValue,
      executedPrice: executedPrice ?? this.executedPrice,
      createdAt: createdAt ?? this.createdAt,
      executedAt: executedAt ?? this.executedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

// Transaction Model for completed trades
class TransactionModel {
  final String id;
  final String orderId;
  final String userId;
  final String symbol;
  final String stockName;
  final OrderSide side;
  final int quantity;
  final double price;
  final double totalValue;
  final double brokerage;
  final double taxes;
  final double netValue;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.symbol,
    required this.stockName,
    required this.side,
    required this.quantity,
    required this.price,
    required this.totalValue,
    required this.brokerage,
    required this.taxes,
    required this.netValue,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      symbol: json['symbol'] as String,
      stockName: json['stockName'] as String,
      side: OrderSide.values.firstWhere(
        (e) => e.name == json['side'],
        orElse: () => OrderSide.buy,
      ),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
      brokerage: (json['brokerage'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      netValue: (json['netValue'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'symbol': symbol,
      'stockName': stockName,
      'side': side.name,
      'quantity': quantity,
      'price': price,
      'totalValue': totalValue,
      'brokerage': brokerage,
      'taxes': taxes,
      'netValue': netValue,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
