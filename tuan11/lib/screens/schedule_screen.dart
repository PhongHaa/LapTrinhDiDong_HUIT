import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch nhắc')),
      body: const Center(
        child: Text(
          'Chức năng xem lịch nhắc sẽ bổ sung sau (nâng cao nếu cần).',
        ),
      ),
    );
  }
}
