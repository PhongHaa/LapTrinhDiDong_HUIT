import 'package:flutter/material.dart';
import '../database/word_database.dart';
import '../models/word.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Word> words = [];
  int index = 0;
  int correct = 0;
  int incorrect = 0;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    words = await WordDatabase.getAllWords();
    setState(() {});
  }

  void _answer(String userAnswer) {
    if (userAnswer == words[index].meaning.toLowerCase()) {
      correct++;
    } else {
      incorrect++;
    }

    if (index < words.length - 1) {
      setState(() => index++);
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final total = correct + incorrect;
    final percentage =
        (total > 0) ? (correct / total * 100).toStringAsFixed(1) : '0';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Kết quả bài kiểm tra'),
            content: Text(
              '✅ Số câu đúng: $correct\n'
              '❌ Số câu sai: $incorrect\n'
              '📊 Tỉ lệ đúng: $percentage%',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Không có dữ liệu kiểm tra.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trắc nghiệm Đúng / Sai'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Từ: ${words[index].word}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Đáp án: ${words[index].meaning}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _answer(words[index].meaning.toLowerCase()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Đúng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _answer('sai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
