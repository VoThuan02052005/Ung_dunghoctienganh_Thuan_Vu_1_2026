import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme_notifier.dart';
import '../models/user.dart' as app_model;
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'about_screen.dart';
import 'login_screen.dart';

class ProfileTab extends StatefulWidget {
  final String userName;
  const ProfileTab({super.key, required this.userName});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  final _skillIcons = {
    'Listening': '🎧',
    'Speaking': '🗣️',
    'Reading': '📖',
    'Writing': '✍️',
  };

  @override
  Widget build(BuildContext context) {
    final uid = _uid;

    // Nếu chưa đăng nhập (guest mode) → dùng mock data
    if (uid == null) {
      return _buildProfile(context, _mockUser());
    }

    return StreamBuilder<app_model.User?>(
      stream: _firestoreService.watchUser(uid),
      builder: (context, snapshot) {
        final user = snapshot.data ?? _mockUser();
        return _buildProfile(context, user);
      },
    );
  }

  app_model.User _mockUser() {
    return app_model.User(
      id: 'guest',
      name: widget.userName,
      email: '',
      totalWordsLearned: 0,
      streakDays: 0,
      xpPoints: 0,
      skillProgress: {
        'Listening': 0,
        'Speaking': 0,
        'Reading': 0,
        'Writing': 0,
      },
    );
  }

  Widget _buildProfile(BuildContext context, app_model.User user) {
    final skills = user.skillProgress.isEmpty
        ? {'Listening': 0, 'Speaking': 0, 'Reading': 0, 'Writing': 0}
        : user.skillProgress;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(128), width: 3),
                        ),
                        child: Center(
                          child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 38)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name.isNotEmpty ? user.name : widget.userName,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.level,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeaderStat(value: '${user.totalWordsLearned}', label: 'Từ đã học'),
                          const SizedBox(width: 20),
                          _HeaderStat(value: '${user.streakDays}', label: 'Ngày liên tiếp'),
                          const SizedBox(width: 20),
                          _HeaderStat(value: '${user.xpPoints}', label: 'XP'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kỹ năng từ Firestore
                  Text('Kỹ năng', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: skills.entries.map((e) {
                        final val = (e.value / 100).clamp(0.0, 1.0);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Text(_skillIcons[e.key] ?? '📊', style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 70,
                                child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: val,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: const AlwaysStoppedAnimation(Color(0xFF667EEA)),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${e.value}%',
                                  style: const TextStyle(color: Color(0xFF667EEA), fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cài đặt & Thông tin
                  Text('Cài đặt & Thông tin', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'Thông tin cá nhân',
                    onTap: () => _showPersonalInfo(context, user),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Thông báo',
                    onTap: () => _showNotifications(context),
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    label: 'Ngôn ngữ',
                    onTap: () => _showLanguage(context),
                  ),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, mode, _) {
                      final isDark = mode == ThemeMode.dark;
                      return _MenuItem(
                        icon: isDark ? Icons.dark_mode : Icons.light_mode,
                        label: isDark ? 'Giao diện: Tối (Dark Mode)' : 'Giao diện: Sáng (Light Mode)',
                        onTap: () {
                          themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                        },
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    label: 'Về ứng dụng',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Đăng xuất',
                    onTap: () => _logout(context),
                    isDestructive: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Đăng xuất thực sự qua Firebase Auth ─────────────────────────
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _authService.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  // ── Dialog Thông tin cá nhân (dữ liệu thực từ Firestore) ────────
  void _showPersonalInfo(BuildContext context, app_model.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFF667EEA),
                child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 16),
            _infoRow('Họ và tên:', user.name.isNotEmpty ? user.name : widget.userName),
            const Divider(),
            _infoRow('Email:', user.email.isNotEmpty ? user.email : (FirebaseAuth.instance.currentUser?.email ?? '—')),
            const Divider(),
            _infoRow('Cấp độ:', user.level),
            const Divider(),
            _infoRow('XP tích lũy:', '${user.xpPoints} XP'),
            const Divider(),
            _infoRow('Từ đã học:', '${user.totalWordsLearned} từ'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: Color(0xFF667EEA))),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Flexible(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    bool isEnabled = true;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cài đặt thông báo', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Nhắc nhở học tập hàng ngày', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Nhắc nhở ôn tập từ vựng vào 20:00 hàng ngày', style: TextStyle(fontSize: 11)),
                value: isEnabled,
                activeThumbColor: const Color(0xFF667EEA),
                onChanged: (val) => setState(() => isEnabled = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Lưu', style: TextStyle(color: Color(0xFF667EEA))),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguage(BuildContext context) {
    String selectedLanguage = 'Tiếng Việt';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Chọn ngôn ngữ', style: TextStyle(fontWeight: FontWeight.bold)),
          content: RadioGroup<String>(
            groupValue: selectedLanguage,
            onChanged: (val) => setDialogState(() => selectedLanguage = val!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Tiếng Việt', 'English'].map((lang) {
                return RadioListTile<String>(
                  title: Text(lang, style: const TextStyle(fontSize: 14)),
                  value: lang,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chọn', style: TextStyle(color: Color(0xFF667EEA))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────

class _HeaderStat extends StatelessWidget {
  final String value, label;
  const _HeaderStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ],
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6)],
        ),
        child: Row(children: [
          Icon(icon, color: isDestructive ? Colors.red : const Color(0xFF667EEA), size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500))),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        ]),
      ),
    );
  }
}
