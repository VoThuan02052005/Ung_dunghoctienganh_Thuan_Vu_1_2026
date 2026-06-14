import 'package:flutter/material.dart';
import '../services/lesson_repository.dart';
import '../models/lesson.dart';
import '../core/app_colors.dart';
import 'lesson_detail_screen.dart';

class LessonsTab extends StatefulWidget {
  const LessonsTab({super.key});
  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> {
  String _selectedLevel = 'Tất cả';
  final _levels = ['Tất cả', 'Beginner', 'Intermediate', 'Advanced'];
  final _repo = LessonRepository();
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _repo.getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>>(
      future: _lessonsFuture,
      builder: (context, snapshot) {
        final all = snapshot.data ?? [];
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final filtered = _selectedLevel == 'Tất cả'
            ? all
            : all.where((l) => l.level == _selectedLevel).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bài học', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _levels.map((level) {
                  final sel = level == _selectedLevel;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: sel,
                      onSelected: (_) => setState(() => _selectedLevel = level),
                      selectedColor: const Color(0xFF667EEA),
                      labelStyle: TextStyle(color: sel ? Colors.white : Colors.grey[600], fontSize: 12),
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Lessons Grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF667EEA)))
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📭', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text('Không có bài học', style: TextStyle(color: Colors.grey[500])),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) => _LessonCard(lesson: filtered[i]),
                      ),
          ),
        ],
      ),
    );
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  const _LessonCard({required this.lesson});

  Color get _levelColor {
    switch (lesson.level) {
      case 'Beginner':     return AppColors.beginner;
      case 'Intermediate': return AppColors.intermediate;
      default:             return AppColors.advanced;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson))),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_levelColor.withAlpha(51), _levelColor.withAlpha(25)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(child: Text(lesson.imageEmoji, style: const TextStyle(fontSize: 44))),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _levelColor.withAlpha(38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(lesson.level, style: TextStyle(fontSize: 10, color: _levelColor, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: lesson.progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(_levelColor),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text('${lesson.progress}% • ${lesson.vocabularies.length} từ',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
