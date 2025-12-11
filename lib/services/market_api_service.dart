import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/stock_model.dart';

/// Service for fetching live market data from Yahoo Finance API
/// Yahoo Finance is free and doesn't require API key
class MarketApiService {
  // Yahoo Finance API endpoints
  static const String _baseUrl = 'https://query1.finance.yahoo.com/v8/finance';
  static const String _quoteUrl = '$_baseUrl/chart';

  // NSE stock symbols need .NS suffix for Yahoo Finance
  static String _formatSymbol(String symbol) {
    // Already formatted
    if (symbol.endsWith('.NS') || symbol.endsWith('.BO')) {
      return symbol;
    }
    // Add NSE suffix for Indian stocks
    return '$symbol.NS';
  }

  /// Fetch single stock quote
  Future<StockModel?> getStockQuote(String symbol) async {
    try {
      final formattedSymbol = _formatSymbol(symbol);
      final url = '$_quoteUrl/$formattedSymbol?interval=1d&range=1d';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseStockData(data, symbol);
      }
      return null;
    } catch (e) {
      print('Error fetching stock quote: $e');
      return null;
    }
  }

  /// Fetch multiple stock quotes
  Future<List<StockModel>> getMultipleQuotes(List<String> symbols) async {
    final List<StockModel> stocks = [];

    // Fetch in parallel for better performance
    final futures = symbols.map((symbol) => getStockQuote(symbol));
    final results = await Future.wait(futures);

    for (final stock in results) {
      if (stock != null) {
        stocks.add(stock);
      }
    }

    return stocks;
  }

  /// Fetch market indices
  Future<List<MarketIndex>> getMarketIndices() async {
    final indices = <MarketIndex>[];

    // Index symbols for Yahoo Finance
    final indexSymbols = {
      '^NSEI': 'NIFTY 50',
      '^BSESN': 'SENSEX',
      '^NSEBANK': 'NIFTY BANK',
    };

    for (final entry in indexSymbols.entries) {
      try {
        final url = '$_quoteUrl/${entry.key}?interval=1d&range=1d';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'Mozilla/5.0',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final index = _parseIndexData(data, entry.key, entry.value);
          if (index != null) {
            indices.add(index);
          }
        }
      } catch (e) {
        print('Error fetching index ${entry.key}: $e');
      }
    }

    return indices;
  }

  /// Fetch historical candle data
  Future<List<CandleData>> getCandleData(
    String symbol, {
    String interval = '1d',
    String range = '1mo',
  }) async {
    try {
      final formattedSymbol = _formatSymbol(symbol);
      final url = '$_quoteUrl/$formattedSymbol?interval=$interval&range=$range';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseCandleData(data);
      }
      return [];
    } catch (e) {
      print('Error fetching candle data: $e');
      return [];
    }
  }

  /// Parse stock data from Yahoo Finance response
  StockModel? _parseStockData(Map<String, dynamic> data, String originalSymbol) {
    try {
      final chart = data['chart'];
      if (chart == null) return null;

      final result = chart['result'];
      if (result == null || result.isEmpty) return null;

      final meta = result[0]['meta'];
      final indicators = result[0]['indicators'];
      final quote = indicators?['quote']?[0];

      if (meta == null) return null;

      final currentPrice = (meta['regularMarketPrice'] ?? 0).toDouble();
      final previousClose = (meta['previousClose'] ?? meta['chartPreviousClose'] ?? currentPrice).toDouble();
      final change = currentPrice - previousClose;
      final changePercent = previousClose > 0 ? (change / previousClose) * 100 : 0;

      // Get volume from quote data
      final volumes = quote?['volume'] as List?;
      final volume = volumes?.isNotEmpty == true ? (volumes!.last ?? 0) : 0;

      return StockModel(
        symbol: originalSymbol.replaceAll('.NS', '').replaceAll('.BO', ''),
        name: _getCompanyName(originalSymbol),
        currentPrice: currentPrice,
        previousClose: previousClose,
        change: change,
        changePercent: changePercent.toDouble(),
        volume: volume is int ? volume : (volume as double).toInt(),
        high52Week: (meta['fiftyTwoWeekHigh'] ?? currentPrice * 1.2).toDouble(),
        low52Week: (meta['fiftyTwoWeekLow'] ?? currentPrice * 0.8).toDouble(),
        high: (meta['regularMarketDayHigh'] ?? currentPrice).toDouble(),
        low: (meta['regularMarketDayLow'] ?? currentPrice).toDouble(),
        open: (meta['regularMarketOpen'] ?? previousClose).toDouble(),
        sector: _getSector(originalSymbol),
      );
    } catch (e) {
      print('Error parsing stock data: $e');
      return null;
    }
  }

  /// Parse index data from Yahoo Finance response
  MarketIndex? _parseIndexData(Map<String, dynamic> data, String symbol, String name) {
    try {
      final chart = data['chart'];
      if (chart == null) return null;

      final result = chart['result'];
      if (result == null || result.isEmpty) return null;

      final meta = result[0]['meta'];
      if (meta == null) return null;

      final currentValue = (meta['regularMarketPrice'] ?? 0).toDouble();
      final previousClose = (meta['previousClose'] ?? meta['chartPreviousClose'] ?? currentValue).toDouble();
      final change = currentValue - previousClose;
      final changePercent = previousClose > 0 ? (change / previousClose) * 100 : 0;

      return MarketIndex(
        name: name,
        symbol: symbol,
        value: currentValue,
        change: change,
        changePercent: changePercent.toDouble(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error parsing index data: $e');
      return null;
    }
  }

  /// Parse candle data from Yahoo Finance response
  List<CandleData> _parseCandleData(Map<String, dynamic> data) {
    final candles = <CandleData>[];

    try {
      final chart = data['chart'];
      if (chart == null) return candles;

      final result = chart['result'];
      if (result == null || result.isEmpty) return candles;

      final timestamps = result[0]['timestamp'] as List?;
      final indicators = result[0]['indicators'];
      final quote = indicators?['quote']?[0];

      if (timestamps == null || quote == null) return candles;

      final opens = quote['open'] as List?;
      final highs = quote['high'] as List?;
      final lows = quote['low'] as List?;
      final closes = quote['close'] as List?;
      final volumes = quote['volume'] as List?;

      for (int i = 0; i < timestamps.length; i++) {
        final open = opens?[i];
        final high = highs?[i];
        final low = lows?[i];
        final close = closes?[i];
        final volume = volumes?[i];

        // Skip if any value is null
        if (open == null || high == null || low == null || close == null) {
          continue;
        }

        candles.add(CandleData(
          time: DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000),
          open: (open as num).toDouble(),
          high: (high as num).toDouble(),
          low: (low as num).toDouble(),
          close: (close as num).toDouble(),
          volume: volume is int ? volume : (volume as num?)?.toInt() ?? 0,
        ));
      }
    } catch (e) {
      print('Error parsing candle data: $e');
    }

    return candles;
  }

  /// Get company name from symbol
  String _getCompanyName(String symbol) {
    final names = {
      'RELIANCE': 'Reliance Industries',
      'TCS': 'Tata Consultancy Services',
      'HDFCBANK': 'HDFC Bank',
      'INFY': 'Infosys',
      'ICICIBANK': 'ICICI Bank',
      'HINDUNILVR': 'Hindustan Unilever',
      'SBIN': 'State Bank of India',
      'BHARTIARTL': 'Bharti Airtel',
      'ITC': 'ITC Limited',
      'KOTAKBANK': 'Kotak Mahindra Bank',
      'LT': 'Larsen & Toubro',
      'AXISBANK': 'Axis Bank',
      'ASIANPAINT': 'Asian Paints',
      'MARUTI': 'Maruti Suzuki',
      'TITAN': 'Titan Company',
      'WIPRO': 'Wipro',
      'SUNPHARMA': 'Sun Pharma',
      'ULTRACEMCO': 'UltraTech Cement',
      'TATAMOTORS': 'Tata Motors',
      'POWERGRID': 'Power Grid Corp',
      'BAJFINANCE': 'Bajaj Finance',
      'HCLTECH': 'HCL Technologies',
      'ADANIENT': 'Adani Enterprises',
      'NTPC': 'NTPC Limited',
      'ONGC': 'Oil & Natural Gas Corp',
      'TATASTEEL': 'Tata Steel',
      'JSWSTEEL': 'JSW Steel',
      'TECHM': 'Tech Mahindra',
      'BAJAJFINSV': 'Bajaj Finserv',
      'NESTLEIND': 'Nestle India',
    };

    final cleanSymbol = symbol.replaceAll('.NS', '').replaceAll('.BO', '');
    return names[cleanSymbol] ?? cleanSymbol;
  }

  /// Get sector from symbol
  String _getSector(String symbol) {
    final sectors = {
      'RELIANCE': 'Oil & Gas',
      'TCS': 'IT',
      'HDFCBANK': 'Banking',
      'INFY': 'IT',
      'ICICIBANK': 'Banking',
      'HINDUNILVR': 'FMCG',
      'SBIN': 'Banking',
      'BHARTIARTL': 'Telecom',
      'ITC': 'FMCG',
      'KOTAKBANK': 'Banking',
      'LT': 'Infrastructure',
      'AXISBANK': 'Banking',
      'ASIANPAINT': 'Consumer',
      'MARUTI': 'Auto',
      'TITAN': 'Consumer',
      'WIPRO': 'IT',
      'SUNPHARMA': 'Pharma',
      'ULTRACEMCO': 'Cement',
      'TATAMOTORS': 'Auto',
      'POWERGRID': 'Power',
      'BAJFINANCE': 'Finance',
      'HCLTECH': 'IT',
      'TECHM': 'IT',
      'TATASTEEL': 'Metals',
      'JSWSTEEL': 'Metals',
    };

    final cleanSymbol = symbol.replaceAll('.NS', '').replaceAll('.BO', '');
    return sectors[cleanSymbol] ?? 'Others';
  }
}
