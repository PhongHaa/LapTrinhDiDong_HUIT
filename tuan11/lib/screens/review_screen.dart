import 'package:flutter/material.dart';
import '../database/word_database.dart';
import '../models/word.dart';
import '../services/notification_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Word> words = [];
  int currentIndex = 0;
  int correct = 0;
  int incorrect = 0;
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    words = await WordDatabase.getAllWords();
    setState(() {});
  }

  void _checkAnswer() {
    final correctMeaning = words[currentIndex].meaning.trim().toLowerCase();
    final userAnswer = answerController.text.trim().toLowerCase();

    if (userAnswer == correctMeaning) {
      correct++;
    } else {
      incorrect++;
      if (incorrect % 3 == 0) {
        NotificationService.showSimple(
          'Thông báo học tập',
          'Bạn đã sai $incorrect lần!',
        );
      }
    }

    answerController.clear();
    if (currentIndex < words.length - 1) {
      setState(() => currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Scaffold(body: Center(child: Text('Không có từ vựng.')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập từ mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('✅ $correct từ    ❌ $incorrect từ'),
            const SizedBox(height: 16),
            Text(
              words[currentIndex].word,
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Nhập nghĩa tiếng Việt',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _checkAnswer, child: const Text('Check')),
          ],
        ),
      ),
    );
  }
}
