import 'package:flutter/material.dart';
import 'add_word_screen.dart';
import 'review_screen.dart';
import 'quiz_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ lý học từ vựng')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Trang chính'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddWordScreen()),
                  ),
            ),
            ListTile(
              title: const Text('Học từ'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewScreen()),
                  ),
            ),
            ListTile(
              title: const Text('Kiểm tra từ'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizScreen()),
                  ),
            ),
            ListTile(
              title: const Text('Lịch nhắc'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                  ),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Chọn chức năng từ menu bên trái.')),
    );
  }
}
