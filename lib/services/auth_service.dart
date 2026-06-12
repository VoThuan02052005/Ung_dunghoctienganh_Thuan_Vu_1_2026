// Service: Authentication với Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ========== ĐĂNG KÝ ==========
  Future<UserCredential?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo document user trong Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': name,
        'email': email,
        'avatarEmoji': '🎓',
        'totalWordsLearned': 0,
        'streakDays': 0,
        'xpPoints': 0,
        'level': 'Beginner',
        'skillProgress': {
          'Listening': 0,
          'Speaking': 0,
          'Reading': 0,
          'Writing': 0,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    }
  }

  // ========== ĐĂNG NHẬP ==========
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    }
  }

  // ========== ĐĂNG XUẤT ==========
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ========== MAP LỖI ==========
  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
      case 'user-not-found':
        return 'Không tìm thấy tài khoản';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng';
      default:
        return 'Đã có lỗi xảy ra: $code';
    }
  }
}
