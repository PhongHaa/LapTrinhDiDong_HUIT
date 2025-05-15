import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhiệm vụ mới'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên nhiệm vụ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên nhiệm vụ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Giờ nhắc',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: _selectTime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn giờ nhắc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lưu nhiệm vụ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        final hour = _selectedTime.hour.toString().padLeft(2, '0');
        final minute = _selectedTime.minute.toString().padLeft(2, '0');
        _timeController.text = '$hour:$minute';
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text.trim(),
        reminderTime: _timeController.text,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(task);
      Navigator.of(context).pop();
    }
  }
}