import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

// Alias for simpler use
typedef Course = CourseModel;

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final ContentType contentType;
  final String difficulty; // Beginner, Intermediate, Advanced
  final int durationMinutes;
  final List<LessonModel> lessons;
  final int enrolledCount;
  final double rating;
  final bool isPremium;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.contentType,
    this.difficulty = 'Beginner',
    required this.durationMinutes,
    required this.lessons,
    this.enrolledCount = 0,
    this.rating = 0,
    this.isPremium = false,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      contentType: ContentType.values.firstWhere(
        (e) => e.name == json['contentType'],
        orElse: () => ContentType.article,
      ),
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      lessons: (json['lessons'] as List?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'contentType': contentType.name,
      'difficulty': difficulty,
      'durationMinutes': durationMinutes,
      'lessons': lessons.map((e) => e.toJson()).toList(),
      'enrolledCount': enrolledCount,
      'rating': rating,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  int get totalLessons => lessons.length;

  // Aliases for views
  int get lessonsCount => totalLessons;
  String get duration => formattedDuration;
  String get level => difficulty;
  String get category => contentType.displayName;
  bool get isFeatured => rating >= 4.7;
  double get progress => 0.0; // Demo progress

  String get formattedDuration {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    } else {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      return mins > 0 ? '$hours hr $mins min' : '$hours hr';
    }
  }
}

class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final String? videoUrl;
  final int orderIndex;
  final int durationMinutes;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    this.videoUrl,
    required this.orderIndex,
    required this.durationMinutes,
    this.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      videoUrl: json['videoUrl'] as String?,
      orderIndex: (json['orderIndex'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'content': content,
      'videoUrl': videoUrl,
      'orderIndex': orderIndex,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
    };
  }
}

class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final List<QuizQuestion> questions;
  final int passingScore;
  final int timeLimit; // in minutes

  QuizModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.questions,
    this.passingScore = 60,
    this.timeLimit = 10,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      passingScore: (json['passingScore'] as num?)?.toInt() ?? 60,
      timeLimit: (json['timeLimit'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'questions': questions.map((e) => e.toJson()).toList(),
      'passingScore': passingScore,
      'timeLimit': timeLimit,
    };
  }

  int get totalQuestions => questions.length;
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List).map((e) => e as String).toList(),
      correctOptionIndex: (json['correctOptionIndex'] as num).toInt(),
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }

  String get correctAnswer => options[correctOptionIndex];
}

// Blog Model for Trading Education
class BlogModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String? authorImage;
  final String? thumbnailUrl;
  final String category;
  final String level; // Beginner, Intermediate, Advanced
  final int readTimeMinutes;
  final List<String> tags;
  final DateTime publishedAt;
  final int viewCount;
  final int likeCount;
  final bool isFeatured;

  BlogModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    this.authorImage,
    this.thumbnailUrl,
    required this.category,
    this.level = 'Beginner',
    required this.readTimeMinutes,
    this.tags = const [],
    required this.publishedAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.isFeatured = false,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      authorImage: json['authorImage'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      category: json['category'] as String,
      level: json['level'] as String? ?? 'Beginner',
      readTimeMinutes: (json['readTimeMinutes'] as num).toInt(),
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
      publishedAt: (json['publishedAt'] as Timestamp).toDate(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'author': author,
      'authorImage': authorImage,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'level': level,
      'readTimeMinutes': readTimeMinutes,
      'tags': tags,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'viewCount': viewCount,
      'likeCount': likeCount,
      'isFeatured': isFeatured,
    };
  }

  String get formattedReadTime => '$readTimeMinutes min read';
}

// Daily Tips
class DailyTipModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime date;

  DailyTipModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });

  factory DailyTipModel.fromJson(Map<String, dynamic> json) {
    return DailyTipModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }
}
