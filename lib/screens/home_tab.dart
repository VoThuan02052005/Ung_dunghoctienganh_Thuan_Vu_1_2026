import 'package:flutter/material.dart';
import '../services/lesson_repository.dart';
import '../models/lesson.dart';
import '../core/app_colors.dart';
import 'lesson_detail_screen.dart';

class HomeTab extends StatefulWidget {
  final String userName;
  const HomeTab({super.key, required this.userName});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _repo = LessonRepository();
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _repo.getLessons();
  }

  /// Reload bài học từ Firestore sau khi user quay lại từ detail screen
  void _refreshLessons() {
    setState(() {
      _lessonsFuture = _repo.getLessons(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>>(
      future: _lessonsFuture,
      builder: (context, snapshot) {
        final lessons = snapshot.data ?? [];
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        return _buildScaffold(context, lessons, isLoading);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, List<Lesson> lessons, bool isLoading) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF667EEA),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Xin chào, ${widget.userName}! 👋',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                const Text('Tiếp tục học hôm nay',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white.withAlpha(51),
                              child: const Text('🎓', style: TextStyle(fontSize: 22)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Stats Row
                        Row(
                          children: [
                            _StatChip(icon: '🔥', value: '7', label: 'Ngày'),
                            const SizedBox(width: 10),
                            _StatChip(icon: '⭐', value: '240', label: 'XP'),
                            const SizedBox(width: 10),
                            _StatChip(icon: '📚', value: '42', label: 'Từ'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Goal Card
                  _DailyGoalCard(),
                  const SizedBox(height: 20),

                  // Categories
                  Text('Danh mục học', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryChip(emoji: '👋', label: 'Giao tiếp'),
                        _CategoryChip(emoji: '✈️', label: 'Du lịch'),
                        _CategoryChip(emoji: '💼', label: 'Kinh doanh'),
                        _CategoryChip(emoji: '🍽️', label: 'Ẩm thực'),
                        _CategoryChip(emoji: '💻', label: 'Công nghệ'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Continue Learning
                  Text('Tiếp tục học', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          // Lessons List — Shimmer khi loading, data thật khi xong
          isLoading
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _SkeletonLessonCard(),
                    ),
                    childCount: 4, // 4 placeholder cards
                  ),
                )
              : lessons.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('📢', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 12),
                              Text('Chưa có bài học nào',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                          final lesson = lessons[i];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: GestureDetector(
                              onTap: () => Navigator.push(ctx, MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(lesson: lesson),
                              )).then((_) => _refreshLessons()), // ← Refresh tiến độ khi quay lại
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(ctx).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56, height: 56,
                                      decoration: BoxDecoration(
                                        color: Theme.of(ctx).colorScheme.primaryContainer.withAlpha(80),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(child: Text(lesson.imageEmoji, style: const TextStyle(fontSize: 28))),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(ctx).colorScheme.onSurface)),
                                          const SizedBox(height: 4),
                                          Text('${lesson.vocabularies.length} từ vựng • ${lesson.level}',
                                              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: LinearProgressIndicator(
                                              value: lesson.progress / 100,
                                              backgroundColor: Colors.grey[200],
                                              valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                              minHeight: 6,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text('${lesson.progress}%', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: lessons.length,
                      ),
                    ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon, value, label;
  const _StatChip({required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text('$value $label', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF43E97B).withAlpha(77), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mục tiêu hôm nay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white.withAlpha(77),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('3/5 bài hoàn thành', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji, label;
  const _CategoryChip({required this.emoji, required this.label});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// ── Skeleton loader với hiệu ứng shimmer (không cần package) ──────────────
class _SkeletonLessonCard extends StatefulWidget {
  const _SkeletonLessonCard();

  @override
  State<_SkeletonLessonCard> createState() => _SkeletonLessonCardState();
}

class _SkeletonLessonCardState extends State<_SkeletonLessonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final shimmerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context2, child) {
        final color = Color.lerp(baseColor, shimmerColor, _anim.value)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              // Emoji placeholder
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(height: 14, width: double.infinity, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 8),
                    // Subtitle placeholder
                    Container(height: 11, width: 120, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 10),
                    // Progress bar placeholder
                    Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 4),
                    // Percentage placeholder
                    Container(height: 10, width: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Chevron placeholder
              Container(width: 20, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        );
      },
    );
  }
}
