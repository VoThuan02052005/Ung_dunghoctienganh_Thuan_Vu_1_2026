import 'student.dart';

class ListStudent {
  List<Student> students = [];

  // CREATE
  void createStudent(Student student) {
    students.add(student);
  }

  // READ ALL
  List<Student> readAllStudents() {
    return students;
  }

  // READ BY ID
  Student? readStudentById(String id) {
    for (var student in students) {
      if (student.id == id) {
        return student;
      }
    }
    return null;
  }

  // EDIT
  bool editStudent(
    String id, {
    String? name,
    String? currentLesson,
    int? completedLessons,
    double? studyHours,
    bool? isPremium,
    List<String>? topics,
    List<Map<String, String>>? vocabulary,
    Map<String, int>? skillScores,
  }) {
    Student? student = readStudentById(id);

    if (student == null) {
      return false;
    }

    if (name != null) {
      student.name = name;
    }
    if (currentLesson != null) {
      student.currentLesson = currentLesson;
    }
    if (completedLessons != null) {
      student.completedLessons = completedLessons;
    }
    if (studyHours != null) {
      student.studyHours = studyHours;
    }
    if (isPremium != null) {
      student.isPremium = isPremium;
    }
    if (topics != null) {
      student.topics = topics;
    }
    if (vocabulary != null) {
      student.vocabulary = vocabulary;
    }
    if (skillScores != null) {
      student.skillScores = skillScores;
    }

    return true;
  }

  // DELETE
  bool deleteStudent(String id) {
    int index = students.indexWhere((student) => student.id == id);

    if (index == -1) {
      return false;
    }

    students.removeAt(index);
    return true;
  }

  void showAllStudents() {
    if (students.isEmpty) {
      print('Danh sách sinh viên rỗng');
      return;
    }

    for (var student in students) {
      student.showInfo();
    }
  }
}
