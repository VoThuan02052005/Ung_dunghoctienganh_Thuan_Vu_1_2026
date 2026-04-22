class Student {
  String studentId;
  String fullname;
  String currentLesson;
  int completedLessons;
  double studyHours;
  bool isPremium;
  List<String> topics;
  List<Map<String, String>> vocabulary;
  Map<String, int> skillScores;

  Student({
    required this.studentId,
    required this.fullname,
    required this.currentLesson,
    required this.completedLessons,
    required this.studyHours,
    required this.isPremium,
    required this.topics,
    required this.vocabulary,
    required this.skillScores,
  });

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
    if (skillScores.isEmpty) return 0.0;

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
