import '../../core/enums/enums.dart';

// Aliases for views
typedef StockRecommendation = AiRecommendation;

// Simple recommendation model for list views
class AiRecommendation {
  final String symbol;
  final String stockName;
  final String recommendation;
  final double targetPrice;
  final double stopLoss;
  final double expectedReturn;
  final String riskLevel;
  final String reason;

  AiRecommendation({
    required this.symbol,
    required this.stockName,
    required this.recommendation,
    required this.targetPrice,
    required this.stopLoss,
    required this.expectedReturn,
    required this.riskLevel,
    required this.reason,
  });
}

// Market Sentiment model for overview
class MarketSentiment {
  final String sentiment;
  final int confidence;
  final String summary;

  MarketSentiment({
    required this.sentiment,
    required this.confidence,
    required this.summary,
  });
}

class AiAnalysisModel {
  final String symbol;
  final String stockName;
  final String recommendation; // Buy, Sell, Hold
  final double confidenceScore;
  final RiskLevel riskLevel;
  final String summary;
  final List<String> keyPoints;
  final TechnicalIndicators technicalIndicators;
  final SentimentAnalysis sentimentAnalysis;
  final PricePrediction pricePrediction;
  final DateTime analysisDate;

  AiAnalysisModel({
    required this.symbol,
    required this.stockName,
    required this.recommendation,
    required this.confidenceScore,
    required this.riskLevel,
    required this.summary,
    required this.keyPoints,
    required this.technicalIndicators,
    required this.sentimentAnalysis,
    required this.pricePrediction,
    required this.analysisDate,
  });

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiAnalysisModel(
      symbol: json['symbol'] as String,
      stockName: json['stockName'] as String,
      recommendation: json['recommendation'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == json['riskLevel'],
        orElse: () => RiskLevel.medium,
      ),
      summary: json['summary'] as String,
      keyPoints: (json['keyPoints'] as List).map((e) => e as String).toList(),
      technicalIndicators: TechnicalIndicators.fromJson(
        json['technicalIndicators'] as Map<String, dynamic>,
      ),
      sentimentAnalysis: SentimentAnalysis.fromJson(
        json['sentimentAnalysis'] as Map<String, dynamic>,
      ),
      pricePrediction: PricePrediction.fromJson(
        json['pricePrediction'] as Map<String, dynamic>,
      ),
      analysisDate: DateTime.parse(json['analysisDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'stockName': stockName,
      'recommendation': recommendation,
      'confidenceScore': confidenceScore,
      'riskLevel': riskLevel.name,
      'summary': summary,
      'keyPoints': keyPoints,
      'technicalIndicators': technicalIndicators.toJson(),
      'sentimentAnalysis': sentimentAnalysis.toJson(),
      'pricePrediction': pricePrediction.toJson(),
      'analysisDate': analysisDate.toIso8601String(),
    };
  }
}

class TechnicalIndicators {
  final double rsi;
  final String rsiSignal; // Overbought, Oversold, Neutral
  final double macd;
  final String macdSignal;
  final double ema20;
  final double ema50;
  final double ema200;
  final String trend; // Bullish, Bearish, Sideways
  final double supportLevel;
  final double resistanceLevel;

  TechnicalIndicators({
    required this.rsi,
    required this.rsiSignal,
    required this.macd,
    required this.macdSignal,
    required this.ema20,
    required this.ema50,
    required this.ema200,
    required this.trend,
    required this.supportLevel,
    required this.resistanceLevel,
  });

  factory TechnicalIndicators.fromJson(Map<String, dynamic> json) {
    return TechnicalIndicators(
      rsi: (json['rsi'] as num).toDouble(),
      rsiSignal: json['rsiSignal'] as String,
      macd: (json['macd'] as num).toDouble(),
      macdSignal: json['macdSignal'] as String,
      ema20: (json['ema20'] as num).toDouble(),
      ema50: (json['ema50'] as num).toDouble(),
      ema200: (json['ema200'] as num).toDouble(),
      trend: json['trend'] as String,
      supportLevel: (json['supportLevel'] as num).toDouble(),
      resistanceLevel: (json['resistanceLevel'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rsi': rsi,
      'rsiSignal': rsiSignal,
      'macd': macd,
      'macdSignal': macdSignal,
      'ema20': ema20,
      'ema50': ema50,
      'ema200': ema200,
      'trend': trend,
      'supportLevel': supportLevel,
      'resistanceLevel': resistanceLevel,
    };
  }
}

class SentimentAnalysis {
  final double overallScore; // -1 to 1
  final String sentiment; // Bullish, Bearish, Neutral
  final int newsCount;
  final int positiveNews;
  final int negativeNews;
  final int neutralNews;
  final List<String> topTopics;

  SentimentAnalysis({
    required this.overallScore,
    required this.sentiment,
    required this.newsCount,
    required this.positiveNews,
    required this.negativeNews,
    required this.neutralNews,
    required this.topTopics,
  });

  factory SentimentAnalysis.fromJson(Map<String, dynamic> json) {
    return SentimentAnalysis(
      overallScore: (json['overallScore'] as num).toDouble(),
      sentiment: json['sentiment'] as String,
      newsCount: (json['newsCount'] as num).toInt(),
      positiveNews: (json['positiveNews'] as num).toInt(),
      negativeNews: (json['negativeNews'] as num).toInt(),
      neutralNews: (json['neutralNews'] as num).toInt(),
      topTopics: (json['topTopics'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'sentiment': sentiment,
      'newsCount': newsCount,
      'positiveNews': positiveNews,
      'negativeNews': negativeNews,
      'neutralNews': neutralNews,
      'topTopics': topTopics,
    };
  }
}

class PricePrediction {
  final double currentPrice;
  final double predictedPrice1Week;
  final double predictedPrice1Month;
  final double predictedPrice3Month;
  final double targetPrice;
  final double stopLoss;
  final String disclaimer;

  PricePrediction({
    required this.currentPrice,
    required this.predictedPrice1Week,
    required this.predictedPrice1Month,
    required this.predictedPrice3Month,
    required this.targetPrice,
    required this.stopLoss,
    this.disclaimer = 'This is not financial advice. Past performance does not guarantee future results.',
  });

  factory PricePrediction.fromJson(Map<String, dynamic> json) {
    return PricePrediction(
      currentPrice: (json['currentPrice'] as num).toDouble(),
      predictedPrice1Week: (json['predictedPrice1Week'] as num).toDouble(),
      predictedPrice1Month: (json['predictedPrice1Month'] as num).toDouble(),
      predictedPrice3Month: (json['predictedPrice3Month'] as num).toDouble(),
      targetPrice: (json['targetPrice'] as num).toDouble(),
      stopLoss: (json['stopLoss'] as num).toDouble(),
      disclaimer: json['disclaimer'] as String? ??
          'This is not financial advice. Past performance does not guarantee future results.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPrice': currentPrice,
      'predictedPrice1Week': predictedPrice1Week,
      'predictedPrice1Month': predictedPrice1Month,
      'predictedPrice3Month': predictedPrice3Month,
      'targetPrice': targetPrice,
      'stopLoss': stopLoss,
      'disclaimer': disclaimer,
    };
  }

  double get potentialGainPercent =>
      ((targetPrice - currentPrice) / currentPrice) * 100;

  double get potentialLossPercent =>
      ((currentPrice - stopLoss) / currentPrice) * 100;

  double get riskRewardRatio {
    if (potentialLossPercent == 0) return 0;
    return potentialGainPercent / potentialLossPercent;
  }
}

// Portfolio Optimization
class PortfolioOptimization {
  final double currentRisk;
  final double suggestedRisk;
  final List<AllocationSuggestion> suggestions;
  final double expectedReturn;
  final String summary;

  PortfolioOptimization({
    required this.currentRisk,
    required this.suggestedRisk,
    required this.suggestions,
    required this.expectedReturn,
    required this.summary,
  });

  factory PortfolioOptimization.fromJson(Map<String, dynamic> json) {
    return PortfolioOptimization(
      currentRisk: (json['currentRisk'] as num).toDouble(),
      suggestedRisk: (json['suggestedRisk'] as num).toDouble(),
      suggestions: (json['suggestions'] as List)
          .map((e) => AllocationSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      expectedReturn: (json['expectedReturn'] as num).toDouble(),
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentRisk': currentRisk,
      'suggestedRisk': suggestedRisk,
      'suggestions': suggestions.map((e) => e.toJson()).toList(),
      'expectedReturn': expectedReturn,
      'summary': summary,
    };
  }
}

class AllocationSuggestion {
  final String symbol;
  final String name;
  final double currentAllocation;
  final double suggestedAllocation;
  final String action; // Increase, Decrease, Hold, Add, Remove

  AllocationSuggestion({
    required this.symbol,
    required this.name,
    required this.currentAllocation,
    required this.suggestedAllocation,
    required this.action,
  });

  factory AllocationSuggestion.fromJson(Map<String, dynamic> json) {
    return AllocationSuggestion(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      currentAllocation: (json['currentAllocation'] as num).toDouble(),
      suggestedAllocation: (json['suggestedAllocation'] as num).toDouble(),
      action: json['action'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'currentAllocation': currentAllocation,
      'suggestedAllocation': suggestedAllocation,
      'action': action,
    };
  }
}
