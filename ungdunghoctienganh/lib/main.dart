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
// StatelessWidget vì MyApp chỉ cấu hình theme và màn hình đầu tiên.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEFFAF1),
      ),
      home: const MainLayout(),
    );
  }
}

// MainLayout dùng StatefulWidget vì có thay đổi trạng thái:
// - đổi màn hình bằng NavigationBar
// - create/edit/delete/read student
// - cập nhật actionMessage sau mỗi thao tác CRUD
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Biến lưu màn hình hiện tại đang được chọn.
  // 0 = Home, 1 = Content, 2 = About.
  int currentIndex = 0;

  // Đối tượng generic dùng để lưu dữ liệu dạng List<Map<String, String>>.
  late GenericsClass<List<Map<String, String>>> genericObject;

  // Đối tượng quản lý danh sách học viên và các hàm CRUD.
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
    // Tạo danh sách Student dựa trên đúng 3 sinh viên ở phần Generics.
    // Mỗi học viên được bổ sung thêm bài học, số giờ học, chủ đề, từ vựng,
    // điểm kỹ năng để phù hợp với chủ đề app học tiếng Anh.
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
        actionMessage = 'Create: Học viên s888888 đã tồn tại';
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

  // EDIT: chỉnh sửa thông tin học viên có mã s345672.
  void editStudent() {
    final result = listStudent.editStudent(
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
    final result = listStudent.deleteStudent('s923333');

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
          'Read: Đang hiển thị ${listStudent.students.length} học viên';
    });
  }

  // =========================
  // COMMON UI WIDGETS
  // =========================

  // Header/Banner dùng chung cho cả 3 màn hình.
  Widget headerBanner({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC9F4D4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.green.shade700, width: 1.2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.green.shade800, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card dùng chung để giữ layout thống nhất: tiêu đề, mô tả, nội dung.
  Widget appCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green.shade800),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  // Dòng thông tin nhỏ dùng ở màn About.
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Ô thống kê nhỏ ở màn Home.
  Widget statBox(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green.shade800),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị một card thông tin học viên.
  Widget buildStudentCard(Student student) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(Icons.person, color: Colors.green.shade800),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullname,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Student ID: ${student.studentId}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    );
  }

  // =========================
  // SCREEN 1: HOME
  // =========================

  Widget buildHomePage() {
    final totalStudents = listStudent.students.length;
    final premiumStudents = listStudent.students
        .where((student) => student.isPremium)
        .length;
    final totalLessons = listStudent.students.fold<int>(
      0,
      (sum, student) => sum + student.completedLessons,
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              headerBanner(
                title: 'Home',
                subtitle: 'English Learning App - Quản lý học viên học tiếng Anh',
                icon: Icons.home,
              ),
              appCard(
                title: 'Content',
                subtitle: 'Thống kê nhanh về học viên và quá trình học tập.',
                icon: Icons.analytics_outlined,
                children: [
                  Row(
                    children: [
                      statBox('$totalStudents', 'Học viên', Icons.groups),
                      statBox('$premiumStudents', 'Premium', Icons.workspace_premium),
                      statBox('$totalLessons', 'Bài học', Icons.menu_book),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: appCard(
                title: 'Footer / Card',
                subtitle: 'Danh sách chức năng chính của ứng dụng.',
                icon: Icons.check_circle_outline,
                children: const [
                  Text('• Home: giới thiệu ứng dụng và thống kê nhanh.'),
                  Text('• Content: hiển thị Generics Data và CRUD học viên.'),
                  Text('• About: giới thiệu app, nhóm và cấu trúc layout.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // SCREEN 2: CONTENT
  // =========================

  Widget buildContentPage() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              headerBanner(
                title: 'Content',
                subtitle: 'Dữ liệu List/Map, Generics và CRUD Student.',
                icon: Icons.article,
              ),
              appCard(
                title: 'Generics Data',
                subtitle: 'Sử dụng GenericsClass<T> với List<Map<String, String>>.',
                icon: Icons.data_object,
                children: [
                  ...genericObject.obj.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Icon(Icons.person, color: Colors.green.shade800),
                        ),
                        title: Text(item['fullname'] ?? ''),
                        subtitle: Text('Student ID: ${item['studentId'] ?? ''}'),
                      ),
                    );
                  }),
                ],
              ),
            ]),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: appCard(
                title: 'CRUD & Students List',
                subtitle: 'Các nút thao tác và danh sách học viên dạng Card.',
                icon: Icons.people_alt_outlined,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: createNewStudent,
                        icon: const Icon(Icons.add),
                        label: const Text('Create'),
                      ),
                      OutlinedButton.icon(
                        onPressed: readAllStudents,
                        icon: const Icon(Icons.visibility),
                        label: const Text('Read'),
                      ),
                      OutlinedButton.icon(
                        onPressed: editStudent,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      OutlinedButton.icon(
                        onPressed: deleteStudent,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Text(
                      'Trạng thái: $actionMessage',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...listStudent.readAllStudents().map(buildStudentCard),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // SCREEN 3: ABOUT
  // =========================

  Widget buildAboutPage() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              headerBanner(
                title: 'About',
                subtitle: 'Thông tin ứng dụng, công nghệ và thiết kế mockup.',
                icon: Icons.info,
              ),
              appCard(
                title: 'App Info',
                subtitle: 'Thông tin tổng quan của ứng dụng.',
                icon: Icons.app_shortcut,
                children: [
                  infoRow('Tên ứng dụng', 'English Learning App'),
                  infoRow('Chủ đề', 'Quản lý học viên học tiếng Anh'),
                  infoRow('Công nghệ', 'Flutter, Dart, Material Design 3'),
                  infoRow('Màu chủ đạo', 'Xanh lá nhạt'),
                  infoRow('Font chữ', 'Font mặc định của Flutter/Material'),
                ],
              ),
              appCard(
                title: 'Mockup Layout',
                subtitle: 'Cấu trúc 4 phần của mỗi màn hình trong app.',
                icon: Icons.dashboard_customize,
                children: const [
                  Text('1. Header / Banner: tên màn hình và mô tả ngắn.'),
                  Text('2. Content: dữ liệu, danh sách và chức năng chính.'),
                  Text('3. Footer / Card: thông tin bổ sung hoặc chức năng phụ.'),
                  Text('4. Navigation Bar: chuyển giữa Home, Content, About.'),
                ],
              ),
            ]),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: appCard(
                title: 'Design Consistency',
                subtitle: 'Sự thống nhất về layout, màu sắc, font chữ và chức năng.',
                icon: Icons.palette_outlined,
                children: const [
                  Text('• Các màn hình dùng chung Header/Banner và Card.'),
                  Text('• Màu sắc thống nhất theo tông xanh lá nhạt.'),
                  Text('• Navigation Bar luôn nằm ở cuối màn hình.'),
                  Text('• Nội dung xoay quanh chủ đề học tiếng Anh.'),
                ],
              ),
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
    // Danh sách các màn hình tương ứng với NavigationBar.
    final List<Widget> pages = [
      buildHomePage(),
      buildContentPage(),
      buildAboutPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Learning App'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      // Hiển thị màn hình tương ứng với tab đang chọn.
      body: pages[currentIndex],

      // Navigation Bar ở cuối cùng mỗi trang.
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Content',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
