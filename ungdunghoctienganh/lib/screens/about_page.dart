import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color brandGreen = Color(0xFF3F6F24);
  static const Color ink = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 860;

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 44 : 20,
                  34,
                  isWide ? 44 : 20,
                  64,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    aboutHero(),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        aboutInfoCard(
                          width: isWide ? 470 : double.infinity,
                          title: 'App Info',
                          icon: Icons.app_shortcut,
                          children: const [
                            _AboutLine('Tên ứng dụng', 'English Learning App'),
                            _AboutLine('Chủ đề', 'App học tiếng Anh'),
                            _AboutLine(
                                'Công nghệ', 'Flutter, Dart, Material 3'),
                            _AboutLine('Màn hình mới', 'Home và Content'),
                          ],
                        ),
                        aboutInfoCard(
                          width: isWide ? 470 : double.infinity,
                          title: 'Mockup Layout',
                          icon: Icons.dashboard_customize_outlined,
                          children: const [
                            _AboutLine('Home', 'Header, form, footer'),
                            _AboutLine('Content', 'Lesson list, summary, CRUD'),
                            _AboutLine('About', 'Giữ lại công việc cũ'),
                            _AboutLine('Navigation', 'Home / Content / About'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    aboutInfoCard(
                      width: double.infinity,
                      title: 'Design Consistency',
                      icon: Icons.palette_outlined,
                      children: const [
                        Text(
                          'Phần Home và Content được cập nhật theo đúng 2 mẫu giao diện trong đề. '
                          'Phần About cũ vẫn được giữ lại để không mất công việc đã làm trước đó.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Color(0xFF333333),
                          ),
                        ),
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

  Widget aboutHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD5E5CC)),
      ),
      child: Row(
        children: [
          learnLogo(size: 44),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Thông tin ứng dụng, nhóm và cấu trúc layout đã làm.',
                  style: TextStyle(fontSize: 15, color: Color(0xFF444444)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    double width = 470,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: brandGreen),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget learnLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF222222), width: 2),
      ),
      child: Icon(
        Icons.auto_stories_outlined,
        size: size * 0.58,
        color: const Color(0xFF222222),
      ),
    );
  }
}

class _AboutLine extends StatelessWidget {
  const _AboutLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF111111),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                height: 1.35,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
