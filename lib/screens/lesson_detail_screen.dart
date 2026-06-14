import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/vocabulary.dart';
import 'vocabulary_detail_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF667EEA),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(ctx),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(lesson.imageEmoji, style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 8),
                    Text(lesson.title,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('${lesson.vocabularies.length} từ vựng • ${lesson.level}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Từ vựng'),
                Tab(text: 'Thông tin'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Vocabulary list
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lesson.vocabularies.length,
              itemBuilder: (ctx, i) {
                final vocab = lesson.vocabularies[i];
                return _VocabCard(vocab: vocab, index: i + 1);
              },
            ),
            // Tab 2: Lesson info
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(title: 'Mô tả', content: lesson.description),
                  const SizedBox(height: 12),
                  _InfoCard(title: 'Chủ đề', content: lesson.topic),
                  const SizedBox(height: 12),
                  _InfoCard(title: 'Cấp độ', content: lesson.level),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tiến độ học', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: lesson.progress / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF667EEA)),
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${lesson.progress}% hoàn thành',
                            style: const TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: lesson.vocabularies.isEmpty ? null : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => VocabularyDetailScreen(vocabulary: lesson.vocabularies.first),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Bắt đầu học', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class _VocabCard extends StatelessWidget {
  final Vocabulary vocab;
  final int index;
  const _VocabCard({required this.vocab, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => VocabularyDetailScreen(vocabulary: vocab),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFF667EEA).withAlpha(25), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text('$index', style: const TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vocab.word, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                  Text(vocab.pronunciation, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  Text(vocab.meaning, style: const TextStyle(color: Color(0xFF667EEA), fontSize: 13)),
                ],
              ),
            ),
            Icon(vocab.isLearned ? Icons.check_circle : Icons.circle_outlined,
                color: vocab.isLearned ? Colors.green : Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title, content;
  const _InfoCard({required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Text(content, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
            ],
          )),
        ],
      ),
    );
  }
}
