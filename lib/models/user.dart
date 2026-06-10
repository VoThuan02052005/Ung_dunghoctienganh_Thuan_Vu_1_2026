// Model: User (Người dùng)
class User {
  String id;
  String name;
  String email;
  String avatarEmoji;
  int totalWordsLearned;
  int streakDays;
  int xpPoints;
  String level; // Beginner / Intermediate / Advanced
  Map<String, int> skillProgress; // Listening, Speaking, Reading, Writing

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarEmoji = '🎓',
    this.totalWordsLearned = 0,
    this.streakDays = 0,
    this.xpPoints = 0,
    this.level = 'Beginner',
    Map<String, int>? skillProgress,
  }) : skillProgress = skillProgress ??
            {
              'Listening': 0,
              'Speaking': 0,
              'Reading': 0,
              'Writing': 0,
            };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarEmoji': avatarEmoji,
      'totalWordsLearned': totalWordsLearned,
      'streakDays': streakDays,
      'xpPoints': xpPoints,
      'level': level,
      'skillProgress': skillProgress,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarEmoji: map['avatarEmoji'] ?? '🎓',
      totalWordsLearned: map['totalWordsLearned'] ?? 0,
      streakDays: map['streakDays'] ?? 0,
      xpPoints: map['xpPoints'] ?? 0,
      level: map['level'] ?? 'Beginner',
      skillProgress: Map<String, int>.from(map['skillProgress'] ?? {}),
    );
  }
}
