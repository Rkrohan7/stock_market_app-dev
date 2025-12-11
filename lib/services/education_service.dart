import '../data/models/education_model.dart';
import '../core/enums/enums.dart';

class EducationService {
  // Demo courses
  final List<CourseModel> _demoCourses = [
    CourseModel(
      id: '1',
      title: 'Stock Market Basics',
      description: 'Learn the fundamentals of stock market investing from scratch.',
      contentType: ContentType.video,
      difficulty: 'Beginner',
      durationMinutes: 120,
      enrolledCount: 15420,
      rating: 4.8,
      lessons: [
        LessonModel(id: '1-1', courseId: '1', title: 'What is Stock Market?', content: 'Introduction to stock markets and how they work.', orderIndex: 0, durationMinutes: 15),
        LessonModel(id: '1-2', courseId: '1', title: 'Types of Stocks', content: 'Learn about different types of stocks - common, preferred, blue-chip, penny stocks.', orderIndex: 1, durationMinutes: 20),
        LessonModel(id: '1-3', courseId: '1', title: 'Stock Exchanges in India', content: 'Overview of NSE, BSE, and how trading works.', orderIndex: 2, durationMinutes: 15),
        LessonModel(id: '1-4', courseId: '1', title: 'How to Open a Demat Account', content: 'Step-by-step guide to opening a trading account.', orderIndex: 3, durationMinutes: 20),
        LessonModel(id: '1-5', courseId: '1', title: 'Placing Your First Order', content: 'Learn to place buy and sell orders.', orderIndex: 4, durationMinutes: 25),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    CourseModel(
      id: '2',
      title: 'Technical Analysis Masterclass',
      description: 'Master chart patterns, indicators, and price action trading.',
      contentType: ContentType.video,
      difficulty: 'Intermediate',
      durationMinutes: 300,
      enrolledCount: 8756,
      rating: 4.7,
      isPremium: true,
      lessons: [
        LessonModel(id: '2-1', courseId: '2', title: 'Introduction to Charts', content: 'Understanding candlestick, bar, and line charts.', orderIndex: 0, durationMinutes: 25),
        LessonModel(id: '2-2', courseId: '2', title: 'Support and Resistance', content: 'Identifying key price levels.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '2-3', courseId: '2', title: 'Chart Patterns', content: 'Head & shoulders, double tops, triangles, and more.', orderIndex: 2, durationMinutes: 45),
        LessonModel(id: '2-4', courseId: '2', title: 'Moving Averages', content: 'SMA, EMA, and crossover strategies.', orderIndex: 3, durationMinutes: 35),
        LessonModel(id: '2-5', courseId: '2', title: 'RSI and MACD', content: 'Momentum indicators explained.', orderIndex: 4, durationMinutes: 40),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    CourseModel(
      id: '3',
      title: 'Fundamental Analysis',
      description: 'Learn to analyze company financials and value stocks.',
      contentType: ContentType.article,
      difficulty: 'Intermediate',
      durationMinutes: 180,
      enrolledCount: 6234,
      rating: 4.6,
      lessons: [
        LessonModel(id: '3-1', courseId: '3', title: 'Reading Financial Statements', content: 'Balance sheet, P&L, and cash flow analysis.', orderIndex: 0, durationMinutes: 30),
        LessonModel(id: '3-2', courseId: '3', title: 'Key Ratios', content: 'P/E, P/B, ROE, ROCE, and debt ratios.', orderIndex: 1, durationMinutes: 35),
        LessonModel(id: '3-3', courseId: '3', title: 'Valuation Methods', content: 'DCF, comparable analysis, and asset-based valuation.', orderIndex: 2, durationMinutes: 40),
        LessonModel(id: '3-4', courseId: '3', title: 'Industry Analysis', content: 'Understanding sector dynamics and competitive advantage.', orderIndex: 3, durationMinutes: 35),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    CourseModel(
      id: '4',
      title: 'Intraday Trading Strategies',
      description: 'Learn profitable day trading strategies and risk management.',
      contentType: ContentType.video,
      difficulty: 'Advanced',
      durationMinutes: 240,
      enrolledCount: 4521,
      rating: 4.5,
      isPremium: true,
      lessons: [
        LessonModel(id: '4-1', courseId: '4', title: 'Intraday vs Delivery', content: 'Difference and when to use each.', orderIndex: 0, durationMinutes: 20),
        LessonModel(id: '4-2', courseId: '4', title: 'Stock Selection', content: 'How to pick stocks for intraday trading.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '4-3', courseId: '4', title: 'Entry and Exit Rules', content: 'Timing your trades for maximum profit.', orderIndex: 2, durationMinutes: 35),
        LessonModel(id: '4-4', courseId: '4', title: 'Risk Management', content: 'Position sizing and stop-loss strategies.', orderIndex: 3, durationMinutes: 40),
        LessonModel(id: '4-5', courseId: '4', title: 'Trading Psychology', content: 'Managing emotions and staying disciplined.', orderIndex: 4, durationMinutes: 30),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    CourseModel(
      id: '5',
      title: 'Options Trading for Beginners',
      description: 'Understanding options, Greeks, and basic strategies.',
      contentType: ContentType.video,
      difficulty: 'Advanced',
      durationMinutes: 280,
      enrolledCount: 3892,
      rating: 4.4,
      isPremium: true,
      lessons: [
        LessonModel(id: '5-1', courseId: '5', title: 'What are Options?', content: 'Call and Put options explained.', orderIndex: 0, durationMinutes: 25),
        LessonModel(id: '5-2', courseId: '5', title: 'Options Terminology', content: 'Strike price, premium, expiry, ITM/ATM/OTM.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '5-3', courseId: '5', title: 'Option Greeks', content: 'Delta, Gamma, Theta, Vega explained.', orderIndex: 2, durationMinutes: 40),
        LessonModel(id: '5-4', courseId: '5', title: 'Basic Strategies', content: 'Covered calls, protective puts, spreads.', orderIndex: 3, durationMinutes: 45),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // Demo daily tips
  final List<DailyTipModel> _demoTips = [
    DailyTipModel(id: '1', title: 'Diversification', content: 'Never put all your eggs in one basket. Spread your investments across different sectors and asset classes.', category: 'Risk Management', date: DateTime.now()),
    DailyTipModel(id: '2', title: 'Start with Blue Chips', content: 'As a beginner, start with large-cap, well-established companies before moving to mid and small caps.', category: 'Investing', date: DateTime.now().subtract(const Duration(days: 1))),
    DailyTipModel(id: '3', title: 'Set Stop Losses', content: 'Always set a stop-loss for every trade to limit your potential losses. Never trade without a exit plan.', category: 'Trading', date: DateTime.now().subtract(const Duration(days: 2))),
    DailyTipModel(id: '4', title: 'Avoid FOMO', content: 'Fear of Missing Out can lead to bad investment decisions. Stick to your investment thesis and avoid chasing momentum.', category: 'Psychology', date: DateTime.now().subtract(const Duration(days: 3))),
    DailyTipModel(id: '5', title: 'Regular Investing', content: 'SIP (Systematic Investment Plan) helps you invest regularly and benefits from rupee cost averaging.', category: 'Investing', date: DateTime.now().subtract(const Duration(days: 4))),
  ];

  // Get all courses
  Future<List<CourseModel>> getAllCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoCourses;
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _demoCourses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Get courses by difficulty
  Future<List<CourseModel>> getCoursesByDifficulty(String difficulty) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses
        .where((course) => course.difficulty == difficulty)
        .toList();
  }

  // Get free courses
  Future<List<CourseModel>> getFreeCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses.where((course) => !course.isPremium).toList();
  }

  // Get premium courses
  Future<List<CourseModel>> getPremiumCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses.where((course) => course.isPremium).toList();
  }

  // Get daily tips
  Future<List<DailyTipModel>> getDailyTips({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoTips.take(limit).toList();
  }

  // Get today's tip
  Future<DailyTipModel?> getTodaysTip() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _demoTips.first;
  }

  // Search courses
  Future<List<CourseModel>> searchCourses(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _demoCourses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Generate demo quiz
  Future<QuizModel> getQuiz(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return QuizModel(
      id: 'quiz-$courseId',
      courseId: courseId,
      title: 'Course Quiz',
      questions: [
        QuizQuestion(
          id: 'q1',
          question: 'What does P/E ratio stand for?',
          options: ['Price to Earnings', 'Profit to Equity', 'Price to Equity', 'Profit to Earnings'],
          correctOptionIndex: 0,
          explanation: 'P/E ratio is Price to Earnings ratio, calculated by dividing market price by EPS.',
        ),
        QuizQuestion(
          id: 'q2',
          question: 'Which indicator shows overbought/oversold conditions?',
          options: ['MACD', 'RSI', 'Moving Average', 'Bollinger Bands'],
          correctOptionIndex: 1,
          explanation: 'RSI (Relative Strength Index) shows overbought (>70) and oversold (<30) conditions.',
        ),
        QuizQuestion(
          id: 'q3',
          question: 'What is a bullish candlestick pattern?',
          options: ['Hanging Man', 'Shooting Star', 'Hammer', 'Evening Star'],
          correctOptionIndex: 2,
          explanation: 'Hammer is a bullish reversal pattern that appears at the bottom of a downtrend.',
        ),
      ],
    );
  }
}
