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
      appBar: AppBar(
        title: const Text('Thêm từ mới'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập từ mới:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                hintText: 'Nhập từ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal[50],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nhập nghĩa của từ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: meaningController,
              decoration: InputDecoration(
                hintText: 'Nhập nghĩa...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal[50],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveWord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Lưu và Nhắc học sau 10 phút',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
