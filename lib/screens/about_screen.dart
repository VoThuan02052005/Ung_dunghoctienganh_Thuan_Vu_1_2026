import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Về ứng dụng', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App Logo
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF667EEA).withAlpha(77), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: const Center(child: Text('🇬🇧', style: TextStyle(fontSize: 52))),
            ),
            const SizedBox(height: 16),
            Text('EnglishMaster', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            const Text('Phiên bản 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            const Text(
              'Ứng dụng học tiếng Anh thông minh, hiệu quả\nvà thú vị dành cho người Việt.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Features
            _SectionCard(
              title: '✨ Tính năng',
              items: [
                '📚 Kho từ vựng phong phú theo chủ đề',
                '🎯 Quiz tương tác với phản hồi tức thì',
                '📈 Theo dõi tiến độ học tập chi tiết',
                '🔥 Streak hàng ngày để duy trì thói quen',
                '💡 Flashcard thông minh',
              ],
            ),
            const SizedBox(height: 16),

            // Team
            _SectionCard(
              title: '👥 Nhóm phát triển',
              items: [
                '🎓 Thuan Vu - Team Leader & Developer',
                '📘 Môn học: Lập trình ứng dụng di động',
                '🏫 Đại học Phenikaa',
                '📅 Năm học: 2025–2026',
              ],
            ),
            const SizedBox(height: 16),

            // User Stories Summary
            _SectionCard(
              title: '📋 User Stories',
              items: [
                'US01: Đăng nhập / Đăng ký tài khoản',
                'US02: Xem danh sách bài học theo chủ đề',
                'US03: Học từ vựng với flashcard',
                'US04: Làm quiz kiểm tra kiến thức',
                'US05: Theo dõi tiến độ kỹ năng',
                'US06: Quản lý hồ sơ cá nhân',
              ],
            ),
            const SizedBox(height: 16),

            // Tech stack
            _SectionCard(
              title: '⚙️ Công nghệ sử dụng',
              items: [
                '📱 Flutter / Dart (SDK ^3.11)',
                '🔥 Firebase Auth — Xác thực người dùng',
                '🗄️ Cloud Firestore — Cơ sở dữ liệu NoSQL',
                '🎨 Material Design 3',
                '⚡ ValueListenableBuilder — State Management',
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Made with ❤️ by Thuan Vu • 2026',
                      style: TextStyle(color: Color(0xFF667EEA), fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const _SectionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const Divider(height: 20),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(item, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
          )),
        ],
      ),
    );
  }
}
