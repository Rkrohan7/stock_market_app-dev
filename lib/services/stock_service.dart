import 'dart:async';
import 'dart:math';
import '../data/models/stock_model.dart';
import '../core/enums/enums.dart';
import 'market_api_service.dart';

class StockService {
  final MarketApiService _apiService = MarketApiService();

  // List of NSE stock symbols to track
  final List<String> _stockSymbols = [
    'RELIANCE', 'TCS', 'HDFCBANK', 'INFY', 'ICICIBANK',
    'HINDUNILVR', 'SBIN', 'BHARTIARTL', 'ITC', 'KOTAKBANK',
    'LT', 'AXISBANK', 'ASIANPAINT', 'MARUTI', 'TITAN',
    'WIPRO', 'SUNPHARMA', 'ULTRACEMCO', 'TATAMOTORS', 'POWERGRID',
  ];

  // Cache for stocks data
  List<StockModel>? _cachedStocks;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 1);

  // Get all stocks (with caching)
  Future<List<StockModel>> getAllStocks() async {
    // Return cached data if available and fresh
    if (_cachedStocks != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return _cachedStocks!;
      }
    }

    try {
      final stocks = await _apiService.getMultipleQuotes(_stockSymbols);
      if (stocks.isNotEmpty) {
        _cachedStocks = stocks;
        _lastFetchTime = DateTime.now();
        return stocks;
      }
    } catch (e) {
      // If API fails, return cached data or demo data
      if (_cachedStocks != null) {
        return _cachedStocks!;
      }
    }

    // Fallback to demo data if API fails
    return _getDemoStocks();
  }

  // Search stocks
  Future<List<StockModel>> searchStocks(String query) async {
    final stocks = await getAllStocks();
    final lowerQuery = query.toLowerCase();
    return stocks.where((stock) {
      return stock.symbol.toLowerCase().contains(lowerQuery) ||
          stock.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get stock by symbol
  Future<StockModel?> getStockBySymbol(String symbol) async {
    try {
      // Try to get from API first
      final stock = await _apiService.getStockQuote(symbol);
      if (stock != null) return stock;
    } catch (e) {
      // Fallback to cached/demo data
    }

    // Fallback to cached data
    final stocks = await getAllStocks();
    try {
      return stocks.firstWhere(
        (stock) => stock.symbol.toUpperCase() == symbol.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get stock details with description
  Future<StockModel?> getStockDetails(String symbol) async {
    final stock = await getStockBySymbol(symbol);
    if (stock == null) return null;

    // Add description
    final descriptions = {
      'RELIANCE': 'Reliance Industries Limited is an Indian multinational conglomerate, headquartered in Mumbai. It has diverse businesses including energy, petrochemicals, natural gas, retail, telecommunications, mass media, and textiles.',
      'TCS': 'Tata Consultancy Services is an Indian multinational information technology services and consulting company headquartered in Mumbai. It is a part of the Tata Group and operates in 150 locations across 46 countries.',
      'HDFCBANK': 'HDFC Bank Limited is an Indian banking and financial services company headquartered in Mumbai. It is India\'s largest private sector bank by assets and world\'s 10th largest bank by market capitalisation.',
      'INFY': 'Infosys Limited is an Indian multinational information technology company that provides business consulting, information technology and outsourcing services.',
      'ICICIBANK': 'ICICI Bank Limited is an Indian multinational bank and financial services company headquartered in Mumbai with its registered office in Vadodara.',
      'HINDUNILVR': 'Hindustan Unilever Limited is a British-Indian fast-moving consumer goods company headquartered in Mumbai. It is a subsidiary of Unilever, a British company.',
      'SBIN': 'State Bank of India is an Indian multinational public sector bank and financial services statutory body headquartered in Mumbai.',
      'BHARTIARTL': 'Bharti Airtel Limited is an Indian multinational telecommunications services company headquartered in New Delhi. It operates in 18 countries across South Asia and Africa.',
      'ITC': 'ITC Limited is an Indian multinational conglomerate company headquartered in Kolkata. ITC has a diversified presence across industries such as FMCG, Hotels, Paperboards & Packaging, Agri Business and Information Technology.',
      'KOTAKBANK': 'Kotak Mahindra Bank Limited is an Indian banking and financial services company headquartered in Mumbai.',
      'LT': 'Larsen & Toubro is an Indian multinational engaged in EPC Projects, Hi-Tech Manufacturing and Services. It operates in over 50 countries worldwide.',
      'AXISBANK': 'Axis Bank is the third largest private sector bank in India. The Bank offers the entire spectrum of financial services to customer segments.',
      'ASIANPAINT': 'Asian Paints Limited is an Indian multinational paint company headquartered in Mumbai. It is Indias largest and Asias second largest paint company.',
      'MARUTI': 'Maruti Suzuki India Limited is an Indian automobile manufacturer, headquartered in New Delhi. It is the largest car manufacturer in India.',
      'TITAN': 'Titan Company Limited is an Indian luxury goods company that mainly manufactures watches, jewellery, precision engineering, eyewear and other accessories.',
      'WIPRO': 'Wipro Limited is an Indian multinational corporation that provides information technology, consulting and business process services.',
      'SUNPHARMA': 'Sun Pharmaceutical Industries Limited is an Indian multinational pharmaceutical company headquartered in Mumbai.',
      'ULTRACEMCO': 'UltraTech Cement Limited is an Indian cement company and is the largest manufacturer of grey cement, ready mix concrete and white cement in India.',
      'TATAMOTORS': 'Tata Motors Limited is an Indian multinational automotive manufacturing company, headquartered in Mumbai. It is a part of the Tata Group.',
      'POWERGRID': 'Power Grid Corporation of India Limited is an Indian statutory corporation under the ownership of Ministry of Power, Government of India.',
    };

    return stock.copyWith(
      description: descriptions[stock.symbol] ?? 'A leading company listed on the National Stock Exchange of India.',
    );
  }

  // Get market indices
  Future<List<MarketIndex>> getMarketIndices() async {
    try {
      final indices = await _apiService.getMarketIndices();
      if (indices.isNotEmpty) {
        return indices;
      }
    } catch (e) {
      // Fallback to demo data
    }

    // Demo indices fallback
    return [
      MarketIndex(name: 'NIFTY 50', symbol: 'NIFTY50', value: 22456.80, change: 156.45, changePercent: 0.70, lastUpdated: DateTime.now()),
      MarketIndex(name: 'SENSEX', symbol: 'SENSEX', value: 73845.25, change: 523.80, changePercent: 0.71, lastUpdated: DateTime.now()),
      MarketIndex(name: 'NIFTY BANK', symbol: 'BANKNIFTY', value: 47234.50, change: -234.60, changePercent: -0.49, lastUpdated: DateTime.now()),
    ];
  }

  // Get top gainers
  Future<List<StockModel>> getTopGainers({int limit = 5}) async {
    final stocks = await getAllStocks();
    final sorted = List<StockModel>.from(stocks)
      ..sort((a, b) => b.changePercent.compareTo(a.changePercent));
    return sorted.take(limit).toList();
  }

  // Get top losers
  Future<List<StockModel>> getTopLosers({int limit = 5}) async {
    final stocks = await getAllStocks();
    final sorted = List<StockModel>.from(stocks)
      ..sort((a, b) => a.changePercent.compareTo(b.changePercent));
    return sorted.take(limit).toList();
  }

  // Get most active by volume
  Future<List<StockModel>> getMostActive({int limit = 5}) async {
    final stocks = await getAllStocks();
    final sorted = List<StockModel>.from(stocks)
      ..sort((a, b) => b.volume.compareTo(a.volume));
    return sorted.take(limit).toList();
  }

  // Get stocks by sector
  Future<List<StockModel>> getStocksBySector(String sector) async {
    final stocks = await getAllStocks();
    return stocks.where((stock) => stock.sector == sector).toList();
  }

  // Get candle data for charts
  Future<List<CandleData>> getCandleData(String symbol, ChartInterval interval) async {
    try {
      // Map ChartInterval to Yahoo Finance parameters
      String yahooInterval;
      String range;

      switch (interval) {
        case ChartInterval.m1:
          yahooInterval = '1m';
          range = '1d';
          break;
        case ChartInterval.m5:
          yahooInterval = '5m';
          range = '1d';
          break;
        case ChartInterval.m15:
          yahooInterval = '15m';
          range = '5d';
          break;
        case ChartInterval.m30:
          yahooInterval = '30m';
          range = '5d';
          break;
        case ChartInterval.h1:
          yahooInterval = '1h';
          range = '1mo';
          break;
        case ChartInterval.h4:
          yahooInterval = '4h';
          range = '1mo';
          break;
        case ChartInterval.d1:
          yahooInterval = '1d';
          range = '3mo';
          break;
        case ChartInterval.w1:
          yahooInterval = '1wk';
          range = '1y';
          break;
        case ChartInterval.mo1:
          yahooInterval = '1mo';
          range = '5y';
          break;
      }

      final candles = await _apiService.getCandleData(
        symbol,
        interval: yahooInterval,
        range: range,
      );

      if (candles.isNotEmpty) {
        return candles;
      }
    } catch (e) {
      // Fallback to demo data
    }

    // Generate demo candle data if API fails
    return _generateDemoCandleData(symbol, interval);
  }

  // Generate demo market depth
  Future<MarketDepth> getMarketDepth(String symbol) async {
    final stock = await getStockBySymbol(symbol);
    if (stock == null) {
      return MarketDepth(bids: [], asks: []);
    }

    final random = Random();
    final List<DepthLevel> bids = [];
    final List<DepthLevel> asks = [];

    double bidPrice = stock.currentPrice - 0.05;
    double askPrice = stock.currentPrice + 0.05;

    for (int i = 0; i < 5; i++) {
      bids.add(DepthLevel(
        price: bidPrice - (i * 0.05),
        quantity: random.nextInt(10000) + 1000,
        orders: random.nextInt(50) + 5,
      ));

      asks.add(DepthLevel(
        price: askPrice + (i * 0.05),
        quantity: random.nextInt(10000) + 1000,
        orders: random.nextInt(50) + 5,
      ));
    }

    return MarketDepth(bids: bids, asks: asks);
  }

  // Stream for live price updates
  Stream<StockModel> streamStockPrice(String symbol) {
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      final stock = await getStockBySymbol(symbol);
      return stock ?? _getDemoStocks().first;
    }).asyncMap((future) => future);
  }

  // Demo stocks fallback
  List<StockModel> _getDemoStocks() {
    return [
      StockModel(symbol: 'RELIANCE', name: 'Reliance Industries', currentPrice: 2456.75, previousClose: 2430.50, volume: 5432100, high52Week: 2856.15, low52Week: 2180.00, sector: 'Oil & Gas'),
      StockModel(symbol: 'TCS', name: 'Tata Consultancy Services', currentPrice: 3789.20, previousClose: 3756.80, volume: 2341000, high52Week: 4045.00, low52Week: 3056.00, sector: 'IT'),
      StockModel(symbol: 'HDFCBANK', name: 'HDFC Bank', currentPrice: 1654.30, previousClose: 1678.45, volume: 4521000, high52Week: 1757.80, low52Week: 1363.55, sector: 'Banking'),
      StockModel(symbol: 'INFY', name: 'Infosys', currentPrice: 1523.45, previousClose: 1498.20, volume: 3245000, high52Week: 1731.85, low52Week: 1215.45, sector: 'IT'),
      StockModel(symbol: 'ICICIBANK', name: 'ICICI Bank', currentPrice: 1045.60, previousClose: 1032.15, volume: 6234000, high52Week: 1142.00, low52Week: 867.20, sector: 'Banking'),
      StockModel(symbol: 'HINDUNILVR', name: 'Hindustan Unilever', currentPrice: 2534.80, previousClose: 2567.30, volume: 1234000, high52Week: 2859.30, low52Week: 2172.05, sector: 'FMCG'),
      StockModel(symbol: 'SBIN', name: 'State Bank of India', currentPrice: 628.45, previousClose: 615.20, volume: 8765000, high52Week: 692.00, low52Week: 499.35, sector: 'Banking'),
      StockModel(symbol: 'BHARTIARTL', name: 'Bharti Airtel', currentPrice: 1234.55, previousClose: 1245.80, volume: 2345000, high52Week: 1358.00, low52Week: 824.50, sector: 'Telecom'),
      StockModel(symbol: 'ITC', name: 'ITC Limited', currentPrice: 456.75, previousClose: 448.30, volume: 12340000, high52Week: 499.70, low52Week: 330.00, sector: 'FMCG'),
      StockModel(symbol: 'KOTAKBANK', name: 'Kotak Mahindra Bank', currentPrice: 1789.30, previousClose: 1812.45, volume: 1523000, high52Week: 1945.00, low52Week: 1644.65, sector: 'Banking'),
      StockModel(symbol: 'LT', name: 'Larsen & Toubro', currentPrice: 3245.60, previousClose: 3198.75, volume: 987000, high52Week: 3515.00, low52Week: 2617.00, sector: 'Infrastructure'),
      StockModel(symbol: 'AXISBANK', name: 'Axis Bank', currentPrice: 1123.45, previousClose: 1145.60, volume: 3456000, high52Week: 1234.00, low52Week: 876.50, sector: 'Banking'),
      StockModel(symbol: 'ASIANPAINT', name: 'Asian Paints', currentPrice: 2876.30, previousClose: 2834.15, volume: 654000, high52Week: 3590.00, low52Week: 2670.00, sector: 'Consumer'),
      StockModel(symbol: 'MARUTI', name: 'Maruti Suzuki', currentPrice: 10456.80, previousClose: 10234.50, volume: 345000, high52Week: 11750.00, low52Week: 8350.00, sector: 'Auto'),
      StockModel(symbol: 'TITAN', name: 'Titan Company', currentPrice: 3234.55, previousClose: 3287.40, volume: 876000, high52Week: 3540.00, low52Week: 2625.00, sector: 'Consumer'),
      StockModel(symbol: 'WIPRO', name: 'Wipro', currentPrice: 456.30, previousClose: 448.75, volume: 4567000, high52Week: 545.00, low52Week: 351.00, sector: 'IT'),
      StockModel(symbol: 'SUNPHARMA', name: 'Sun Pharma', currentPrice: 1234.60, previousClose: 1256.30, volume: 2134000, high52Week: 1385.00, low52Week: 946.00, sector: 'Pharma'),
      StockModel(symbol: 'ULTRACEMCO', name: 'UltraTech Cement', currentPrice: 9876.45, previousClose: 9765.30, volume: 234000, high52Week: 10845.00, low52Week: 7020.00, sector: 'Cement'),
      StockModel(symbol: 'TATAMOTORS', name: 'Tata Motors', currentPrice: 876.50, previousClose: 845.30, volume: 7654000, high52Week: 1042.00, low52Week: 555.00, sector: 'Auto'),
      StockModel(symbol: 'POWERGRID', name: 'Power Grid Corp', currentPrice: 287.45, previousClose: 282.60, volume: 5432000, high52Week: 318.00, low52Week: 197.00, sector: 'Power'),
    ];
  }

  // Generate demo candle data
  List<CandleData> _generateDemoCandleData(String symbol, ChartInterval interval) {
    final random = Random();
    final stocks = _getDemoStocks();
    final stock = stocks.firstWhere(
      (s) => s.symbol == symbol,
      orElse: () => stocks.first,
    );

    final List<CandleData> candles = [];
    double basePrice = stock.currentPrice;
    DateTime time = DateTime.now();

    for (int i = 99; i >= 0; i--) {
      final volatility = basePrice * 0.02;
      final open = basePrice + (random.nextDouble() - 0.5) * volatility;
      final close = open + (random.nextDouble() - 0.5) * volatility;
      final high = max(open, close) + random.nextDouble() * volatility * 0.5;
      final low = min(open, close) - random.nextDouble() * volatility * 0.5;
      final volume = (random.nextInt(100000) + 50000);

      candles.add(CandleData(
        time: time.subtract(Duration(minutes: interval.duration.inMinutes * i)),
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));

      basePrice = close;
    }

    return candles;
  }
}
