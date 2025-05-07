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
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Kết thúc bài kiểm tra'),
              content: Text(
                'Đúng: $correct | Sai: $incorrect\nTỉ lệ đúng: ${((correct / (correct + incorrect)) * 100).toStringAsFixed(1)}%',
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
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Không có dữ liệu kiểm tra.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Trắc nghiệm Đúng / Sai')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(words[index].word, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('Đáp án: ${words[index].meaning}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _answer(words[index].meaning.toLowerCase()),
              child: const Text('Đúng'),
            ),
            ElevatedButton(
              onPressed: () => _answer('sai'),
              child: const Text('Sai'),
            ),
          ],
        ),
      ),
    );
  }
}
