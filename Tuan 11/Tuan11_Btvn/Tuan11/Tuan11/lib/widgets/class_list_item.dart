import 'package:flutter/material.dart';
import '../models/class.dart';

class ClassListItem extends StatelessWidget {
  final Class classItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClassListItem({
    Key? key,
    required this.classItem,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink,
          child: const Text('C', style: TextStyle(color: Colors.white)),
        ),
        title: Text(classItem.classId),
        subtitle: Text(classItem.className),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}