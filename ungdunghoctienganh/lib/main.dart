import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'list_student.dart';
import 'screens/about_page.dart';
import 'screens/content_page.dart';
import 'screens/home_page.dart';
import 'services/firestore_service.dart';
import 'student.dart';

class GenericsClass<T> {
  final T obj;

  const GenericsClass(this.obj);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  final FirestoreService firestoreService = FirestoreService();
  String actionMessage = 'Ready: danh sách bài học đã được tải.';
  List<Student> firestoreStudents = [];

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

    // Initialize local students
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

    // Load initial Firestore data
    _loadFirestoreStudents();
  }

  Future<void> _loadFirestoreStudents() async {
    var students = await firestoreService.readAllStudents();
    
    // Seed initial local students to Firestore if they do not exist
    if (students.isEmpty && listStudent.students.isNotEmpty) {
      for (var localStudent in listStudent.students) {
        await firestoreService.createStudent(localStudent);
      }
      // Re-read after seeding
      students = await firestoreService.readAllStudents();
    }

    setState(() {
      firestoreStudents = students;
    });
  }

  void createNewStudent(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final lessonController = TextEditingController();
    final hoursController = TextEditingController(text: '0.0');
    final completedLessonsController = TextEditingController(text: '0');
    final topicsController = TextEditingController(text: 'General, Speaking');
    bool isPremium = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Student Profile'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(labelText: 'Student ID (e.g., s888888)'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Student ID';
                          }
                          final cleanId = value.trim();
                          if (listStudent.readStudentById(cleanId) != null) {
                            return 'This ID already exists';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter Full Name' : null,
                      ),
                      TextFormField(
                        controller: lessonController,
                        decoration: const InputDecoration(labelText: 'Current Lesson'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter Lesson Title' : null,
                      ),
                      TextFormField(
                        controller: hoursController,
                        decoration: const InputDecoration(labelText: 'Study Hours'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter hours';
                          if (double.tryParse(value) == null) return 'Enter a valid decimal number';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: completedLessonsController,
                        decoration: const InputDecoration(labelText: 'Completed Lessons'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter completed lessons count';
                          if (int.tryParse(value) == null) return 'Enter a valid integer';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: topicsController,
                        decoration: const InputDecoration(labelText: 'Topics (comma separated)'),
                      ),
                      CheckboxListTile(
                        title: const Text('Is Premium Account?'),
                        value: isPremium,
                        onChanged: (val) {
                          setDialogState(() {
                            isPremium = val ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final newStudent = Student(
                        studentId: idController.text.trim(),
                        fullname: nameController.text.trim(),
                        currentLesson: lessonController.text.trim(),
                        completedLessons: int.parse(completedLessonsController.text),
                        studyHours: double.parse(hoursController.text),
                        isPremium: isPremium,
                        topics: topicsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
                        vocabulary: [
                          {'word': 'Language', 'meaning': 'Ngôn ngữ'},
                          {'word': 'Welcome', 'meaning': 'Chào mừng'},
                          {'word': 'Study', 'meaning': 'Học tập'},
                        ],
                        skillScores: {
                          'Listening': 7,
                          'Speaking': 7,
                          'Reading': 8,
                          'Writing': 7,
                        },
                      );

                      listStudent.createStudent(newStudent);
                      await firestoreService.createStudent(newStudent);
                      _loadFirestoreStudents();

                      setState(() {
                        actionMessage = 'Created: đã thêm học viên ${newStudent.studentId} - ${newStudent.fullname}';
                      });

                      navigator.pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editStudent(BuildContext context, [Student? studentToEdit]) async {
    if (listStudent.students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No student profiles available to edit.')),
      );
      return;
    }

    if (studentToEdit == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Student to Edit'),
            content: SizedBox(
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listStudent.students.length,
                itemBuilder: (context, index) {
                  final s = listStudent.students[index];
                  return ListTile(
                    title: Text(s.fullname),
                    subtitle: Text(s.studentId),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditForm(context, s);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      _showEditForm(context, studentToEdit);
    }
  }

  void _showEditForm(BuildContext context, Student student) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: student.fullname);
    final lessonController = TextEditingController(text: student.currentLesson);
    final hoursController = TextEditingController(text: student.studyHours.toString());
    final completedLessonsController = TextEditingController(text: student.completedLessons.toString());
    final topicsController = TextEditingController(text: student.topics.join(', '));
    bool isPremium = student.isPremium;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit Profile: ${student.studentId}'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter Full Name' : null,
                      ),
                      TextFormField(
                        controller: lessonController,
                        decoration: const InputDecoration(labelText: 'Current Lesson'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter Lesson Title' : null,
                      ),
                      TextFormField(
                        controller: hoursController,
                        decoration: const InputDecoration(labelText: 'Study Hours'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter hours';
                          if (double.tryParse(value) == null) return 'Enter a valid decimal number';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: completedLessonsController,
                        decoration: const InputDecoration(labelText: 'Completed Lessons'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter completed lessons count';
                          if (int.tryParse(value) == null) return 'Enter a valid integer';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: topicsController,
                        decoration: const InputDecoration(labelText: 'Topics (comma separated)'),
                      ),
                      CheckboxListTile(
                        title: const Text('Is Premium Account?'),
                        value: isPremium,
                        onChanged: (val) {
                          setDialogState(() {
                            isPremium = val ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final updatedTopics = topicsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
                      
                      listStudent.editStudent(
                        student.studentId,
                        fullname: nameController.text.trim(),
                        currentLesson: lessonController.text.trim(),
                        completedLessons: int.parse(completedLessonsController.text),
                        studyHours: double.parse(hoursController.text),
                        isPremium: isPremium,
                        topics: updatedTopics,
                      );

                      await firestoreService.updateStudent(
                        student.studentId,
                        fullname: nameController.text.trim(),
                        currentLesson: lessonController.text.trim(),
                        completedLessons: int.parse(completedLessonsController.text),
                        studyHours: double.parse(hoursController.text),
                        isPremium: isPremium,
                        topics: updatedTopics,
                      );

                      _loadFirestoreStudents();

                      setState(() {
                        actionMessage = 'Updated: đã cập nhật học viên ${student.studentId}';
                      });

                      navigator.pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteStudent(BuildContext context, [Student? studentToDelete]) async {
    if (listStudent.students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No student profiles available to delete.')),
      );
      return;
    }

    if (studentToDelete == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Student to Delete'),
            content: SizedBox(
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listStudent.students.length,
                itemBuilder: (context, index) {
                  final s = listStudent.students[index];
                  return ListTile(
                    title: Text(s.fullname),
                    subtitle: Text(s.studentId),
                    trailing: const Icon(Icons.delete, color: Colors.red),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDeletion(context, s);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      _confirmDeletion(context, studentToDelete);
    }
  }

  void _confirmDeletion(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to permanently delete the profile of ${student.fullname} (${student.studentId})? This will sync to Firestore.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final navigator = Navigator.of(context);
                listStudent.deleteStudent(student.studentId);
                await firestoreService.deleteStudent(student.studentId);
                _loadFirestoreStudents();

                setState(() {
                  actionMessage = 'Deleted: đã xóa học viên ${student.studentId} - ${student.fullname}';
                });

                navigator.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void readAllStudents() {
    setState(() {
      final localCount = listStudent.students.length;
      final firestoreCount = firestoreStudents.length;
      actionMessage =
          'Read: Local: $localCount học viên | Firestore: $firestoreCount học viên.';
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
        onEditStudent: (ctx, s) => editStudent(ctx, s),
        onDeleteStudent: (ctx, s) => deleteStudent(ctx, s),
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
