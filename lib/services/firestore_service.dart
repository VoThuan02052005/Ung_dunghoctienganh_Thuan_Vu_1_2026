// Service: Firestore - Tương tác với Cloud Firestore (NoSQL Documents)
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/vocabulary.dart';
import '../models/lesson.dart';
import '../data/sample_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============================================================
  // 👤 USER - Collection: users/{uid}
  // ============================================================

  // Lấy thông tin user từ Firestore
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      return User(
        id: uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        avatarEmoji: data['avatarEmoji'] ?? '🎓',
        totalWordsLearned: data['totalWordsLearned'] ?? 0,
        streakDays: data['streakDays'] ?? 0,
        xpPoints: data['xpPoints'] ?? 0,
        level: data['level'] ?? 'Beginner',
        skillProgress: Map<String, int>.from(data['skillProgress'] ?? {}),
      );
    } catch (e) {
      return null;
    }
  }

  // Lắng nghe thay đổi user theo thời gian thực
  Stream<User?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      final data = snap.data()!;
      return User(
        id: uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        avatarEmoji: data['avatarEmoji'] ?? '🎓',
        totalWordsLearned: data['totalWordsLearned'] ?? 0,
        streakDays: data['streakDays'] ?? 0,
        xpPoints: data['xpPoints'] ?? 0,
        level: data['level'] ?? 'Beginner',
        skillProgress: Map<String, int>.from(data['skillProgress'] ?? {}),
      );
    });
  }

  // Cập nhật XP và streak
  Future<void> updateUserProgress(String uid, {int addXp = 0, int addWords = 0}) async {
    await _db.collection('users').doc(uid).update({
      'xpPoints': FieldValue.increment(addXp),
      'totalWordsLearned': FieldValue.increment(addWords),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  // Cập nhật tiến độ kỹ năng
  Future<void> updateSkillProgress(String uid, String skill, int value) async {
    await _db.collection('users').doc(uid).update({
      'skillProgress.$skill': value,
    });
  }

  // ============================================================
  // 📚 LESSONS - Collection: lessons/{lessonId}
  // ============================================================

  // Seed dữ liệu mẫu lên Firestore (chạy 1 lần)
  Future<void> seedLessons() async {
    final lessons = SampleData.getAllLessons();
    final batch = _db.batch();

    for (final lesson in lessons) {
      final ref = _db.collection('lessons').doc(lesson.id);
      batch.set(ref, {
        'id': lesson.id,
        'title': lesson.title,
        'description': lesson.description,
        'topic': lesson.topic,
        'level': lesson.level,
        'imageEmoji': lesson.imageEmoji,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Seed từ vựng vào subcollection
      for (final vocab in lesson.vocabularies) {
        final vocabRef = ref.collection('vocabularies').doc(vocab.id);
        batch.set(vocabRef, {
          'id': vocab.id,
          'word': vocab.word,
          'pronunciation': vocab.pronunciation,
          'meaning': vocab.meaning,
          'example': vocab.example,
          'topic': vocab.topic,
          'level': vocab.level,
        }, SetOptions(merge: true));
      }
    }
    await batch.commit();
  }

  // Lấy tất cả bài học
  Future<List<Lesson>> getLessons() async {
    try {
      final snap = await _db.collection('lessons').get();
      final lessons = <Lesson>[];
      for (final doc in snap.docs) {
        final data = doc.data();
        // Lấy vocabularies từ subcollection
        final vocabSnap = await doc.reference.collection('vocabularies').get();
        final vocabs = vocabSnap.docs.map((v) {
          final vd = v.data();
          return Vocabulary(
            id: vd['id'],
            word: vd['word'],
            pronunciation: vd['pronunciation'],
            meaning: vd['meaning'],
            example: vd['example'],
            topic: vd['topic'],
            level: vd['level'],
          );
        }).toList();

        lessons.add(Lesson(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          topic: data['topic'],
          level: data['level'],
          imageEmoji: data['imageEmoji'],
          vocabularies: vocabs,
          progress: data['progress'] ?? 0,
        ));
      }
      return lessons;
    } catch (e) {
      // Fallback: dùng sample data nếu Firestore lỗi
      return SampleData.getAllLessons();
    }
  }

  // ============================================================
  // 📝 USER PROGRESS - Collection: users/{uid}/progress/{lessonId}
  // ============================================================

  // Lưu tiến độ bài học của user
  Future<void> saveLessonProgress(String uid, String lessonId, int progress) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(lessonId)
        .set({
      'lessonId': lessonId,
      'progress': progress,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Lưu từ đã học
  Future<void> markVocabLearned(String uid, String vocabId, bool isLearned) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('learned_words')
        .doc(vocabId)
        .set({
      'vocabId': vocabId,
      'isLearned': isLearned,
      'learnedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (isLearned) {
      await updateUserProgress(uid, addXp: 10, addWords: 1);
    }
  }

  // Lưu từ yêu thích
  Future<void> toggleFavorite(String uid, String vocabId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(vocabId)
        .set({
      'vocabId': vocabId,
      'isFavorite': isFavorite,
      'savedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ============================================================
  // 🎯 QUIZ RESULTS - Collection: users/{uid}/quiz_results
  // ============================================================

  // Lưu kết quả quiz
  Future<void> saveQuizResult(String uid, int score, int total) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('quiz_results')
        .add({
      'score': score,
      'total': total,
      'percentage': (score / total * 100).round(),
      'takenAt': FieldValue.serverTimestamp(),
    });

    // Cộng XP theo kết quả
    final xp = score * 20;
    await updateUserProgress(uid, addXp: xp);
  }

  // Lấy lịch sử quiz
  Future<List<Map<String, dynamic>>> getQuizHistory(String uid) async {
    try {
      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('quiz_results')
          .orderBy('takenAt', descending: true)
          .limit(10)
          .get();
      return snap.docs.map((d) => d.data()).toList();
    } catch (e) {
      return [];
    }
  }
}
