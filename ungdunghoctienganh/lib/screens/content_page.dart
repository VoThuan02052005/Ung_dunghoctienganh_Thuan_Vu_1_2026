import 'package:flutter/material.dart';

import '../student.dart';

class LessonCardData {
  const LessonCardData({
    required this.title,
    required this.focus,
    required this.duration,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    required this.icon,
    required this.visualColor,
  });

  final String title;
  final String focus;
  final String duration;
  final String progress;
  final int completedLessons;
  final int totalLessons;
  final IconData icon;
  final Color visualColor;

  double get percent => totalLessons == 0 ? 0 : completedLessons / totalLessons;
}

class ContentPage extends StatelessWidget {
  const ContentPage({
    super.key,
    required this.students,
    required this.actionMessage,
    required this.onCreate,
    required this.onRead,
    required this.onEdit,
    required this.onDelete,
    required this.onEditStudent,
    required this.onDeleteStudent,
  });

  static const Color brandGreen = Color(0xFF3F6F24);
  static const Color ink = Color(0xFF111111);
  static const Color softSurface = Color(0xFFF8F8F3);

  final List<Student> students;
  final String actionMessage;
  final Function(BuildContext) onCreate;
  final VoidCallback onRead;
  final Function(BuildContext) onEdit;
  final Function(BuildContext) onDelete;
  final Function(BuildContext, Student) onEditStudent;
  final Function(BuildContext, Student) onDeleteStudent;

  List<LessonCardData> get lessonCards {
    final icons = [
      Icons.chat_bubble_outline,
      Icons.travel_explore,
      Icons.business_center_outlined,
      Icons.auto_stories_outlined,
    ];
    final colors = [
      const Color(0xFFFFD9A8),
      const Color(0xFFD6EAF8),
      const Color(0xFFE2D9F3),
      const Color(0xFFE1F2CE),
    ];

    return List.generate(students.length, (index) {
      final student = students[index];
      final total = student.completedLessons + 8 + index;

      return LessonCardData(
        title: student.currentLesson,
        focus: student.topics.join(' / '),
        duration: '${student.studyHours.toStringAsFixed(1)}h',
        progress: '${student.completedLessons}/$total lessons',
        completedLessons: student.completedLessons,
        totalLessons: total,
        icon: icons[index % icons.length],
        visualColor: colors[index % colors.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final horizontalPadding = isWide ? 68.0 : 20.0;

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  54,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contentTopBar(isWide),
                    const SizedBox(height: 86),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        const Text(
                          'Learning Path',
                          style: TextStyle(
                            fontSize: 54,
                            height: 1,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            color: ink,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '${lessonCards.length} lessons',
                            style: const TextStyle(
                              fontSize: 20,
                              color: ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    const Divider(height: 1, color: Color(0xFFE1E1E1)),
                    const SizedBox(height: 38),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: lessonList(context)),
                          const SizedBox(width: 32),
                          SizedBox(width: 370, child: studySummary(context)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          lessonList(context),
                          const SizedBox(height: 24),
                          studySummary(context),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget contentTopBar(bool isWide) {
    final navItems = ['Lessons', 'Vocabulary', 'Who we are', 'My profile'];

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: BrandName('English Mastery')),
              contentBasketButton(),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 22,
            runSpacing: 12,
            children: navItems.map(navText).toList(),
          ),
        ],
      );
    }

    return Row(
      children: [
        const BrandName('English Mastery'),
        const SizedBox(width: 32),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 28,
            runSpacing: 12,
            children: navItems.map(navText).toList(),
          ),
        ),
        const SizedBox(width: 28),
        contentBasketButton(),
      ],
    );
  }

  Widget lessonList(BuildContext context) {
    final cards = lessonCards;
    return Column(
      children: List.generate(students.length, (index) {
        return lessonCard(students[index], cards[index], context);
      }),
    );
  }

  Widget lessonCard(Student student, LessonCardData lesson, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          color: softSurface,
          child: InkWell(
            onTap: () => _showStudentDetailDialog(context, student),
            child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lessonVisual(lesson, compact: true),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: lessonInfo(lesson, compact: true),
                    ),
                  ],
                )
              : SizedBox(
                  height: 190,
                  child: Row(
                    children: [
                      lessonVisual(lesson),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 22,
                          ),
                          child: lessonInfo(lesson),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget lessonVisual(LessonCardData lesson, {bool compact = false}) {
    return Container(
      width: compact ? double.infinity : 170,
      height: compact ? 170 : double.infinity,
      color: lesson.visualColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compact ? 92 : 82,
            height: compact ? 92 : 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            lesson.icon,
            color: brandGreen,
            size: compact ? 62 : 54,
          ),
        ],
      ),
    );
  }

  Widget lessonInfo(LessonCardData lesson, {bool compact = false}) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lesson.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            color: ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lesson.focus,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: brandGreen,
          ),
        ),
        const SizedBox(height: 18),
        lessonPill(lesson.duration),
      ],
    );

    final progress = Column(
      crossAxisAlignment:
          compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          lesson.progress,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: compact ? double.infinity : 132,
          child: LinearProgressIndicator(
            minHeight: 8,
            borderRadius: BorderRadius.circular(99),
            color: brandGreen,
            backgroundColor: const Color(0xFFE7E7E2),
            value: lesson.percent.clamp(0, 1).toDouble(),
          ),
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          details,
          const SizedBox(height: 22),
          progress,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: details),
        progress,
      ],
    );
  }

  Widget studySummary(BuildContext context) {
    final totalHours = students.fold<double>(
      0,
      (sum, student) => sum + student.studyHours,
    );
    final completedLessons = students.fold<int>(
      0,
      (sum, student) => sum + student.completedLessons,
    );
    final premiumStudents = students.where((student) {
      return student.isPremium;
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: softSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Study summary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 34),
          summaryRow('Learners', '${students.length}'),
          summaryRow('Completed', '$completedLessons lessons'),
          summaryRow('Premium', '$premiumStudents students'),
          const SizedBox(height: 10),
          summaryRow(
            'Total hours',
            '${totalHours.toStringAsFixed(1)}h',
            isBold: true,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: brandGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onRead,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue learning',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'CRUD tools',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              smallAction('Create', Icons.add, () => onCreate(context)),
              smallAction('Read', Icons.visibility_outlined, onRead),
              smallAction('Edit', Icons.edit_outlined, () => onEdit(context)),
              smallAction('Delete', Icons.delete_outline, () => onDelete(context)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            actionMessage,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4A4A4A),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
                color: ink,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget lessonPill(String text) {
    return Container(
      width: 146,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: ink,
            ),
          ),
          const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF777777)),
        ],
      ),
    );
  }

  Widget smallAction(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: brandGreen,
        side: const BorderSide(color: Color(0xFFCFCFCF)),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget navText(String text, {double fontSize = 16}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
    );
  }

  Widget contentBasketButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: brandGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(136, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onRead,
      child: Text(
        'Lessons (${lessonCards.length})',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }

  void _showStudentDetailDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) {
        final revealedVocab = <int>{};
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 500,
            color: Colors.white,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        color: brandGreen,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              child: const Icon(Icons.person, color: Colors.white, size: 36),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.fullname,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: ${student.studentId}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (student.isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Colors.amber[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CURRENT LESSON', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(student.currentLesson, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ink)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('STUDY HOURS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text('${student.studyHours.toStringAsFixed(1)} hrs', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: brandGreen)),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            const Text('TOPICS COVERED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: student.topics.map((t) => Chip(
                                label: Text(t),
                                labelStyle: const TextStyle(fontSize: 13, color: brandGreen),
                                backgroundColor: const Color(0xFFF0F5EC),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              )).toList(),
                            ),
                            const Divider(height: 32),
                            const Text('VOCABULARY (Tap to flip/reveal meaning)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 12),
                            student.vocabulary.isEmpty
                              ? const Text('No vocabulary words added yet.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: student.vocabulary.length,
                                  itemBuilder: (context, idx) {
                                    final item = student.vocabulary[idx];
                                    final word = item['word'] ?? '';
                                    final meaning = item['meaning'] ?? '';
                                    final isRevealed = revealedVocab.contains(idx);
                                    return Card(
                                      elevation: 0,
                                      color: const Color(0xFFF9F9FB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(color: Color(0xFFEEEEEE)),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          setDialogState(() {
                                            if (isRevealed) {
                                              revealedVocab.remove(idx);
                                            } else {
                                              revealedVocab.add(idx);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ink)),
                                              Row(
                                                children: [
                                                  AnimatedSwitcher(
                                                    duration: const Duration(milliseconds: 200),
                                                    child: isRevealed
                                                      ? Text(
                                                          meaning,
                                                          key: ValueKey('mean_$idx'),
                                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: brandGreen),
                                                        )
                                                      : Text(
                                                          'Tap to show',
                                                          key: ValueKey('tap_$idx'),
                                                          style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    isRevealed ? Icons.visibility : Icons.visibility_off_outlined,
                                                    size: 18,
                                                    color: isRevealed ? brandGreen : Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            const Divider(height: 32),
                            const Text('SKILL SCORES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 12),
                            ...student.skillScores.entries.map((entry) {
                              final skill = entry.key;
                              final score = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    SizedBox(width: 80, child: Text(skill, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ink))),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: score / 10.0,
                                          minHeight: 8,
                                          backgroundColor: const Color(0xFFEEEEEE),
                                          color: brandGreen,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('$score/10', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ink)),
                                  ],
                                ),
                              );
                            }),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onEditStudent(context, student);
                                  },
                                  icon: const Icon(Icons.edit, size: 18, color: brandGreen),
                                  label: const Text('Edit', style: TextStyle(color: brandGreen)),
                                ),
                                const SizedBox(width: 12),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onDeleteStudent(context, student);
                                  },
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFCCCCCC)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close', style: TextStyle(color: ink)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class BrandName extends StatelessWidget {
  const BrandName(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF3F6F24),
        fontSize: 32,
        height: 1,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: 'serif',
      ),
    );
  }
}
