import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../student.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'students';

  /// Create a new student document in Firestore
  Future<bool> createStudent(Student student) async {
    try {
      await _firestore.collection(_collectionName).doc(student.studentId).set({
        'studentId': student.studentId,
        'fullname': student.fullname,
        'currentLesson': student.currentLesson,
        'completedLessons': student.completedLessons,
        'studyHours': student.studyHours,
        'isPremium': student.isPremium,
        'topics': student.topics,
        'vocabulary': student.vocabulary,
        'skillScores': student.skillScores,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Error creating student: $e');
      return false;
    }
  }

  /// Read all students from Firestore
  Future<List<Student>> readAllStudents() async {
    try {
      final querySnapshot =
          await _firestore.collection(_collectionName).get();
      return querySnapshot.docs
          .map((doc) => _studentFromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error reading all students: $e');
      return [];
    }
  }

  /// Read a single student by ID
  Future<Student?> readStudentById(String studentId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(studentId)
          .get();
      
      if (!doc.exists) {
        return null;
      }
      return _studentFromFirestore(doc);
    } catch (e) {
      debugPrint('Error reading student: $e');
      return null;
    }
  }

  /// Update student information
  Future<bool> updateStudent(
    String studentId, {
    String? fullname,
    String? currentLesson,
    int? completedLessons,
    double? studyHours,
    bool? isPremium,
    List<String>? topics,
    List<Map<String, String>>? vocabulary,
    Map<String, int>? skillScores,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (fullname != null) updateData['fullname'] = fullname;
      if (currentLesson != null) updateData['currentLesson'] = currentLesson;
      if (completedLessons != null) {
        updateData['completedLessons'] = completedLessons;
      }
      if (studyHours != null) updateData['studyHours'] = studyHours;
      if (isPremium != null) updateData['isPremium'] = isPremium;
      if (topics != null) updateData['topics'] = topics;
      if (vocabulary != null) updateData['vocabulary'] = vocabulary;
      if (skillScores != null) updateData['skillScores'] = skillScores;
      
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(_collectionName)
          .doc(studentId)
          .update(updateData);
      return true;
    } catch (e) {
      debugPrint('Error updating student: $e');
      return false;
    }
  }

  /// Delete a student by ID
  Future<bool> deleteStudent(String studentId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(studentId)
          .delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting student: $e');
      return false;
    }
  }

  /// Stream of all students (for real-time updates)
  Stream<List<Student>> getStudentsStream() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => _studentFromFirestore(doc))
          .toList();
    });
  }

  /// Convert Firestore document to Student object
  Student _studentFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      studentId: data['studentId'] ?? '',
      fullname: data['fullname'] ?? '',
      currentLesson: data['currentLesson'] ?? '',
      completedLessons: data['completedLessons'] ?? 0,
      studyHours: (data['studyHours'] ?? 0.0).toDouble(),
      isPremium: data['isPremium'] ?? false,
      topics: List<String>.from(data['topics'] ?? []),
      vocabulary: List<Map<String, String>>.from(data['vocabulary'] ?? []),
      skillScores: Map<String, int>.from(data['skillScores'] ?? {}),
    );
  }
}
