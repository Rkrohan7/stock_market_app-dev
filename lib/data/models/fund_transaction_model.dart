import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

class FundTransactionModel {
  final String id;
  final String userId;
  final FundTransactionType type;
  final double amount;
  final PaymentMethod paymentMethod;
  final FundTransactionStatus status;
  final String? referenceId;
  final String? description;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime? completedAt;

  FundTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    this.status = FundTransactionStatus.pending,
    this.referenceId,
    this.description,
    this.failureReason,
    required this.createdAt,
    this.completedAt,
  });

  factory FundTransactionModel.fromJson(Map<String, dynamic> json) {
    return FundTransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: FundTransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FundTransactionType.deposit,
      ),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.upi,
      ),
      status: FundTransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FundTransactionStatus.pending,
      ),
      referenceId: json['referenceId'] as String?,
      description: json['description'] as String?,
      failureReason: json['failureReason'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'paymentMethod': paymentMethod.name,
      'status': status.name,
      'referenceId': referenceId,
      'description': description,
      'failureReason': failureReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  FundTransactionModel copyWith({
    String? id,
    String? userId,
    FundTransactionType? type,
    double? amount,
    PaymentMethod? paymentMethod,
    FundTransactionStatus? status,
    String? referenceId,
    String? description,
    String? failureReason,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return FundTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      description: description ?? this.description,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isDeposit => type == FundTransactionType.deposit;
  bool get isWithdrawal => type == FundTransactionType.withdrawal;
  bool get isCompleted => status == FundTransactionStatus.completed;
  bool get isPending => status == FundTransactionStatus.pending || status == FundTransactionStatus.processing;
  bool get isFailed => status == FundTransactionStatus.failed;
}
