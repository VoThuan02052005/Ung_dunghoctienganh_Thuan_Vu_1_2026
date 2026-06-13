import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'lessons_tab.dart';
import 'quiz_tab.dart';
import 'profile_tab.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeTab(userName: widget.userName),
      const LessonsTab(),
      const QuizTab(),
      ProfileTab(userName: widget.userName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF667EEA),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 11,
          unselectedFontSize: 11,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Bài học'),
            BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined), activeIcon: Icon(Icons.quiz), label: 'Quiz'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Hồ sơ'),
          ],
        ),
      ),
    );
  }
}
