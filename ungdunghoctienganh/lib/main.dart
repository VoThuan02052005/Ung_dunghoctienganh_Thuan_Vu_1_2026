import 'package:flutter/material.dart';

import 'list_student.dart';
import 'screens/about_page.dart';
import 'screens/content_page.dart';
import 'screens/home_page.dart';
import 'student.dart';

class GenericsClass<T> {
  final T obj;

  const GenericsClass(this.obj);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF3F6F24);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGreen,
          primary: brandGreen,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  late final GenericsClass<List<Map<String, String>>> genericObject;
  final ListStudent listStudent = ListStudent();
  String actionMessage = 'Ready: danh sách bài học đã được tải.';

  @override
  void initState() {
    super.initState();

    genericObject = const GenericsClass<List<Map<String, String>>>([
      {
        'studentId': 's123456',
        'fullname': 'Nguyen Thi B',
        'course': 'Daily Conversation',
      },
      {
        'studentId': 's345672',
        'fullname': 'Nguyen Van D',
        'course': 'Travel English',
      },
      {
        'studentId': 's923333',
        'fullname': 'Tran Thi Van',
        'course': 'Business English',
      },
    ]);

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
        studyHours: 10,
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
        actionMessage = 'Create: học viên s888888 đã tồn tại.';
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
      actionMessage = 'Create: đã thêm học viên s888888 - Le Van E.';
    });
  }

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
          ? 'Edit: đã cập nhật khóa Travel English.'
          : 'Edit: không tìm thấy học viên s345672.';
    });
  }

  void deleteStudent() {
    final result = listStudent.deleteStudent('s923333');

    setState(() {
      actionMessage = result
          ? 'Delete: đã xóa học viên s923333 - Tran Thi Van.'
          : 'Delete: không tìm thấy học viên s923333.';
    });
  }

  void readAllStudents() {
    setState(() {
      actionMessage =
          'Read: đang hiển thị ${listStudent.students.length} học viên.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onSubmit: () {
          setState(() {
            currentIndex = 0;
            actionMessage = 'Form: đã ghi nhận nhu cầu học tiếng Anh của bạn.';
          });
        },
      ),
      ContentPage(
        students: listStudent.students,
        actionMessage: actionMessage,
        onCreate: createNewStudent,
        onRead: readAllStudents,
        onEdit: editStudent,
        onDelete: deleteStudent,
      ),
      const AboutPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
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
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
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
