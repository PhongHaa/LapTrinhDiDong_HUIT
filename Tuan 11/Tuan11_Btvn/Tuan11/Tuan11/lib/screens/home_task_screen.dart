import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nhiệm vụ mỗi ngày',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Calendar functionality could be added here
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;

          if (tasks.isEmpty) {
            return const Center(child: Text('Chưa có nhiệm vụ nào'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(context, task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: CheckboxListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Nhắc lúc ${task.reminderTime}'),
        value: task.isCompleted,
        onChanged: (bool? value) {
          if (value == true && !task.isCompleted) {
            _showCompletionConfirmDialog(context, task);
          }
        },
        activeColor: Colors.green,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: const Icon(
          Icons.notifications_active_outlined,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showCompletionConfirmDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận hoàn thành'),
          content: Text(
            'Bạn có xác nhận nhiệm vụ "${task.title}" đã hoàn thành?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).completeTask(task);
                Navigator.of(context).pop();
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );
  }
}
