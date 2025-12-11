import 'dart:math';
import '../data/models/ai_model.dart';
import '../core/enums/enums.dart';

export '../data/models/ai_model.dart' show AiRecommendation, MarketSentiment, StockRecommendation;

class AiService {
  final Random _random = Random();

  // Get AI analysis for a stock
  Future<AiAnalysisModel> getStockAnalysis(String symbol, String stockName, double currentPrice) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Generate demo AI analysis
    final recommendations = ['Strong Buy', 'Buy', 'Hold', 'Sell', 'Strong Sell'];
    final riskLevels = RiskLevel.values;
    final trends = ['Bullish', 'Bearish', 'Sideways'];

    final recommendation = recommendations[_random.nextInt(3)]; // Bias towards positive
    final riskLevel = riskLevels[_random.nextInt(riskLevels.length)];
    final confidenceScore = 0.6 + (_random.nextDouble() * 0.35);

    final rsi = 30 + _random.nextDouble() * 40;
    final macd = (_random.nextDouble() - 0.5) * 10;

    return AiAnalysisModel(
      symbol: symbol,
      stockName: stockName,
      recommendation: recommendation,
      confidenceScore: confidenceScore,
      riskLevel: riskLevel,
      summary: _generateSummary(symbol, recommendation, riskLevel),
      keyPoints: _generateKeyPoints(recommendation),
      technicalIndicators: TechnicalIndicators(
        rsi: rsi,
        rsiSignal: rsi > 70 ? 'Overbought' : (rsi < 30 ? 'Oversold' : 'Neutral'),
        macd: macd,
        macdSignal: macd > 0 ? 'Bullish' : 'Bearish',
        ema20: currentPrice * (1 + (_random.nextDouble() - 0.5) * 0.02),
        ema50: currentPrice * (1 + (_random.nextDouble() - 0.5) * 0.05),
        ema200: currentPrice * (1 + (_random.nextDouble() - 0.5) * 0.1),
        trend: trends[_random.nextInt(trends.length)],
        supportLevel: currentPrice * (1 - _random.nextDouble() * 0.05),
        resistanceLevel: currentPrice * (1 + _random.nextDouble() * 0.05),
      ),
      sentimentAnalysis: SentimentAnalysis(
        overallScore: (_random.nextDouble() * 2) - 1,
        sentiment: trends[_random.nextInt(trends.length)],
        newsCount: 10 + _random.nextInt(40),
        positiveNews: 5 + _random.nextInt(20),
        negativeNews: 2 + _random.nextInt(10),
        neutralNews: 3 + _random.nextInt(15),
        topTopics: ['Earnings', 'Growth', 'Expansion', 'Industry Trends'],
      ),
      pricePrediction: PricePrediction(
        currentPrice: currentPrice,
        predictedPrice1Week: currentPrice * (1 + (_random.nextDouble() - 0.4) * 0.05),
        predictedPrice1Month: currentPrice * (1 + (_random.nextDouble() - 0.4) * 0.1),
        predictedPrice3Month: currentPrice * (1 + (_random.nextDouble() - 0.4) * 0.2),
        targetPrice: currentPrice * (1 + _random.nextDouble() * 0.15),
        stopLoss: currentPrice * (1 - _random.nextDouble() * 0.08),
      ),
      analysisDate: DateTime.now(),
    );
  }

  String _generateSummary(String symbol, String recommendation, RiskLevel riskLevel) {
    final summaries = {
      'Strong Buy': '$symbol shows strong bullish momentum with positive technical and fundamental indicators. The stock is trading above key moving averages with increasing volume.',
      'Buy': '$symbol appears to be in a healthy uptrend with moderate risk. Consider accumulating on dips.',
      'Hold': '$symbol is currently in a consolidation phase. Wait for a clear breakout before taking new positions.',
      'Sell': '$symbol shows signs of weakness. Consider booking profits if you have existing positions.',
      'Strong Sell': '$symbol is showing bearish signals. The stock is trading below key support levels.',
    };
    return summaries[recommendation] ?? 'Analysis not available.';
  }

  List<String> _generateKeyPoints(String recommendation) {
    if (recommendation.contains('Buy')) {
      return [
        'Strong quarterly earnings growth',
        'Trading above 50-day moving average',
        'Positive analyst upgrades',
        'Healthy cash flow and low debt',
        'Industry tailwinds supporting growth',
      ];
    } else if (recommendation.contains('Sell')) {
      return [
        'Declining revenue trend',
        'Trading below key support levels',
        'Negative market sentiment',
        'High valuation compared to peers',
        'Regulatory concerns',
      ];
    } else {
      return [
        'Consolidating near resistance',
        'Mixed analyst opinions',
        'Wait for volume confirmation',
        'Key earnings announcement upcoming',
        'Monitor sector performance',
      ];
    }
  }

  // Get portfolio optimization suggestions
  Future<PortfolioOptimization> getPortfolioOptimization(
    List<Map<String, dynamic>> holdings,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final suggestions = holdings.map((h) {
      final currentAlloc = (h['allocation'] as num?)?.toDouble() ?? 10.0;
      final suggestedAlloc = currentAlloc + (_random.nextDouble() - 0.5) * 5;

      String action;
      if (suggestedAlloc > currentAlloc + 2) {
        action = 'Increase';
      } else if (suggestedAlloc < currentAlloc - 2) {
        action = 'Decrease';
      } else {
        action = 'Hold';
      }

      return AllocationSuggestion(
        symbol: h['symbol'] as String,
        name: h['name'] as String,
        currentAllocation: currentAlloc,
        suggestedAllocation: suggestedAlloc.clamp(0, 100),
        action: action,
      );
    }).toList();

    return PortfolioOptimization(
      currentRisk: 0.15 + _random.nextDouble() * 0.1,
      suggestedRisk: 0.12 + _random.nextDouble() * 0.08,
      suggestions: suggestions,
      expectedReturn: 0.12 + _random.nextDouble() * 0.08,
      summary: 'Your portfolio is moderately diversified. Consider rebalancing to reduce concentration risk and improve risk-adjusted returns.',
    );
  }

  // Check risk for a specific stock
  Future<Map<String, dynamic>> checkStockRisk(String symbol, double price) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final riskScore = _random.nextDouble();
    final riskLevel = riskScore < 0.3
        ? RiskLevel.low
        : (riskScore < 0.6 ? RiskLevel.medium : RiskLevel.high);

    return {
      'symbol': symbol,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'volatility': 0.1 + _random.nextDouble() * 0.3,
      'beta': 0.5 + _random.nextDouble() * 1.5,
      'maxDrawdown': -(_random.nextDouble() * 0.3),
      'recommendation': riskLevel == RiskLevel.low
          ? 'Suitable for conservative investors'
          : (riskLevel == RiskLevel.medium
              ? 'Suitable for moderate risk takers'
              : 'Only for aggressive investors'),
    };
  }

  // Get stock recommendations for list view
  Future<List<AiRecommendation>> getStockRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      AiRecommendation(
        symbol: 'RELIANCE',
        stockName: 'Reliance Industries',
        recommendation: 'Buy',
        targetPrice: 2650,
        stopLoss: 2350,
        expectedReturn: 8.5,
        riskLevel: 'Medium',
        reason: 'Strong refining margins and retail growth outlook. Jio continues to add subscribers.',
      ),
      AiRecommendation(
        symbol: 'TCS',
        stockName: 'Tata Consultancy Services',
        recommendation: 'Hold',
        targetPrice: 4000,
        stopLoss: 3500,
        expectedReturn: 5.2,
        riskLevel: 'Low',
        reason: 'Stable growth but premium valuations. Wait for better entry point.',
      ),
      AiRecommendation(
        symbol: 'HDFCBANK',
        stockName: 'HDFC Bank',
        recommendation: 'Buy',
        targetPrice: 1850,
        stopLoss: 1550,
        expectedReturn: 12.3,
        riskLevel: 'Low',
        reason: 'Merger synergies playing out well. Strong loan book growth expected.',
      ),
      AiRecommendation(
        symbol: 'INFY',
        stockName: 'Infosys',
        recommendation: 'Buy',
        targetPrice: 1700,
        stopLoss: 1400,
        expectedReturn: 11.5,
        riskLevel: 'Medium',
        reason: 'Strong deal pipeline and improving margins. Attractive valuation.',
      ),
      AiRecommendation(
        symbol: 'TATAMOTORS',
        stockName: 'Tata Motors',
        recommendation: 'Buy',
        targetPrice: 1000,
        stopLoss: 780,
        expectedReturn: 14.2,
        riskLevel: 'High',
        reason: 'JLR turnaround and EV leadership in India driving growth.',
      ),
      AiRecommendation(
        symbol: 'ICICIBANK',
        stockName: 'ICICI Bank',
        recommendation: 'Hold',
        targetPrice: 1150,
        stopLoss: 950,
        expectedReturn: 6.8,
        riskLevel: 'Low',
        reason: 'Quality franchise but near fair value. Maintain existing positions.',
      ),
    ];
  }

  // Get simplified market sentiment
  Future<MarketSentiment> getMarketSentimentSimple() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final sentiments = ['Bullish', 'Neutral', 'Bearish'];
    final sentiment = sentiments[_random.nextInt(2)]; // Bias towards positive

    return MarketSentiment(
      sentiment: sentiment,
      confidence: 65 + _random.nextInt(25),
      summary: sentiment == 'Bullish'
          ? 'Markets showing positive momentum with strong FII inflows. IT and Banking sectors leading the rally.'
          : (sentiment == 'Bearish'
              ? 'Cautious sentiment prevails due to global uncertainties. Defensive sectors preferred.'
              : 'Mixed signals in the market. Wait for clearer direction before taking large positions.'),
    );
  }

  // Get market sentiment
  Future<MarketSentiment> getMarketSentiment() async {
    return getMarketSentimentSimple();
  }

  // Get market sentiment (legacy method returns Map)
  Future<Map<String, dynamic>> getMarketSentimentMap() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final sentimentScore = _random.nextDouble();
    final sentiment = sentimentScore > 0.6
        ? 'Bullish'
        : (sentimentScore > 0.4 ? 'Neutral' : 'Bearish');

    return {
      'overallSentiment': sentiment,
      'sentimentScore': sentimentScore,
      'fearGreedIndex': (_random.nextDouble() * 100).round(),
      'marketMood': sentiment,
      'recommendation': sentiment == 'Bullish'
          ? 'Good time to invest'
          : (sentiment == 'Bearish'
              ? 'Be cautious, consider defensive stocks'
              : 'Wait for clearer direction'),
      'topBullishSectors': ['IT', 'Banking', 'Auto'],
      'topBearishSectors': ['Metals', 'Realty'],
    };
  }
}
