// Model: Vocabulary (Từ vựng)
class Vocabulary {
  final String id;
  final String word;
  final String pronunciation;
  final String meaning;
  final String example;
  final String topic;
  final String level; // beginner / intermediate / advanced
  bool isLearned;
  bool isFavorite;

  Vocabulary({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.example,
    required this.topic,
    required this.level,
    this.isLearned = false,
    this.isFavorite = false,
  });

  // Chuyển sang Map để lưu vào "database" (SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'example': example,
      'topic': topic,
      'level': level,
      'isLearned': isLearned,
      'isFavorite': isFavorite,
    };
  }

  // Tạo từ Map
  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      id: map['id'],
      word: map['word'],
      pronunciation: map['pronunciation'],
      meaning: map['meaning'],
      example: map['example'],
      topic: map['topic'],
      level: map['level'],
      isLearned: map['isLearned'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
