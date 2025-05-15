import 'dart:io';
import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentListItem extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentListItem({
    Key? key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          backgroundImage:
              student.avatarPath != null
                  ? FileImage(File(student.avatarPath!))
                  : null,
          child:
              student.avatarPath == null
                  ? Text(student.studentName[0].toUpperCase())
                  : null,
        ),
        title: Text(student.studentName),
        subtitle: Text('${student.studentId}\n${student.classId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
