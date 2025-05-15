import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/class.dart';
import '../models/student.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'student_management.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE classes (
        classId TEXT PRIMARY KEY,
        className TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE students (
        studentId TEXT PRIMARY KEY,
        studentName TEXT,
        classId TEXT,
        avatarPath TEXT,
        FOREIGN KEY (classId) REFERENCES classes (classId)
      )
    ''');
  }

  Future<int> insertClass(Class classItem) async {
    final db = await database;
    return await db.insert(
      'classes',
      classItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Class>> getClasses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('classes');

    return List.generate(maps.length, (i) => Class.fromMap(maps[i]));
  }

  Future<int> updateClass(Class classItem) async {
    final db = await database;
    return await db.update(
      'classes',
      classItem.toMap(),
      where: 'classId = ?',
      whereArgs: [classItem.classId],
    );
  }

  Future<int> deleteClass(String classId) async {
    final db = await database;
    return await db.delete(
      'classes',
      where: 'classId = ?',
      whereArgs: [classId],
    );
  }

  Future<bool> hasStudentsInClass(String classId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'classId = ?',
      whereArgs: [classId],
    );
    return maps.isNotEmpty;
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');

    return List.generate(maps.length, (i) => Student.fromMap(maps[i]));
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'studentId = ?',
      whereArgs: [student.studentId],
    );
  }

  Future<int> deleteStudent(String studentId) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
  }
}