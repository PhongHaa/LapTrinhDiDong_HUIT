import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/db_helper.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final NotificationService _notificationService = NotificationService();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _databaseHelper.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await _databaseHelper.insertTask(task);
    task.id = id;
    _tasks.add(task);

    try {
      final scheduledTime = _parseTimeString(task.reminderTime);
      await _notificationService.scheduleNotification(
        id,
        task.title,
        'Nhắc lúc ${task.reminderTime}',
        scheduledTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }

    notifyListeners();
  }

  DateTime _parseTimeString(String timeString) {
    final now = DateTime.now();
    final parts = timeString.split(':');

    if (parts.length != 2) {
      throw FormatException('Invalid time format: $timeString');
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }

  Future<void> completeTask(Task task) async {
    task.isCompleted = true;
    await _databaseHelper.updateTask(task);

    if (task.id != null) {
      await _notificationService.cancelNotification(task.id!);
    }

    final completedCount = await _databaseHelper.getCompletedTasksCount();
    await _notificationService.showNotification(
      'Nhiệm vụ hoàn thành',
      'Bạn đã hoàn thành $completedCount nhiệm vụ',
    );

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await _databaseHelper.deleteTask(task.id!);
      _tasks.removeWhere((t) => t.id == task.id);
      await _notificationService.cancelNotification(task.id!);
      notifyListeners();
    }
  }
}