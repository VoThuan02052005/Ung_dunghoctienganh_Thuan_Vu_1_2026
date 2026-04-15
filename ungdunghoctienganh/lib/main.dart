import 'package:flutter/material.dart';

/// Điểm bắt đầu của ứng dụng.
/// Flutter sẽ chạy widget gốc là EnglishLearningApp.
void main() {
  runApp(const EnglishLearningApp());
}

/// Widget gốc của toàn bộ ứng dụng.
/// Ở đây ta cấu hình MaterialApp, theme và màn hình home.
class EnglishLearningApp extends StatelessWidget {
  const EnglishLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ẩn banner DEBUG ở góc phải trên.
      debugShowCheckedModeBanner: false,

      // Tên ứng dụng.
      title: 'Ứng dụng học tiếng Anh',

      // Theme chung cho app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Màn hình đầu tiên khi app chạy.
      home: const StudentListPage(),
    );
  }
}

/// ===========================
/// MODEL
/// ===========================
/// Lớp Student đại diện cho một người học tiếng Anh.
///
/// Lý do dùng class:
/// - Code rõ ràng hơn Map thuần.
/// - Dễ quản lý dữ liệu.
/// - Clean code hơn.
/// - Phù hợp khi có nhiều thuộc tính.
class Student {
  final String name;
  final String currentLesson;
  final int completedLessons;
  final double studyHours;
  final bool isPremium;

  // Collection 1: Danh sách chủ đề học.
  final List<String> topics;

  // Collection 2: Danh sách từ vựng.
  // Mỗi phần tử là một Map gồm:
  // - word: từ tiếng Anh
  // - meaning: nghĩa tiếng Việt
  final List<Map<String, String>> vocabulary;

  // Collection 3: Điểm các kỹ năng.
  // Key là tên kỹ năng, value là điểm.
  final Map<String, int> skillScores;

  const Student({
    required this.name,
    required this.currentLesson,
    required this.completedLessons,
    required this.studyHours,
    required this.isPremium,
    required this.topics,
    required this.vocabulary,
    required this.skillScores,
  });
}

/// ===========================
/// DATA SOURCE
/// ===========================
/// Nơi chứa dữ liệu mẫu cho ứng dụng.
/// Trong bài thực hành, có thể xem đây là "database giả".
class AppData {
  static const List<Student> students = [
    Student(
      name: 'Nguyen Van A',
      currentLesson: 'Daily Conversation',
      completedLessons: 12,
      studyHours: 15.5,
      isPremium: true,
      topics: [
        'Greetings',
        'Family',
        'Food',
        'Travel',
      ],
      vocabulary: [
        {'word': 'Hello', 'meaning': 'Xin chào'},
        {'word': 'Teacher', 'meaning': 'Giáo viên'},
        {'word': 'Airport', 'meaning': 'Sân bay'},
      ],
      skillScores: {
        'Listening': 8,
        'Speaking': 7,
        'Reading': 9,
        'Writing': 8,
      },
    ),
    Student(
      name: 'Tran Thi B',
      currentLesson: 'Travel English',
      completedLessons: 8,
      studyHours: 10.0,
      isPremium: false,
      topics: [
        'Hotel',
        'Directions',
        'Transport',
      ],
      vocabulary: [
        {'word': 'Ticket', 'meaning': 'Vé'},
        {'word': 'Passport', 'meaning': 'Hộ chiếu'},
        {'word': 'Station', 'meaning': 'Nhà ga'},
      ],
      skillScores: {
        'Listening': 7,
        'Speaking': 8,
        'Reading': 7,
        'Writing': 6,
      },
    ),
    Student(
      name: 'Le Van C',
      currentLesson: 'Business English',
      completedLessons: 20,
      studyHours: 24.5,
      isPremium: true,
      topics: [
        'Meeting',
        'Email',
        'Presentation',
        'Negotiation',
      ],
      vocabulary: [
        {'word': 'Contract', 'meaning': 'Hợp đồng'},
        {'word': 'Manager', 'meaning': 'Quản lý'},
        {'word': 'Deadline', 'meaning': 'Hạn chót'},
      ],
      skillScores: {
        'Listening': 9,
        'Speaking': 8,
        'Reading': 8,
        'Writing': 9,
      },
    ),
  ];
}

/// ===========================
/// PAGE 1: DANH SÁCH NGƯỜI HỌC
/// ===========================
/// Đây là màn hình đầu tiên của ứng dụng.
///
/// Chức năng:
/// - Hiển thị danh sách người học.
/// - Khi bấm vào từng người, chuyển sang trang chi tiết.
class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// ===========================
    /// BIẾN
    /// ===========================
    /// Các biến đơn lẻ dùng trong màn hình danh sách.
    final String pageTitle = 'Danh sách người học';
    final int totalStudents = AppData.students.length;

    /// ===========================
    /// COLLECTION
    /// ===========================
    /// Danh sách toàn bộ người học.
    final List<Student> students = AppData.students;

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần tóm tắt ở đầu màn hình.
          HeaderSummary(
            totalStudents: totalStudents,
            description: 'Nhấn vào từng người để xem chi tiết học tập',
          ),

          // Expanded giúp ListView chiếm phần còn lại của màn hình.
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,

              // Khoảng cách giữa các item.
              separatorBuilder: (context, index) => const SizedBox(height: 12),

              itemBuilder: (context, index) {
                // Lấy ra từng người học theo vị trí index.
                final Student student = students[index];

                return StudentCard(
                  student: student,
                  onTap: () {
                    // Chuyển sang màn hình chi tiết.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailPage(student: student),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================
/// PAGE 2: CHI TIẾT NGƯỜI HỌC
/// ===========================
/// Màn hình này nhận vào 1 đối tượng Student.
/// Sau đó hiển thị toàn bộ thông tin của người học đó.
class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    /// ===========================
    /// BIẾN
    /// ===========================
    /// Tách dữ liệu từ student ra các biến đơn lẻ
    /// để dễ đọc, dễ giải thích khi thuyết trình.
    final String studentName = student.name;
    final String currentLesson = student.currentLesson;
    final int completedLessons = student.completedLessons;
    final double studyHours = student.studyHours;
    final bool isPremium = student.isPremium;

    /// ===========================
    /// COLLECTIONS
    /// ===========================
    final List<String> topics = student.topics;
    final List<Map<String, String>> vocabulary = student.vocabulary;
    final Map<String, int> skillScores = student.skillScores;

    return Scaffold(
      appBar: AppBar(
        title: Text(studentName),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        // Cho phép cuộn nếu nội dung dài.
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ thông tin cơ bản của người học.
            ProfileCard(
              name: studentName,
              currentLesson: currentLesson,
              completedLessons: completedLessons,
              studyHours: studyHours,
              isPremium: isPremium,
            ),

            const SizedBox(height: 24),

            // Tiêu đề phần chủ đề học.
            const SectionTitle(title: 'Chủ đề đang học'),
            const SizedBox(height: 10),

            // Hiển thị danh sách chủ đề bằng Wrap + Chip.
            // Wrap sẽ tự xuống dòng nếu chip quá dài.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics.map((topic) {
                return Chip(
                  avatar: const Icon(Icons.book, size: 18),
                  label: Text(topic),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Tiêu đề phần từ vựng.
            const SectionTitle(title: 'Từ vựng'),
            const SizedBox(height: 10),

            // Duyệt danh sách vocabulary và tạo ra nhiều card.
            ...vocabulary.map((item) {
              final String word = item['word'] ?? '';
              final String meaning = item['meaning'] ?? '';

              return VocabularyCard(
                word: word,
                meaning: meaning,
              );
            }),

            const SizedBox(height: 24),

            // Tiêu đề phần điểm kỹ năng.
            const SectionTitle(title: 'Điểm kỹ năng'),
            const SizedBox(height: 10),

            // Duyệt Map điểm kỹ năng.
            ...skillScores.entries.map((entry) {
              return SkillScoreRow(
                skill: entry.key,
                score: entry.value,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: PHẦN TÓM TẮT ĐẦU TRANG
/// ===========================
class HeaderSummary extends StatelessWidget {
  final int totalStudents;
  final String description;

  const HeaderSummary({
    super.key,
    required this.totalStudents,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng số người học: $totalStudents',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: CARD NGƯỜI HỌC
/// ===========================
/// Dùng để hiển thị 1 người học trong danh sách.
class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Text(student.name.substring(0, 1)),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('Bài học hiện tại: ${student.currentLesson}'),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: THẺ THÔNG TIN CƠ BẢN
/// ===========================
/// Dùng để hiển thị các biến đơn lẻ bằng nhiều Row.
class ProfileCard extends StatelessWidget {
  final String name;
  final String currentLesson;
  final int completedLessons;
  final double studyHours;
  final bool isPremium;

  const ProfileCard({
    super.key,
    required this.name,
    required this.currentLesson,
    required this.completedLessons,
    required this.studyHours,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoRow(label: 'Họ tên', value: name),
            InfoRow(label: 'Bài học hiện tại', value: currentLesson),
            InfoRow(label: 'Số bài đã học', value: '$completedLessons'),
            InfoRow(label: 'Tổng giờ học', value: '$studyHours giờ'),
            InfoRow(
              label: 'Tài khoản Premium',
              value: isPremium ? 'Có' : 'Không',
            ),
          ],
        ),
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: 1 DÒNG THÔNG TIN
/// ===========================
/// Widget này thể hiện dữ liệu theo dạng Row:
/// bên trái là label, bên phải là value.
///
/// Đây là phần rất hợp yêu cầu đề bài
/// vì đề cho phép hiển thị dữ liệu theo dạng hàng (Row).
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: TIÊU ĐỀ MỖI PHẦN
/// ===========================
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: CARD TỪ VỰNG
/// ===========================
/// Dùng để hiển thị 1 từ vựng và nghĩa của nó.
class VocabularyCard extends StatelessWidget {
  final String word;
  final String meaning;

  const VocabularyCard({
    super.key,
    required this.word,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                word,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(meaning),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===========================
/// WIDGET PHỤ: DÒNG ĐIỂM KỸ NĂNG
/// ===========================
/// Dùng để hiển thị 1 kỹ năng và điểm tương ứng.
class SkillScoreRow extends StatelessWidget {
  final String skill;
  final int score;

  const SkillScoreRow({
    super.key,
    required this.skill,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                skill,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text('$score/10'),
            ),
          ],
        ),
      ),
    );
  }
}
