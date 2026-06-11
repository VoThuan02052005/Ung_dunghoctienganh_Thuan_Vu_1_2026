// File cấu hình Firebase cho ứng dụng EnglishMaster
// Project: ung-dung-hoc-tieng-anh-6d6f6

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  // ✅ Web config (Chrome / Flutter Web)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0hxqJs9V6UpWXHk5SkxTFpRDdMvxThZ4',
    appId: '1:980315700587:web:1e91f8c839d0877adf602e',
    messagingSenderId: '980315700587',
    projectId: 'ung-dung-hoc-tieng-anh-6d6f6',
    authDomain: 'ung-dung-hoc-tieng-anh-6d6f6.firebaseapp.com',
    storageBucket: 'ung-dung-hoc-tieng-anh-6d6f6.firebasestorage.app',
    measurementId: 'G-921TF12LW9',
  );

  // ✅ Android config (dùng cùng apiKey web tạm thời)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0hxqJs9V6UpWXHk5SkxTFpRDdMvxThZ4',
    appId: '1:980315700587:android:0000000000000000',
    messagingSenderId: '980315700587',
    projectId: 'ung-dung-hoc-tieng-anh-6d6f6',
    storageBucket: 'ung-dung-hoc-tieng-anh-6d6f6.firebasestorage.app',
  );

  // ✅ iOS config (dùng cùng apiKey web tạm thời)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0hxqJs9V6UpWXHk5SkxTFpRDdMvxThZ4',
    appId: '1:980315700587:ios:0000000000000000',
    messagingSenderId: '980315700587',
    projectId: 'ung-dung-hoc-tieng-anh-6d6f6',
    storageBucket: 'ung-dung-hoc-tieng-anh-6d6f6.firebasestorage.app',
    iosBundleId: 'com.example.ungDunghoctienganh',
  );
}
