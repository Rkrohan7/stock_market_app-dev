import '../data/models/news_model.dart';

class NewsService {
  // Demo news data
  final List<NewsModel> _demoNews = [
    NewsModel(
      id: '1',
      title: 'Sensex Hits All-Time High, Crosses 74,000 Mark',
      description: 'Indian benchmark indices reached new highs driven by strong FII inflows and positive global cues.',
      content: 'The BSE Sensex crossed the 74,000 mark for the first time, driven by strong buying in banking and IT stocks. Foreign Institutional Investors (FIIs) have been net buyers for the past five consecutive sessions.',
      source: 'Economic Times',
      imageUrl: 'https://picsum.photos/800/400?random=1',
      category: 'Market',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      relatedSymbols: ['HDFCBANK', 'TCS', 'RELIANCE'],
      isBreaking: true,
    ),
    NewsModel(
      id: '2',
      title: 'RBI Maintains Repo Rate at 6.5%, GDP Growth at 7%',
      description: 'The Reserve Bank of India kept the key policy rate unchanged and maintained its growth outlook.',
      content: 'The RBI monetary policy committee decided to keep the repo rate unchanged at 6.5% for the seventh consecutive time. The central bank maintained its GDP growth projection at 7% for FY25.',
      source: 'Mint',
      imageUrl: 'https://picsum.photos/800/400?random=2',
      category: 'Economy',
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      relatedSymbols: ['SBIN', 'ICICIBANK', 'AXISBANK'],
    ),
    NewsModel(
      id: '3',
      title: 'TCS Reports Strong Q4 Results, Revenue Up 15%',
      description: 'Tata Consultancy Services reported better-than-expected quarterly results with strong deal wins.',
      content: 'TCS reported a 15% year-on-year growth in revenue for Q4 FY24. The company also announced a dividend of Rs 28 per share. Total contract value (TCV) of deals signed was at an all-time high.',
      source: 'Business Standard',
      imageUrl: 'https://picsum.photos/800/400?random=3',
      category: 'Stocks',
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      relatedSymbols: ['TCS'],
    ),
    NewsModel(
      id: '4',
      title: 'Reliance Industries Plans Rs 75,000 Crore Green Energy Investment',
      description: 'RIL announces massive investment in renewable energy and new energy business.',
      content: 'Reliance Industries announced plans to invest Rs 75,000 crore in its new energy business over the next five years. The company aims to become carbon neutral by 2035.',
      source: 'CNBC',
      imageUrl: 'https://picsum.photos/800/400?random=4',
      category: 'Stocks',
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
      relatedSymbols: ['RELIANCE'],
    ),
    NewsModel(
      id: '5',
      title: 'Auto Sector Sees Record Sales in March 2024',
      description: 'Passenger vehicle sales hit record highs as companies reported strong March numbers.',
      content: 'The Indian automobile industry reported record sales in March 2024. Maruti Suzuki led the pack with over 1.8 lakh units sold, while Tata Motors showed the highest growth rate.',
      source: 'Auto Car',
      imageUrl: 'https://picsum.photos/800/400?random=5',
      category: 'Stocks',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      relatedSymbols: ['MARUTI', 'TATAMOTORS'],
    ),
    NewsModel(
      id: '6',
      title: 'IT Stocks Rally as Dollar Strengthens Against Rupee',
      description: 'Information Technology stocks gained as the rupee weakened against the US dollar.',
      content: 'IT stocks rallied 2-3% as the Indian rupee weakened to 83.50 against the US dollar. Export-oriented IT companies benefit from rupee depreciation as majority of their revenues are in dollars.',
      source: 'Financial Express',
      imageUrl: 'https://picsum.photos/800/400?random=6',
      category: 'Market',
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      relatedSymbols: ['TCS', 'INFY', 'WIPRO'],
    ),
    NewsModel(
      id: '7',
      title: 'New IPO: XYZ Technologies Opens for Subscription',
      description: 'The Rs 2,000 crore IPO received strong response on day one with 3x subscription.',
      content: 'XYZ Technologies IPO opened for subscription today and received 3x subscription on day one. The price band is set at Rs 450-480 per share. Analysts recommend subscribing for long-term gains.',
      source: 'Moneycontrol',
      imageUrl: 'https://picsum.photos/800/400?random=7',
      category: 'IPO',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NewsModel(
      id: '8',
      title: 'Banking Sector Outlook: NPAs at Multi-Year Low',
      description: 'Indian banks report lowest NPA levels in a decade, asset quality improves significantly.',
      content: 'The gross NPA ratio of scheduled commercial banks fell to 3.2%, the lowest in the last decade. Improved credit assessment and recovery mechanisms have contributed to better asset quality.',
      source: 'Reuters',
      imageUrl: 'https://picsum.photos/800/400?random=8',
      category: 'Economy',
      publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      relatedSymbols: ['SBIN', 'HDFCBANK', 'ICICIBANK', 'AXISBANK'],
    ),
  ];

  // Get all news
  Future<List<NewsModel>> getAllNews({int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoNews.take(limit).toList();
  }

  // Alias for getAllNews
  Future<List<NewsModel>> getLatestNews({int limit = 20}) async {
    return getAllNews(limit: limit);
  }

  // Get news by category
  Future<List<NewsModel>> getNewsByCategory(String category, {int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == 'All') {
      return _demoNews.take(limit).toList();
    }
    return _demoNews
        .where((news) => news.category == category)
        .take(limit)
        .toList();
  }

  // Get news for specific stock
  Future<List<NewsModel>> getNewsForStock(String symbol, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoNews
        .where((news) => news.relatedSymbols.contains(symbol))
        .take(limit)
        .toList();
  }

  // Get breaking news
  Future<List<NewsModel>> getBreakingNews() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _demoNews.where((news) => news.isBreaking).toList();
  }

  // Get news by ID
  Future<NewsModel?> getNewsById(String newsId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _demoNews.firstWhere((news) => news.id == newsId);
    } catch (e) {
      return null;
    }
  }

  // Search news
  Future<List<NewsModel>> searchNews(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _demoNews.where((news) {
      return news.title.toLowerCase().contains(lowerQuery) ||
          news.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
