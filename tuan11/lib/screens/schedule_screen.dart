import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<Map<String, String>> scheduledNotifications = [
    // Giả lập danh sách lịch nhắc. Thay bằng dữ liệu thực tế nếu cần.
    {'title': 'Ôn tập từ mới', 'body': 'Apple - Quả táo'},
    {'title': 'Học bài', 'body': 'Làm bài tập Ngữ pháp'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch nhắc'),
        backgroundColor: Colors.teal,
      ),
      body:
          scheduledNotifications.isEmpty
              ? const Center(
                child: Text(
                  'Không có lịch nhắc nào.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: scheduledNotifications.length,
                itemBuilder: (context, index) {
                  final notification = scheduledNotifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Colors.teal,
                      ),
                      title: Text(
                        notification['title'] ?? 'Không có tiêu đề',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        notification['body'] ?? 'Không có nội dung',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
