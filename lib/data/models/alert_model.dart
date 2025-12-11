import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

class AlertModel {
  final String id;
  final String userId;
  final String symbol;
  final String stockName;
  final AlertType alertType;
  final double targetValue;
  final double? currentValue;
  final bool isTriggered;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  AlertModel({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.stockName,
    required this.alertType,
    required this.targetValue,
    this.currentValue,
    this.isTriggered = false,
    this.isActive = true,
    required this.createdAt,
    this.triggeredAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      symbol: json['symbol'] as String,
      stockName: json['stockName'] as String,
      alertType: AlertType.values.firstWhere(
        (e) => e.name == json['alertType'],
        orElse: () => AlertType.priceAbove,
      ),
      targetValue: (json['targetValue'] as num).toDouble(),
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      isTriggered: json['isTriggered'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      triggeredAt: json['triggeredAt'] != null
          ? (json['triggeredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'symbol': symbol,
      'stockName': stockName,
      'alertType': alertType.name,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isTriggered': isTriggered,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'triggeredAt':
          triggeredAt != null ? Timestamp.fromDate(triggeredAt!) : null,
    };
  }

  String get alertDescription {
    switch (alertType) {
      case AlertType.priceAbove:
        return 'Price goes above ₹${targetValue.toStringAsFixed(2)}';
      case AlertType.priceBelow:
        return 'Price goes below ₹${targetValue.toStringAsFixed(2)}';
      case AlertType.percentageChange:
        return 'Price changes by ${targetValue.toStringAsFixed(1)}%';
      case AlertType.volume:
        return 'Volume exceeds ${targetValue.toInt()}';
    }
  }

  AlertModel copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? stockName,
    AlertType? alertType,
    double? targetValue,
    double? currentValue,
    bool? isTriggered,
    bool? isActive,
    DateTime? createdAt,
    DateTime? triggeredAt,
  }) {
    return AlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      stockName: stockName ?? this.stockName,
      alertType: alertType ?? this.alertType,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isTriggered: isTriggered ?? this.isTriggered,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }
}
