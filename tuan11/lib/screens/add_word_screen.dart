import 'package:flutter/material.dart';
import '../models/word.dart';
import '../database/word_database.dart';
import '../services/notification_service.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();

  void _saveWord() async {
    final word = Word(
      word: wordController.text,
      meaning: meaningController.text,
    );
    await WordDatabase.insertWord(word);
    await NotificationService.scheduleReminder(
      'Ôn tập từ mới',
      '${word.word} - ${word.meaning}',
      word.hashCode,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu và đặt lịch nhắc sau 10 phút')),
    );
    wordController.clear();
    meaningController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm từ mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(labelText: 'Từ'),
            ),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(labelText: 'Nghĩa'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveWord,
              child: const Text('Lưu và Nhắc học sau 10 phút'),
            ),
          ],
        ),
      ),
    );
  }
}
