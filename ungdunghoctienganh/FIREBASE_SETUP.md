# Firebase Setup Guide for English Learning App

## Overview
This project now has Firebase and Firestore integration for storing student data persistently. The CRUD operations have been implemented to work with both local storage and Firestore.

## Setup Instructions

### Step 1: Install Firebase CLI

Firebase CLI is required to configure Firebase for your Flutter project.

#### Option A: Using npm (Recommended)
```bash
npm install -g firebase-tools
```

#### Option B: Using Windows Installer
1. Download the Firebase CLI installer for Windows from: https://firebase.google.com/docs/cli#install_the_firebase_cli
2. Run the installer
3. Follow the installation wizard

### Step 2: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Follow the setup wizard:
   - Enter project name: `ungdunghoctienganh` (or your preferred name)
   - Enable/Disable Google Analytics (optional)
   - Select or create a Google Cloud project
   - Click "Create Project"
4. Wait for the project to be created

### Step 3: Login to Firebase from Terminal

```bash
firebase login
```

This will open your browser and ask you to authenticate. After logging in successfully, you'll be authorized to manage Firebase projects from the command line.

### Step 4: Generate firebase_options.dart

Navigate to your project directory and run:

```bash
cd c:\Users\Admin\Desktop\Y3\3\flutter\ungDunghoctienganh_Thuan_Vu_1_2026\ungDunghoctienganh_Thuan_Vu_1_2026\Ung_dunghoctienganh_Thuan_Vu_1_2026\ungdunghoctienganh

# Using the installed flutterfire CLI
dart pub global run flutterfire_cli:flutterfire configure
```

Follow the prompts:
- Select your Firebase project
- Choose which platforms to configure (Android, iOS, Web, etc.)
- The tool will generate `lib/firebase_options.dart` with your Firebase credentials

The generated `lib/firebase_options.dart` will replace the template file with actual configuration values.

### Step 5: Enable Firestore Database

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to "Firestore Database" in the left sidebar
4. Click "Create Database"
5. Choose "Start in test mode" (for development)
6. Choose your region (closest to your location)
7. Click "Enable"

### Step 6: Set Firestore Security Rules

For development purposes, update the Firestore Security Rules:

1. In Firebase Console, go to Firestore Database → Rules
2. Replace the default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Note**: For production, implement proper authentication and authorization rules.

### Step 7: Test the App

```bash
flutter run
```

The app will now:
- Initialize Firebase on startup
- Store student data locally in your app
- Sync data with Firestore (when configured)
- Display both local and Firestore student counts

## CRUD Operations

### Local Operations
The app maintains local student data that persists during the session:
- **Create**: Add new students (e.g., s888888)
- **Read**: View all students
- **Update**: Edit student information
- **Delete**: Remove students

### Firestore Operations
When Firebase is properly configured, all CRUD operations also sync to Firestore:
- Data persists across app sessions
- Real-time updates available via `getStudentsStream()` in `FirestoreService`
- Automatic cloud backup

## File Structure

```
lib/
├── main.dart                    # Updated with Firebase initialization
├── firebase_options.dart         # Firebase configuration (generated/placeholder)
├── student.dart                 # Student model
├── list_student.dart            # Local CRUD operations
├── services/
│   └── firestore_service.dart   # Firestore CRUD operations
├── screens/
│   ├── home_page.dart
│   ├── content_page.dart
│   └── about_page.dart
```

## Service Usage

### FirestoreService Methods

```dart
final firestoreService = FirestoreService();

// Create
await firestoreService.createStudent(student);

// Read all
final students = await firestoreService.readAllStudents();

// Read by ID
final student = await firestoreService.readStudentById('s123456');

// Update
await firestoreService.updateStudent(
  's123456',
  fullname: 'New Name',
  currentLesson: 'New Lesson',
);

// Delete
await firestoreService.deleteStudent('s123456');

// Real-time stream
final stream = firestoreService.getStudentsStream();
```

## Troubleshooting

### "Firebase CLI not found"
- Ensure you've installed firebase-tools via npm or the Windows installer
- Add the installation directory to your system PATH

### "FlutterFire CLI not found"
```bash
# Reinstall FlutterFire CLI
dart pub global activate flutterfire_cli
```

### "Firestore initialization failed"
- Verify that `firebase_options.dart` contains correct credentials
- Check Firebase Console for the correct project configuration
- Ensure Firestore Database is enabled in your Firebase project

### "Permission denied" errors
- Update Firestore Security Rules to allow read/write access
- For production, implement proper authentication

## Next Steps

1. Implement user authentication (Firebase Auth)
2. Add data validation
3. Implement proper Firestore security rules
4. Add offline persistence
5. Implement real-time sync using Stream

## References

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase CLI Documentation](https://firebase.google.com/docs/cli)
