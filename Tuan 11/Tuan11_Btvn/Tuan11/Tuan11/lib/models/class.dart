class Class {
  final String classId;
  final String className;

  Class({required this.classId, required this.className});

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      classId: map['classId'],
      className: map['className'],
    );
  }

  @override
  String toString() {
    return 'Class{classId: $classId, className: $className}';
  }
}