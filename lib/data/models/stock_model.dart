class StockModel {
  final String symbol;
  final String name;
  final String exchange;
  final double currentPrice;
  final double previousClose;
  final double change;
  final double changePercent;
  final double open;
  final double high;
  final double low;
  final int volume;
  final double high52Week;
  final double low52Week;
  final double marketCap;
  final double peRatio;
  final double pbRatio;
  final double roe;
  final double eps;
  final double dividendYield;
  final String sector;
  final String industry;
  final String description;
  final DateTime? lastUpdated;

  StockModel({
    required this.symbol,
    required this.name,
    this.exchange = 'NSE',
    required this.currentPrice,
    required this.previousClose,
    double? change,
    double? changePercent,
    this.open = 0,
    this.high = 0,
    this.low = 0,
    this.volume = 0,
    this.high52Week = 0,
    this.low52Week = 0,
    this.marketCap = 0,
    this.peRatio = 0,
    this.pbRatio = 0,
    this.roe = 0,
    this.eps = 0,
    this.dividendYield = 0,
    this.sector = '',
    this.industry = '',
    this.description = '',
    this.lastUpdated,
  })  : change = change ?? (currentPrice - previousClose),
        changePercent = changePercent ??
            ((previousClose != 0)
                ? ((currentPrice - previousClose) / previousClose) * 100
                : 0);

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      exchange: json['exchange'] as String? ?? 'NSE',
      currentPrice: (json['currentPrice'] as num).toDouble(),
      previousClose: (json['previousClose'] as num).toDouble(),
      change: (json['change'] as num?)?.toDouble(),
      changePercent: (json['changePercent'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble() ?? 0,
      high: (json['high'] as num?)?.toDouble() ?? 0,
      low: (json['low'] as num?)?.toDouble() ?? 0,
      volume: (json['volume'] as num?)?.toInt() ?? 0,
      high52Week: (json['high52Week'] as num?)?.toDouble() ?? 0,
      low52Week: (json['low52Week'] as num?)?.toDouble() ?? 0,
      marketCap: (json['marketCap'] as num?)?.toDouble() ?? 0,
      peRatio: (json['peRatio'] as num?)?.toDouble() ?? 0,
      pbRatio: (json['pbRatio'] as num?)?.toDouble() ?? 0,
      roe: (json['roe'] as num?)?.toDouble() ?? 0,
      eps: (json['eps'] as num?)?.toDouble() ?? 0,
      dividendYield: (json['dividendYield'] as num?)?.toDouble() ?? 0,
      sector: json['sector'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'exchange': exchange,
      'currentPrice': currentPrice,
      'previousClose': previousClose,
      'change': change,
      'changePercent': changePercent,
      'open': open,
      'high': high,
      'low': low,
      'volume': volume,
      'high52Week': high52Week,
      'low52Week': low52Week,
      'marketCap': marketCap,
      'peRatio': peRatio,
      'pbRatio': pbRatio,
      'roe': roe,
      'eps': eps,
      'dividendYield': dividendYield,
      'sector': sector,
      'industry': industry,
      'description': description,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  bool get isPositive => change >= 0;

  StockModel copyWith({
    String? symbol,
    String? name,
    String? exchange,
    double? currentPrice,
    double? previousClose,
    double? change,
    double? changePercent,
    double? open,
    double? high,
    double? low,
    int? volume,
    double? high52Week,
    double? low52Week,
    double? marketCap,
    double? peRatio,
    double? pbRatio,
    double? roe,
    double? eps,
    double? dividendYield,
    String? sector,
    String? industry,
    String? description,
    DateTime? lastUpdated,
  }) {
    return StockModel(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      exchange: exchange ?? this.exchange,
      currentPrice: currentPrice ?? this.currentPrice,
      previousClose: previousClose ?? this.previousClose,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      high52Week: high52Week ?? this.high52Week,
      low52Week: low52Week ?? this.low52Week,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
      pbRatio: pbRatio ?? this.pbRatio,
      roe: roe ?? this.roe,
      eps: eps ?? this.eps,
      dividendYield: dividendYield ?? this.dividendYield,
      sector: sector ?? this.sector,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Market Index Model (NIFTY, SENSEX)
class MarketIndex {
  final String name;
  final String symbol;
  final double value;
  final double change;
  final double changePercent;
  final DateTime lastUpdated;

  MarketIndex({
    required this.name,
    required this.symbol,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.lastUpdated,
  });

  factory MarketIndex.fromJson(Map<String, dynamic> json) {
    return MarketIndex(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  bool get isPositive => change >= 0;
}

// Candle Data for Charts
class CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      time: DateTime.parse(json['time'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
    );
  }

  bool get isBullish => close >= open;
}

// Market Depth
class MarketDepth {
  final List<DepthLevel> bids;
  final List<DepthLevel> asks;

  MarketDepth({
    required this.bids,
    required this.asks,
  });

  factory MarketDepth.fromJson(Map<String, dynamic> json) {
    return MarketDepth(
      bids: (json['bids'] as List)
          .map((e) => DepthLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      asks: (json['asks'] as List)
          .map((e) => DepthLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DepthLevel {
  final double price;
  final int quantity;
  final int orders;

  DepthLevel({
    required this.price,
    required this.quantity,
    required this.orders,
  });

  factory DepthLevel.fromJson(Map<String, dynamic> json) {
    return DepthLevel(
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      orders: (json['orders'] as num).toInt(),
    );
  }
}
