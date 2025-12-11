import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistModel {
  final String id;
  final String userId;
  final String name;
  final List<WatchlistItem> items;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WatchlistModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.items,
    required this.createdAt,
    this.updatedAt,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      items: (json['items'] as List?)
              ?.map((e) => WatchlistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  WatchlistModel copyWith({
    String? id,
    String? userId,
    String? name,
    List<WatchlistItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool containsStock(String symbol) {
    return items.any((item) => item.symbol == symbol);
  }
}

class WatchlistItem {
  final String symbol;
  final String name;
  final double currentPrice;
  final double change;
  final double changePercent;
  final DateTime addedAt;

  WatchlistItem({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.addedAt,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      addedAt: json['addedAt'] is Timestamp
          ? (json['addedAt'] as Timestamp).toDate()
          : DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'currentPrice': currentPrice,
      'change': change,
      'changePercent': changePercent,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  bool get isPositive => change >= 0;

  WatchlistItem copyWith({
    String? symbol,
    String? name,
    double? currentPrice,
    double? change,
    double? changePercent,
    DateTime? addedAt,
  }) {
    return WatchlistItem(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
