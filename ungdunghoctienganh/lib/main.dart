import 'package:flutter/material.dart';
import 'student.dart';
import 'list_student.dart';

// ===========================
// CÂU 2: GENERICS CLASS
// ===========================
class GenericsClass<T> {
  T obj;

  GenericsClass(this.obj);

  void showData() {
    print(obj);
  }
}

void main() {
  // =========================
  // CÂU 2: GENERICS
  // =========================
  var studentData = [
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ];

  var genericObject = GenericsClass<List<Map<String, String>>>(studentData);

  print('=== CÂU 2: GENERICS CLASS ===');
  genericObject.showData();

  for (var item in genericObject.obj) {
    print('Student ID: ${item['studentID']}');
    print('Full name: ${item['fullname']}');
    print('---------------------------');
  }

  // =========================
  // CÂU 3 + 4: STUDENT + CRUD
  // =========================
  ListStudent listStudent = ListStudent();

  // CREATE
  listStudent.createStudent(
    Student(
      id: 'ST01',
      name: 'Nguyen Van A',
      currentLesson: 'Daily Conversation',
      completedLessons: 12,
      studyHours: 15.5,
      isPremium: true,
      topics: ['Greetings', 'Family', 'Food', 'Travel'],
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
      id: 'ST02',
      name: 'Tran Thi B',
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
      id: 'ST03',
      name: 'Le Van C',
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

  print('\n=== READ ALL LẦN 1 ===');
  listStudent.showAllStudents();

  // EDIT
  print('\n=== EDIT ST02 ===');
  bool isEdited = listStudent.editStudent(
    'ST02',
    currentLesson: 'Advanced Travel English',
    completedLessons: 10,
    studyHours: 12.5,
    isPremium: true,
  );
  print(isEdited ? 'Sửa thành công' : 'Không tìm thấy sinh viên');

  print('\n=== READ ALL LẦN 2 ===');
  listStudent.showAllStudents();

  // READ BY ID
  print('\n=== READ BY ID ST01 ===');
  Student? foundStudent = listStudent.readStudentById('ST01');
  if (foundStudent != null) {
    foundStudent.showInfo();
    print('Điểm trung bình kỹ năng: ${foundStudent.averageSkillScore()}');
  } else {
    print('Không tìm thấy sinh viên');
  }

  // DELETE
  print('\n=== DELETE ST03 ===');
  bool isDeleted = listStudent.deleteStudent('ST03');
  print(isDeleted ? 'Xóa thành công' : 'Không tìm thấy sinh viên');

  print('\n=== READ ALL LẦN 3 ===');
  listStudent.showAllStudents();

  // Chạy app Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài tập Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bài tập Câu 2, 3, 4'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            'Đã chạy Generics + Student + CRUD.\nXem kết quả ở Debug Console.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
