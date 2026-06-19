# 🔥 Hướng dẫn cài đặt Firebase cho EnglishMaster

## Bước 1: Tạo Firebase Project

1. Vào https://console.firebase.google.com
2. Nhấn **"Add project"** → Đặt tên: `EnglishMaster`
3. Tắt Google Analytics (không cần) → **Create project**

---

## Bước 2: Bật Firebase Auth và Firestore

### Firebase Authentication:
1. Chọn **Authentication** → **Get started**
2. Tab **Sign-in method** → Bật **Email/Password** → Save

### Cloud Firestore:
1. Chọn **Firestore Database** → **Create database**
2. Chọn **Start in test mode** (cho phép đọc/ghi tự do khi dev)
3. Chọn region gần nhất (ví dụ: `asia-southeast1`)

---

## Bước 3: Cài FlutterFire CLI

```bash
# Cài FlutterFire CLI
dart pub global activate flutterfire_cli

# Hoặc nếu dart không có trong PATH:
flutter pub global activate flutterfire_cli
```

---

## Bước 4: Kết nối project với Firebase

```bash
# Chạy trong thư mục project
cd ~/Ung_dunghoctienganh_Thuan_Vu_1_2026
flutterfire configure
```

- Chọn project `EnglishMaster` vừa tạo
- Chọn platforms: **android**, **ios**, **web**
- Lệnh này tự tạo file `lib/firebase_options.dart`

---

## Bước 5: Cài packages và chạy

```bash
flutter pub get
flutter run
```

---

## 📊 Cấu trúc Firestore Database

```
Firestore
├── users (collection)
│   └── {uid} (document)
│       ├── name: "Thuan Vu"
│       ├── email: "thuan@email.com"
│       ├── xpPoints: 240
│       ├── streakDays: 7
│       ├── totalWordsLearned: 42
│       ├── level: "Intermediate"
│       ├── skillProgress: { Listening: 70, Speaking: 50, ... }
│       ├── progress (subcollection)
│       │   └── {lessonId}: { progress: 80, updatedAt: ... }
│       ├── learned_words (subcollection)
│       │   └── {vocabId}: { isLearned: true, learnedAt: ... }
│       ├── favorites (subcollection)
│       │   └── {vocabId}: { isFavorite: true, savedAt: ... }
│       └── quiz_results (subcollection)
│           └── {autoId}: { score: 4, total: 5, percentage: 80, takenAt: ... }
│
└── lessons (collection)
    └── {lessonId} (document)
        ├── title: "Greetings & Introductions"
        ├── topic: "Daily Life"
        ├── level: "Beginner"
        └── vocabularies (subcollection)
            └── {vocabId}: { word, pronunciation, meaning, example }
```

---

## Firestore Security Rules (Sau khi dev xong)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User chỉ đọc/ghi dữ liệu của mình
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    // Lessons: mọi user đã đăng nhập đều đọc được
    match /lessons/{lessonId}/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // chỉ admin mới ghi
    }
  }
}
```
