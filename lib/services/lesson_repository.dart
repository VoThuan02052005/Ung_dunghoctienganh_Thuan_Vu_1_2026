// Repository: LessonRepository — Nguồn dữ liệu duy nhất cho Lesson & Vocabulary
// Tự động seed Firestore nếu chưa có dữ liệu, fallback về SampleData nếu offline
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lesson.dart';
import '../models/vocabulary.dart';
import '../data/sample_data.dart';

class LessonRepository {
  static final LessonRepository _instance = LessonRepository._internal();
  factory LessonRepository() => _instance;
  LessonRepository._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cache trong phiên làm việc
  List<Lesson>? _cachedLessons;

  // ============================================================
  // 📥 LẤY DỮ LIỆU BÀI HỌC
  // ============================================================

  Future<List<Lesson>> getLessons({bool forceRefresh = false}) async {
    if (_cachedLessons != null && !forceRefresh) return _cachedLessons!;

    try {
      final snap = await _db.collection('lessons').orderBy('order').get();

      // Nếu Firestore trống → seed dữ liệu
      if (snap.docs.isEmpty) {
        await seedLessons();
        return await getLessons(forceRefresh: true);
      }

      final lessons = <Lesson>[];
      final uid = FirebaseAuth.instance.currentUser?.uid;

      for (final doc in snap.docs) {
        final data = doc.data();

        // Lấy vocabularies từ subcollection
        final vocabSnap = await doc.reference
            .collection('vocabularies')
            .orderBy('order')
            .get();

        // Lấy trạng thái isLearned/isFavorite của user từ Firestore
        Set<String> learnedIds = {};
        Set<String> favoriteIds = {};
        if (uid != null) {
          final learnedSnap = await _db
              .collection('users')
              .doc(uid)
              .collection('learned_words')
              .where('isLearned', isEqualTo: true)
              .get();
          learnedIds = learnedSnap.docs.map((d) => d.id).toSet();

          final favSnap = await _db
              .collection('users')
              .doc(uid)
              .collection('favorites')
              .where('isFavorite', isEqualTo: true)
              .get();
          favoriteIds = favSnap.docs.map((d) => d.id).toSet();
        }

        final vocabs = vocabSnap.docs.map((v) {
          final vd = v.data();
          return Vocabulary(
            id: vd['id'] ?? v.id,
            word: vd['word'] ?? '',
            pronunciation: vd['pronunciation'] ?? '',
            meaning: vd['meaning'] ?? '',
            example: vd['example'] ?? '',
            topic: vd['topic'] ?? '',
            level: vd['level'] ?? 'Beginner',
            isLearned: learnedIds.contains(v.id),
            isFavorite: favoriteIds.contains(v.id),
          );
        }).toList();

        // Tính progress từ số từ đã học thực tế
        final progress = vocabs.isEmpty
            ? 0
            : ((learnedIds.intersection(vocabs.map((v) => v.id).toSet()).length /
                        vocabs.length) *
                    100)
                .round();

        lessons.add(Lesson(
          id: data['id'] ?? doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          topic: data['topic'] ?? '',
          level: data['level'] ?? 'Beginner',
          imageEmoji: data['imageEmoji'] ?? '📚',
          vocabularies: vocabs,
          progress: progress,
        ));
      }

      _cachedLessons = lessons;
      return lessons;
    } catch (e) {
      // Fallback: dùng SampleData nếu Firestore lỗi / offline
      return SampleData.getAllLessons();
    }
  }

  // Xóa cache để load lại
  void clearCache() => _cachedLessons = null;

  // ============================================================
  // 🌱 SEED DỮ LIỆU LÊN FIRESTORE (chỉ chạy 1 lần)
  // ============================================================

  Future<void> seedLessons() async {
    final lessons = SampleData.getAllLessons();

    for (int i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final lessonRef = _db.collection('lessons').doc(lesson.id);

      await lessonRef.set({
        'id': lesson.id,
        'title': lesson.title,
        'description': lesson.description,
        'topic': lesson.topic,
        'level': lesson.level,
        'imageEmoji': lesson.imageEmoji,
        'order': i,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Seed từng từ vựng vào subcollection
      for (int j = 0; j < lesson.vocabularies.length; j++) {
        final vocab = lesson.vocabularies[j];
        await lessonRef.collection('vocabularies').doc(vocab.id).set({
          'id': vocab.id,
          'word': vocab.word,
          'pronunciation': vocab.pronunciation,
          'meaning': vocab.meaning,
          'example': vocab.example,
          'topic': vocab.topic,
          'level': vocab.level,
          'order': j,
        }, SetOptions(merge: true));
      }
    }
  }

  // ============================================================
  // 💾 LƯU TIẾN ĐỘ CỦA USER
  // ============================================================

  Future<void> markVocabLearned(String vocabId, bool isLearned) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

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
      await _db.collection('users').doc(uid).set({
        'xpPoints': FieldValue.increment(10),
        'totalWordsLearned': FieldValue.increment(1),
        'lastActiveAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    clearCache();
  }

  Future<void> toggleFavorite(String vocabId, bool isFavorite) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

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

    clearCache();
  }
}
