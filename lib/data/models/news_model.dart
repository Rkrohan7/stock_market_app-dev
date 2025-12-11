import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String source;
  final String? imageUrl;
  final String? url;
  final List<String> relatedSymbols;
  final String category;
  final DateTime publishedAt;
  final bool isBreaking;

  // Alias for views
  String get summary => description;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.source,
    this.imageUrl,
    this.url,
    this.relatedSymbols = const [],
    this.category = 'General',
    required this.publishedAt,
    this.isBreaking = false,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String? ?? '',
      source: json['source'] as String,
      imageUrl: json['imageUrl'] as String?,
      url: json['url'] as String?,
      relatedSymbols: (json['relatedSymbols'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      category: json['category'] as String? ?? 'General',
      publishedAt: json['publishedAt'] is Timestamp
          ? (json['publishedAt'] as Timestamp).toDate()
          : DateTime.parse(json['publishedAt'] as String),
      isBreaking: json['isBreaking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'source': source,
      'imageUrl': imageUrl,
      'url': url,
      'relatedSymbols': relatedSymbols,
      'category': category,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'isBreaking': isBreaking,
    };
  }
}

// Alias for simpler use
typedef NewsArticle = NewsModel;

// News Categories
class NewsCategory {
  static const String all = 'All';
  static const String market = 'Market';
  static const String stocks = 'Stocks';
  static const String economy = 'Economy';
  static const String ipo = 'IPO';
  static const String mutualFunds = 'Mutual Funds';
  static const String crypto = 'Crypto';
  static const String global = 'Global';

  static List<String> get categories => [
        all,
        market,
        stocks,
        economy,
        ipo,
        mutualFunds,
        crypto,
        global,
      ];
}
