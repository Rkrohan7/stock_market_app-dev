import 'package:cloud_firestore/cloud_firestore.dart';

class NewsAlertModel {
  final String id;
  final String userId;
  final String? keyword;
  final List<String> categories;
  final List<String> symbols;
  final bool breakingNewsOnly;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastTriggeredAt;

  NewsAlertModel({
    required this.id,
    required this.userId,
    this.keyword,
    this.categories = const [],
    this.symbols = const [],
    this.breakingNewsOnly = false,
    this.isActive = true,
    required this.createdAt,
    this.lastTriggeredAt,
  });

  factory NewsAlertModel.fromJson(Map<String, dynamic> json) {
    return NewsAlertModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      keyword: json['keyword'] as String?,
      categories: List<String>.from(json['categories'] ?? []),
      symbols: List<String>.from(json['symbols'] ?? []),
      breakingNewsOnly: json['breakingNewsOnly'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastTriggeredAt: json['lastTriggeredAt'] != null
          ? (json['lastTriggeredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'keyword': keyword,
      'categories': categories,
      'symbols': symbols,
      'breakingNewsOnly': breakingNewsOnly,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastTriggeredAt':
          lastTriggeredAt != null ? Timestamp.fromDate(lastTriggeredAt!) : null,
    };
  }

  String get alertDescription {
    List<String> parts = [];

    if (keyword != null && keyword!.isNotEmpty) {
      parts.add('Keyword: "$keyword"');
    }
    if (categories.isNotEmpty) {
      parts.add('Categories: ${categories.join(", ")}');
    }
    if (symbols.isNotEmpty) {
      parts.add('Stocks: ${symbols.join(", ")}');
    }
    if (breakingNewsOnly) {
      parts.add('Breaking news only');
    }

    return parts.isEmpty ? 'All news' : parts.join(' | ');
  }

  NewsAlertModel copyWith({
    String? id,
    String? userId,
    String? keyword,
    List<String>? categories,
    List<String>? symbols,
    bool? breakingNewsOnly,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastTriggeredAt,
  }) {
    return NewsAlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      keyword: keyword ?? this.keyword,
      categories: categories ?? this.categories,
      symbols: symbols ?? this.symbols,
      breakingNewsOnly: breakingNewsOnly ?? this.breakingNewsOnly,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
    );
  }
}
