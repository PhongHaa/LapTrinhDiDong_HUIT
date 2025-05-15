import '../models/class.dart';
import '../models/student.dart';
import '../services/db_class_service.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance = DatabaseProvider._privateConstructor();

  final DatabaseService _databaseService = DatabaseService();

  Future<void> initDatabase() async {
    await _databaseService.database;
  }

  Future<List<Class>> getClasses() async {
    return await _databaseService.getClasses();
  }

  Future<bool> addClass(Class classItem) async {
    final result = await _databaseService.insertClass(classItem);
    return result > 0;
  }

  Future<bool> updateClass(Class classItem) async {
    final result = await _databaseService.updateClass(classItem);
    return result > 0;
  }

  Future<bool> deleteClass(String classId) async {
    final hasStudents = await _databaseService.hasStudentsInClass(classId);
    if (hasStudents) {
      return false;
    }

    final result = await _databaseService.deleteClass(classId);
    return result > 0;
  }

  Future<List<Student>> getStudents() async {
    return await _databaseService.getStudents();
  }

  Future<bool> addStudent(Student student) async {
    final result = await _databaseService.insertStudent(student);
    return result > 0;
  }

  Future<bool> updateStudent(Student student) async {
    final result = await _databaseService.updateStudent(student);
    return result > 0;
  }

  Future<bool> deleteStudent(String studentId) async {
    final result = await _databaseService.deleteStudent(studentId);
    return result > 0;
  }
}