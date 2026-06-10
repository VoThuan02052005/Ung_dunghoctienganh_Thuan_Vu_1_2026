// Model: Lesson (Bài học)
import 'vocabulary.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String topic;
  final String level;
  final String imageEmoji;
  final List<Vocabulary> vocabularies;
  int progress; // 0–100

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.level,
    required this.imageEmoji,
    required this.vocabularies,
    this.progress = 0,
  });

  // Tính tiến độ từ số từ đã học
  double get progressValue {
    if (vocabularies.isEmpty) return 0;
    final learned = vocabularies.where((v) => v.isLearned).length;
    return learned / vocabularies.length;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'topic': topic,
      'level': level,
      'imageEmoji': imageEmoji,
      'progress': progress,
    };
  }
}
