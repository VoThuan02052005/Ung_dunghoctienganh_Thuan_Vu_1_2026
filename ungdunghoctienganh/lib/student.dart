class Student {
  String id;
  String name;
  String currentLesson;
  int completedLessons;
  double studyHours;
  bool isPremium;
  List<String> topics;
  List<Map<String, String>> vocabulary;
  Map<String, int> skillScores;

  Student({
    required this.id,
    required this.name,
    required this.currentLesson,
    required this.completedLessons,
    required this.studyHours,
    required this.isPremium,
    required this.topics,
    required this.vocabulary,
    required this.skillScores,
  });

  void showInfo() {
    print('ID: $id');
    print('Tên học viên: $name');
    print('Bài học hiện tại: $currentLesson');
    print('Số bài đã hoàn thành: $completedLessons');
    print('Tổng giờ học: $studyHours');
    print('Premium: ${isPremium ? "Có" : "Không"}');
    print('Chủ đề học: $topics');
    print('Từ vựng: $vocabulary');
    print('Điểm kỹ năng: $skillScores');
    print('---------------------------');
  }

  void updateLesson(String newLesson) {
    currentLesson = newLesson;
  }

  void addTopic(String topic) {
    topics.add(topic);
  }

  void addVocabulary(String word, String meaning) {
    vocabulary.add({
      'word': word,
      'meaning': meaning,
    });
  }

  double averageSkillScore() {
    if (skillScores.isEmpty) {
      return 0.0;
    }

    int total = 0;
    for (var score in skillScores.values) {
      total += score;
    }

    return total / skillScores.length;
  }

  void upgradePremium() {
    isPremium = true;
  }
}
