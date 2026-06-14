import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../services/lesson_repository.dart';

class VocabularyDetailScreen extends StatefulWidget {
  final Vocabulary vocabulary;
  const VocabularyDetailScreen({super.key, required this.vocabulary});

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  bool _isFlipped = false;
  final _repo = LessonRepository();

  @override
  Widget build(BuildContext context) {
    final v = widget.vocabulary;
    return Scaffold(
      appBar: AppBar(
        title: Text(v.word, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(v.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: () {
              setState(() => v.isFavorite = !v.isFavorite);
              _repo.toggleFavorite(v.id, v.isFavorite);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Flashcard
            GestureDetector(
              onTap: () => setState(() => _isFlipped = !_isFlipped),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isFlipped
                        ? [const Color(0xFF43E97B), const Color(0xFF38F9D7)]
                        : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (_isFlipped ? const Color(0xFF43E97B) : const Color(0xFF667EEA)).withAlpha(77),
                      blurRadius: 20, offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isFlipped) ...[
                        Text(v.word, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(v.pronunciation, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Nhấn để xem nghĩa', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ] else ...[
                        Text(v.meaning, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Nhấn để xem từ', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info cards
            _DetailCard(
              icon: '🔊',
              title: 'Phát âm',
              content: v.pronunciation,
              bgColor: const Color(0xFFEDE7F6),
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: '📖',
              title: 'Nghĩa tiếng Việt',
              content: v.meaning,
              bgColor: const Color(0xFFE8F5E9),
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: '💬',
              title: 'Ví dụ',
              content: v.example,
              bgColor: const Color(0xFFE3F2FD),
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: '🏷️',
              title: 'Chủ đề',
              content: '${v.topic} • ${v.level}',
              bgColor: const Color(0xFFFFF8E1),
            ),
            const SizedBox(height: 24),

            // Mark as learned
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => v.isLearned = !v.isLearned);
                  _repo.markVocabLearned(v.id, v.isLearned);
                },
                icon: Icon(v.isLearned ? Icons.check_circle : Icons.check_circle_outline),
                label: Text(v.isLearned ? 'Đã học ✓' : 'Đánh dấu đã học'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: v.isLearned ? Colors.green : const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String icon, title, content;
  final Color bgColor;
  const _DetailCard({required this.icon, required this.title, required this.content, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
