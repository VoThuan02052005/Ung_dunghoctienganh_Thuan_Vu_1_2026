import 'package:flutter/material.dart';
import 'student.dart';
import 'list_student.dart';

class GenericsClass<T> {
  T obj;

  GenericsClass(this.obj);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài tập Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GenericsClass<List<Map<String, String>>> genericObject;
  final ListStudent listStudent = ListStudent();

  String actionMessage = 'Chưa thực hiện thao tác nào';

  @override
  void initState() {
    super.initState();

    // CÂU 2: dữ liệu đầu vào gốc
    genericObject = GenericsClass<List<Map<String, String>>>([
      {'studentId': 's123456', 'fullname': 'Nguyen Thi B'},
      {'studentId': 's345672', 'fullname': 'Nguyen Van D'},
      {'studentId': 's923333', 'fullname': 'Tran Thi Van'},
    ]);

    // CÂU 3 + 4: dùng đúng các sinh viên ở Câu 2
    listStudent.createStudent(
      Student(
        studentId: 's123456',
        fullname: 'Nguyen Thi B',
        currentLesson: 'Daily Conversation',
        completedLessons: 12,
        studyHours: 15.5,
        isPremium: true,
        topics: ['Greetings', 'Family', 'Food'],
        vocabulary: [
          {'word': 'Hello', 'meaning': 'Xin chào'},
          {'word': 'Teacher', 'meaning': 'Giáo viên'},
        ],
        skillScores: {
          'Listening': 8,
          'Speaking': 7,
          'Reading': 9,
          'Writing': 8,
        },
      ),
    );

    listStudent.createStudent(
      Student(
        studentId: 's345672',
        fullname: 'Nguyen Van D',
        currentLesson: 'Travel English',
        completedLessons: 8,
        studyHours: 10.0,
        isPremium: false,
        topics: ['Hotel', 'Directions', 'Transport'],
        vocabulary: [
          {'word': 'Ticket', 'meaning': 'Vé'},
          {'word': 'Passport', 'meaning': 'Hộ chiếu'},
        ],
        skillScores: {
          'Listening': 7,
          'Speaking': 8,
          'Reading': 7,
          'Writing': 6,
        },
      ),
    );

    listStudent.createStudent(
      Student(
        studentId: 's923333',
        fullname: 'Tran Thi Van',
        currentLesson: 'Business English',
        completedLessons: 20,
        studyHours: 24.5,
        isPremium: true,
        topics: ['Meeting', 'Email', 'Presentation'],
        vocabulary: [
          {'word': 'Contract', 'meaning': 'Hợp đồng'},
          {'word': 'Manager', 'meaning': 'Quản lý'},
        ],
        skillScores: {
          'Listening': 9,
          'Speaking': 8,
          'Reading': 8,
          'Writing': 9,
        },
      ),
    );
  }

  void createNewStudent() {
    final existed = listStudent.readStudentById('s888888');

    if (existed != null) {
      setState(() {
        actionMessage = 'Học viên s888888 đã tồn tại';
      });
      return;
    }

    listStudent.createStudent(
      Student(
        studentId: 's888888',
        fullname: 'Le Van E',
        currentLesson: 'Grammar Basics',
        completedLessons: 5,
        studyHours: 6.5,
        isPremium: false,
        topics: ['Grammar', 'Verb', 'Sentence'],
        vocabulary: [
          {'word': 'Book', 'meaning': 'Quyển sách'},
          {'word': 'School', 'meaning': 'Trường học'},
        ],
        skillScores: {
          'Listening': 6,
          'Speaking': 6,
          'Reading': 7,
          'Writing': 7,
        },
      ),
    );

    setState(() {
      actionMessage = 'Create: Đã thêm học viên s888888 - Le Van E';
    });
  }

  void editStudent() {
    bool result = listStudent.editStudent(
      's345672',
      currentLesson: 'Advanced Travel English',
      completedLessons: 10,
      studyHours: 12.5,
      isPremium: true,
    );

    setState(() {
      actionMessage = result
          ? 'Edit: Đã sửa học viên s345672 - Nguyen Van D'
          : 'Edit: Không tìm thấy học viên s345672';
    });
  }

  void deleteStudent() {
    bool result = listStudent.deleteStudent('s923333');

    setState(() {
      actionMessage = result
          ? 'Delete: Đã xóa học viên s923333 - Tran Thi Van'
          : 'Delete: Không tìm thấy học viên s923333';
    });
  }

  void readAllStudents() {
    setState(() {
      actionMessage =
          'Read: Hiển thị toàn bộ danh sách (${listStudent.students.length} học viên)';
    });
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildGenericSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Câu 2 - Generics Class'),
            const Text(
              'Dữ liệu đầu vào:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...genericObject.obj.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(item['fullname'] ?? ''),
                  subtitle: Text('Student ID: ${item['studentId'] ?? ''}'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton(
          onPressed: createNewStudent,
          child: const Text('Create'),
        ),
        ElevatedButton(
          onPressed: editStudent,
          child: const Text('Edit'),
        ),
        ElevatedButton(
          onPressed: deleteStudent,
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: readAllStudents,
          child: const Text('Read All'),
        ),
      ],
    );
  }

  Widget buildStudentCard(Student student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${student.fullname} (${student.studentId})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Bài học hiện tại: ${student.currentLesson}'),
            Text('Số bài hoàn thành: ${student.completedLessons}'),
            Text('Số giờ học: ${student.studyHours}'),
            Text('Premium: ${student.isPremium ? "Có" : "Không"}'),
            Text(
              'Điểm trung bình kỹ năng: '
              '${student.averageSkillScore().toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            Text('Chủ đề: ${student.topics.join(', ')}'),
            const SizedBox(height: 8),
            const Text(
              'Từ vựng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...student.vocabulary.map((item) {
              return Text('- ${item['word']} : ${item['meaning']}');
            }),
          ],
        ),
      ),
    );
  }

  Widget buildCrudSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Câu 3, 4 - Student và CRUD'),
            const Text(
              'Danh sách bên dưới chính là các sinh viên ở Câu 2, được bổ sung thêm thông tin để thực hiện CRUD.',
            ),
            const SizedBox(height: 16),
            buildActionButtons(),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Trạng thái: $actionMessage',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            ...listStudent.readAllStudents().map(buildStudentCard).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập Câu 2, 3, 4'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildGenericSection(),
          const SizedBox(height: 16),
          buildCrudSection(),
        ],
      ),
    );
  }
}
