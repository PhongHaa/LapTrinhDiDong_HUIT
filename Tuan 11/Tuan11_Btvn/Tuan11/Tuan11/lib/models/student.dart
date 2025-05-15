class Student {
  final String studentId;
  final String studentName;
  final String classId;
  final String? avatarPath;

  Student({
    required this.studentId,
    required this.studentName,
    required this.classId,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'classId': classId,
      'avatarPath': avatarPath,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['studentId'],
      studentName: map['studentName'],
      classId: map['classId'],
      avatarPath: map['avatarPath'],
    );
  }

  @override
  String toString() {
    return 'Student{studentId: $studentId, studentName: $studentName, classId: $classId, avatarPath: $avatarPath}';
  }
}