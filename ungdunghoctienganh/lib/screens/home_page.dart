import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onSubmit,
  });

  static const Color brandGreen = Color(0xFF3F6F24);
  static const Color ink = Color(0xFF111111);

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 860;

        return SingleChildScrollView(
          child: Column(
            children: [
              homeTopBar(isWide),
              Container(
                width: double.infinity,
                color: const Color(0xFFF4F4F4),
                padding: EdgeInsets.fromLTRB(
                  isWide ? 32 : 20,
                  isWide ? 130 : 76,
                  isWide ? 32 : 20,
                  isWide ? 120 : 70,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: Column(
                      children: [
                        const Text(
                          'English Learning App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 44,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Learn English with daily lessons',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 26),
                        contactForm(),
                      ],
                    ),
                  ),
                ),
              ),
              footerSection(isWide),
            ],
          ),
        );
      },
    );
  }

  Widget homeTopBar(bool isWide) {
    final items = ['Courses', 'Practice', 'Community', 'Resources', 'Pricing'];

    return Container(
      height: isWide ? 78 : null,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 20,
        vertical: isWide ? 0 : 18,
      ),
      child: isWide
          ? Row(
              children: [
                learnLogo(size: 36),
                const Spacer(),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: navText(item, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 26),
                outlineAction('Sign in'),
                const SizedBox(width: 10),
                darkAction('Register'),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    learnLogo(size: 34),
                    const Spacer(),
                    outlineAction('Sign in'),
                    const SizedBox(width: 10),
                    darkAction('Register'),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 10,
                  children: items.map((item) {
                    return navText(item, fontSize: 13);
                  }).toList(),
                ),
              ],
            ),
    );
  }

  Widget contactForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDADADA)),
      ),
      child: Column(
        children: [
          formField(label: 'Name', hint: 'Your name'),
          formField(label: 'Course', hint: 'Daily Conversation'),
          formField(label: 'Email', hint: 'student@email.com'),
          formField(
            label: 'Message',
            hint: 'I want to improve my speaking skill',
            maxLines: 3,
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2D2D2D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: onSubmit,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerSection(bool isWide) {
    final columns = [
      (
        'Use cases',
        [
          'Daily conversation',
          'Pronunciation',
          'Vocabulary review',
          'Grammar practice',
          'IELTS warm-up',
          'Team classroom',
        ],
      ),
      (
        'Explore',
        [
          'Listening',
          'Speaking',
          'Reading',
          'Writing',
          'Flashcards',
          'Study plans',
        ],
      ),
      (
        'Resources',
        [
          'Blog',
          'Best practices',
          'Word lists',
          'Placement test',
          'Support',
          'Teacher library',
        ],
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        isWide ? 32 : 24,
        28,
        isWide ? 80 : 24,
        82,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                footerBrand(),
                const Spacer(),
                ...columns.map(
                  (column) => Padding(
                    padding: const EdgeInsets.only(left: 84),
                    child: footerColumn(column.$1, column.$2),
                  ),
                ),
              ],
            )
          : Wrap(
              spacing: 44,
              runSpacing: 30,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                footerBrand(),
                ...columns.map((column) {
                  return footerColumn(column.$1, column.$2);
                }),
              ],
            ),
    );
  }

  Widget footerBrand() {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          learnLogo(size: 36),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.close, size: 22),
              SizedBox(width: 16),
              Icon(Icons.camera_alt_outlined, size: 22),
              SizedBox(width: 16),
              Icon(Icons.play_circle_outline, size: 24),
              SizedBox(width: 16),
              Icon(Icons.work_outline, size: 22),
            ],
          ),
        ],
      ),
    );
  }

  Widget footerColumn(String title, List<String> items) {
    return SizedBox(
      width: 165,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Color(0xFF2D2D2D)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF222222)),
          ),
          const SizedBox(height: 7),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDADADA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: brandGreen, width: 1.4),
              ),
            ),
          ),
        ],
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

  Widget outlineAction(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF222222),
        side: const BorderSide(color: Color(0xFF8A8A8A)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget darkAction(String text) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
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
