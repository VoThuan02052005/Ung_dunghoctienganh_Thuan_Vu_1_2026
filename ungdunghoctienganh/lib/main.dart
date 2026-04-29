import 'package:flutter/material.dart';
import 'student.dart';
import 'list_student.dart';

// Generic class dùng để lưu một đối tượng có kiểu dữ liệu bất kỳ.
// Trong bài này, T là List<Map<String, String>>.
class GenericsClass<T> {
  T obj;

  GenericsClass(this.obj);
}

void main() {
  runApp(const MyApp());
}

// Widget gốc của toàn bộ ứng dụng.
// StatelessWidget vì bản thân MyApp không thay đổi trạng thái.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tắt banner debug ở góc phải màn hình.
      debugShowCheckedModeBanner: false,

      title: 'Student Management App',

      // Cấu hình giao diện chung cho app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Màn hình chính của ứng dụng.
      home: const HomePage(),
    );
  }
}

// HomePage dùng StatefulWidget vì có thay đổi trạng thái:
// - đổi tab bằng BottomNavigationBar
// - create/edit/delete student
// - cập nhật actionMessage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến lưu tab hiện tại đang được chọn.
  // 0 = Home, 1 = Generics, 2 = CRUD.
  int currentIndex = 0;

  // Đối tượng generic dùng cho Câu 2.
  late GenericsClass<List<Map<String, String>>> genericObject;

  // Đối tượng quản lý danh sách học viên.
  final ListStudent listStudent = ListStudent();

  // Chuỗi hiển thị trạng thái sau khi người dùng bấm Create/Edit/Delete/Read.
  String actionMessage = 'Chưa thực hiện thao tác nào';

  @override
  void initState() {
    super.initState();

    // =========================
    // CÂU 2: GENERICS CLASS
    // =========================
    // Dữ liệu đầu vào gồm studentId và fullname.
    genericObject = GenericsClass<List<Map<String, String>>>([
      {'studentId': 's123456', 'fullname': 'Nguyen Thi B'},
      {'studentId': 's345672', 'fullname': 'Nguyen Van D'},
      {'studentId': 's923333', 'fullname': 'Tran Thi Van'},
    ]);

    // =========================
    // CÂU 3 + CÂU 4: STUDENT + CRUD
    // =========================
    // Tạo danh sách Student dựa trên đúng 3 sinh viên ở Câu 2.
    // Ở đây bổ sung thêm bài học, số giờ học, chủ đề, từ vựng, điểm kỹ năng.

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

  // =========================
  // CRUD FUNCTIONS
  // =========================

  // CREATE: thêm học viên mới vào danh sách.
  void createNewStudent() {
    final existed = listStudent.readStudentById('s888888');

    // Nếu học viên đã tồn tại thì không thêm nữa.
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

    // setState dùng để cập nhật lại giao diện sau khi thêm dữ liệu.
    setState(() {
      actionMessage = 'Create: Đã thêm học viên s888888 - Le Van E';
    });
  }

  // EDIT: chỉnh sửa thông tin học viên có mã s345672.
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

  // DELETE: xóa học viên có mã s923333.
  void deleteStudent() {
    bool result = listStudent.deleteStudent('s923333');

    setState(() {
      actionMessage = result
          ? 'Delete: Đã xóa học viên s923333 - Tran Thi Van'
          : 'Delete: Không tìm thấy học viên s923333';
    });
  }

  // READ: đọc toàn bộ danh sách học viên.
  void readAllStudents() {
    setState(() {
      actionMessage =
          'Read: Hiển thị toàn bộ danh sách (${listStudent.students.length} học viên)';
    });
  }

  // =========================
  // COMMON UI WIDGETS
  // =========================

  // Widget dùng chung để hiển thị tiêu đề từng phần.
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

  // Widget hiển thị một card thông tin học viên.
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

            // Hiển thị danh sách từ vựng của học viên.
            ...student.vocabulary.map((item) {
              return Text('- ${item['word']} : ${item['meaning']}');
            }),
          ],
        ),
      ),
    );
  }

  // =========================
  // TAB 1: HOME
  // =========================

  Widget buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle('Student Management App'),
                const Text(
                  'Ứng dụng quản lý học viên học tiếng Anh được xây dựng bằng Flutter.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ứng dụng gồm 3 màn hình chính:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('- Home: giới thiệu tổng quan ứng dụng.'),
                const Text('- Generics: hiển thị dữ liệu đầu vào của Câu 2.'),
                const Text('- CRUD: thêm, xem, sửa, xóa học viên.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // TAB 2: GENERICS
  // =========================

  Widget buildGenericsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle('Câu 2 - Generics Class'),

                const Text(
                  'Phần này sử dụng GenericsClass<T> để lưu danh sách học viên '
                  'dưới dạng List<Map<String, String>>.',
                ),

                const SizedBox(height: 16),

                const Text(
                  'Dữ liệu đầu vào:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // Duyệt danh sách genericObject.obj để hiển thị từng học viên.
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
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // TAB 3: CRUD
  // =========================

  Widget buildCrudTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle('Câu 3, 4 - Student và CRUD'),

                const Text(
                  'Danh sách bên dưới chính là các sinh viên ở Câu 2, '
                  'được bổ sung thêm thông tin để thực hiện CRUD.',
                ),

                const SizedBox(height: 16),

                // Các nút thao tác CRUD.
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: createNewStudent,
                      child: const Text('Create'),
                    ),
                    ElevatedButton(
                      onPressed: readAllStudents,
                      child: const Text('Read All'),
                    ),
                    ElevatedButton(
                      onPressed: editStudent,
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: deleteStudent,
                      child: const Text('Delete'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Khung hiển thị trạng thái thao tác.
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

                // Hiển thị toàn bộ danh sách học viên.
                ...listStudent.readAllStudents().map(buildStudentCard),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // MAIN BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình tương ứng với BottomNavigationBar.
    final List<Widget> tabs = [
      buildHomeTab(),
      buildGenericsTab(),
      buildCrudTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management App'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      // Hiển thị màn hình tương ứng với tab đang chọn.
      body: tabs[currentIndex],

      // Thanh điều hướng dưới cùng.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        // Khi bấm vào item, cập nhật currentIndex và vẽ lại giao diện.
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Generics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'CRUD',
          ),
        ],
      ),
    );
  }
}