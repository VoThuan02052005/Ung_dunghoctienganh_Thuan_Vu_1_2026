import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../services/lesson_repository.dart';

class QuizTab extends StatefulWidget {
  const QuizTab({super.key});
  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  int _current = 0;
  int? _selected;
  int _score = 0;
  bool _answered = false;
  bool _finished = false;
  bool _saving = false;
  bool _loading = true;

  List<Map<String, dynamic>> _questions = [];
  final _firestoreService = FirestoreService();
  final _repo = LessonRepository();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  /// Sinh câu hỏi từ vocabulary lấy từ Firestore
  Future<void> _loadQuestions() async {
    setState(() => _loading = true);
    final lessons = await _repo.getLessons();
    final allVocabs = lessons.expand((l) => l.vocabularies).toList()..shuffle();
    final selected = allVocabs.take(10).toList();

    final questions = <Map<String, dynamic>>[];
    for (final vocab in selected) {
      final wrongAnswers = allVocabs
          .where((v) => v.id != vocab.id)
          .map((v) => v.meaning)
          .toList()
        ..shuffle();
      final options = [vocab.meaning, ...wrongAnswers.take(3)]..shuffle();
      questions.add({
        'question': 'What does "${vocab.word}" mean?',
        'word': vocab.word,
        'options': options,
        'correctIndex': options.indexOf(vocab.meaning),
      });
    }

    if (mounted) {
      setState(() {
        _questions = questions;
        _loading = false;
      });
    }
  }

  void _answer(int idx) {
    if (_answered) return;
    setState(() {
      _selected = idx;
      _answered = true;
      if (idx == _questions[_current]['correctIndex']) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() { _current++; _selected = null; _answered = false; });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() { _finished = true; _saving = true; });

    // Lưu kết quả lên Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.saveQuizResult(uid, _score, _questions.length);
    }
    setState(() => _saving = false);
  }

  void _restart() {
    setState(() {
      _current = 0; _selected = null; _answered = false; _score = 0; _finished = false;
    });
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF667EEA)),
            SizedBox(height: 16),
            Text('Đang tải câu hỏi từ Firestore...', style: TextStyle(color: Colors.grey)),
          ],
        )),
      );
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text('Không tìm thấy câu hỏi'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadQuestions, child: const Text('Thử lại')),
          ],
        )),
      );
    }
    if (_finished) return _buildResult();

    final q = _questions[_current];
    final opts = q['options'] as List<String>;
    final correct = q['correctIndex'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_current + 1}/${_questions.length}',
                style: const TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_current + 1) / _questions.length,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF667EEA)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              const Text('⭐', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text('Điểm: $_score', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF667EEA))),
            ]),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF667EEA).withAlpha(77), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Column(children: [
                const Text('📝', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 12),
                Text(q['question'],
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Chọn đáp án:', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 10),
            ...opts.asMap().entries.map((e) {
              final isCorrect = e.key == correct;
              final isSelected = _selected == e.key;
              Color bg = Theme.of(context).colorScheme.surface;
              Color border = Colors.grey.shade200;
              if (_answered) {
                if (isCorrect) { bg = const Color(0xFFE8F5E9); border = Colors.green; }
                else if (isSelected) { bg = const Color(0xFFFFEBEE); border = Colors.red; }
              }
              return GestureDetector(
                onTap: () => _answer(e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6)],
                  ),
                  child: Row(children: [
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: _answered && isCorrect ? Colors.green : (_answered && isSelected ? Colors.red : const Color(0xFFF0EEFF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(
                        _answered && isCorrect ? '✓' : (_answered && isSelected ? '✗' : String.fromCharCode(65 + e.key)),
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: (_answered && (isCorrect || isSelected)) ? Colors.white : const Color(0xFF667EEA)),
                      )),
                    ),
                    const SizedBox(width: 12),
                    Text(e.value, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (_answered)
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _current < _questions.length - 1 ? 'Câu tiếp theo →' : 'Xem kết quả',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final pct = (_score / _questions.length * 100).round();
    final xpEarned = _score * 20;
    String emoji = pct >= 80 ? '🏆' : pct >= 60 ? '🌟' : '💪';
    String msg = pct >= 80 ? 'Xuất sắc! 🎊' : pct >= 60 ? 'Tốt lắm!' : 'Cố gắng hơn nhé!';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text('Kết quả Quiz', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 6),
              Text(msg, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  Text('$_score/${_questions.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                  Text('$pct% chính xác', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  if (_saving)
                    const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(51), borderRadius: BorderRadius.circular(20)),
                      child: Text('+$xpEarned XP đã lưu 🔥', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                ]),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Làm lại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
