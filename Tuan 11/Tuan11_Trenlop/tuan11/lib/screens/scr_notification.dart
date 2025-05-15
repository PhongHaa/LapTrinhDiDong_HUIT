import 'package:flutter/material.dart';
import 'package:tuan11/services/service_notification_old.dart';

class ScrNotification extends StatelessWidget {
  const ScrNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Reminder',
      home: Scaffold(
        appBar: AppBar(title: Text('Nhắc học bài tiếng Anh')),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await NotificationService.showSimpleNotification();
                },
                child: Text('Gui thong bao nhac hoc Ngoai ngu'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await NotificationService.scheduleStudyReminderAfter10Minutes();
                  },
                  child: Text('Nhac lam bai tap Ngoai ngu truoc 10 phut'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await NotificationService.scheduleNotificationAfter5Minutes();
                },
                child: Text('Nhac tat may tinh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
