import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'English Learning'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // 🔹 1. BIẾN
  String topic = "Daily Conversation";
  String currentWord = "Hello";
  int learnedWords = 10;
  bool isLearning = true;

  // 🔹 2. COLLECTIONS
  List<String> vocabulary = ["Hello", "Goodbye", "Thank you", "Sorry"];

  List<String> skills = ["Listening", "Speaking", "Reading", "Writing"];

  Map<String, int> progress = {
    "Listening": 70,
    "Speaking": 50,
    "Reading": 80,
    "Writing": 60,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            // 📌 CARD THÔNG TIN CHUNG
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.topic, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text("Topic: $topic"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.translate, color: Colors.green),
                        const SizedBox(width: 8),
                        Text("Word: $currentWord"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text("Learned: $learnedWords words"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.school, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text("Status: ${isLearning ? "Learning" : "Stopped"}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📌 CARD TỪ VỰNG
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vocabulary",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),

                    ...vocabulary.map((word) {
                      return Row(
                        children: [
                          const Icon(Icons.book, size: 18),
                          const SizedBox(width: 8),
                          Text(word),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📌 CARD KỸ NĂNG
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Skills",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),

                    ...skills.map((skill) {
                      return Row(
                        children: [
                          const Icon(Icons.school, size: 18),
                          const SizedBox(width: 8),
                          Text(skill),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📌 CARD TIẾN ĐỘ
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Progress",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),

                    ...progress.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text("${entry.value}%"),
                            ],
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: entry.value / 100,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}