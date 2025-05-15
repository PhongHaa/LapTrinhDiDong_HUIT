class Task {
  int? id;
  String title;
  String reminderTime;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.reminderTime,
    this.isCompleted = false,
  });

  // Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      reminderTime: map['reminderTime'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  // Convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'reminderTime': reminderTime,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}