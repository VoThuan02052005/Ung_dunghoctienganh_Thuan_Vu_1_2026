import 'student.dart';

class ListStudent {
  List<Student> students = [];

  void createStudent(Student student) {
    students.add(student);
  }

  List<Student> readAllStudents() {
    return students;
  }

  Student? readStudentById(String studentId) {
    for (var student in students) {
      if (student.studentId == studentId) {
        return student;
      }
    }
    return null;
  }

  bool editStudent(
    String studentId, {
    String? fullname,
    String? currentLesson,
    int? completedLessons,
    double? studyHours,
    bool? isPremium,
    List<String>? topics,
    List<Map<String, String>>? vocabulary,
    Map<String, int>? skillScores,
  }) {
    Student? student = readStudentById(studentId);

    if (student == null) {
      return false;
    }

    if (fullname != null) student.fullname = fullname;
    if (currentLesson != null) student.currentLesson = currentLesson;
    if (completedLessons != null) {
      student.completedLessons = completedLessons;
    }
    if (studyHours != null) student.studyHours = studyHours;
    if (isPremium != null) student.isPremium = isPremium;
    if (topics != null) student.topics = topics;
    if (vocabulary != null) student.vocabulary = vocabulary;
    if (skillScores != null) student.skillScores = skillScores;

    return true;
  }

  bool deleteStudent(String studentId) {
    int index = students.indexWhere(
      (student) => student.studentId == studentId,
    );

    if (index == -1) {
      return false;
    }

    students.removeAt(index);
    return true;
  }
}
