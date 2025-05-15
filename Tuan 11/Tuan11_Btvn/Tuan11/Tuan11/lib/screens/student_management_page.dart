import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../widgets/student_list_item.dart';

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({Key? key}) : super(key: key);

  @override
  _StudentManagementPageState createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  List<Student> students = [];
  List<Class> classes = [];
  Map<String, String> classNames = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    await _loadClasses();
    await _refreshStudentList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadClasses() async {
    classes = await DatabaseProvider.instance.getClasses();
    classNames.clear();

    for (var classItem in classes) {
      classNames[classItem.classId] = classItem.className;
    }
  }

  Future<void> _refreshStudentList() async {
    final newStudents = await DatabaseProvider.instance.getStudents();
    setState(() {
      students = newStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sinh viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : students.isEmpty
              ? const Center(child: Text('Chưa có sinh viên nào'))
              : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return StudentListItem(
                    student: students[index],
                    onEdit: () => _editStudent(students[index]),
                    onDelete: () => _deleteStudent(students[index]),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addStudent() async {
    if (classes.isEmpty) {
      _showToast('Vui lòng tạo lớp học trước');
      return;
    }

    final TextEditingController studentIdController = TextEditingController();
    final TextEditingController studentNameController = TextEditingController();
    String? selectedClassId = classes.first.classId;
    String? avatarPath;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thêm sinh viên mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              avatarPath = pickedFile.path;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              avatarPath != null
                                  ? FileImage(File(avatarPath!))
                                  : null,
                          child:
                              avatarPath == null
                                  ? const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: studentIdController,
                      decoration: const InputDecoration(
                        labelText: 'Mã sinh viên',
                      ),
                    ),
                    TextField(
                      controller: studentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sinh viên',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedClassId,
                      decoration: const InputDecoration(labelText: 'Lớp'),
                      items:
                          classes.map((classItem) {
                            return DropdownMenuItem(
                              value: classItem.classId,
                              child: Text(classItem.className),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClassId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () async {
                    if (studentIdController.text.isEmpty ||
                        studentNameController.text.isEmpty ||
                        selectedClassId == null) {
                      _showToast('Vui lòng điền đầy đủ thông tin');
                      return;
                    }

                    String? finalAvatarPath;
                    if (avatarPath != null) {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final fileName =
                          '${studentIdController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      final savedImage = await File(
                        avatarPath!,
                      ).copy('${directory.path}/$fileName');
                      finalAvatarPath = savedImage.path;
                    }

                    final student = Student(
                      studentId: studentIdController.text,
                      studentName: studentNameController.text,
                      classId: selectedClassId!,
                      avatarPath: finalAvatarPath,
                    );

                    final success = await DatabaseProvider.instance.addStudent(
                      student,
                    );
                    if (success) {
                      _showToast('Thêm sinh viên thành công');
                      Navigator.of(context).pop();
                      await _refreshStudentList();
                    } else {
                      _showToast('Có lỗi khi thêm sinh viên');
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editStudent(Student student) async {
    final TextEditingController studentIdController = TextEditingController(
      text: student.studentId,
    );
    final TextEditingController studentNameController = TextEditingController(
      text: student.studentName,
    );
    String? selectedClassId = student.classId;
    String? avatarPath = student.avatarPath;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Chỉnh sửa sinh viên'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              avatarPath = pickedFile.path;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              avatarPath != null
                                  ? FileImage(File(avatarPath!))
                                  : null,
                          child:
                              avatarPath == null
                                  ? const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: studentIdController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Mã sinh viên',
                      ),
                    ),
                    TextField(
                      controller: studentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sinh viên',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedClassId,
                      decoration: const InputDecoration(labelText: 'Lớp'),
                      items:
                          classes.map((classItem) {
                            return DropdownMenuItem(
                              value: classItem.classId,
                              child: Text(classItem.className),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClassId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () async {
                    if (studentNameController.text.isEmpty ||
                        selectedClassId == null) {
                      _showToast('Vui lòng điền đầy đủ thông tin');
                      return;
                    }

                    String? finalAvatarPath = avatarPath;
                    if (avatarPath != null &&
                        avatarPath != student.avatarPath) {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final fileName =
                          '${studentIdController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      final savedImage = await File(
                        avatarPath!,
                      ).copy('${directory.path}/$fileName');
                      finalAvatarPath = savedImage.path;
                    }

                    final updatedStudent = Student(
                      studentId: student.studentId,
                      studentName: studentNameController.text,
                      classId: selectedClassId!,
                      avatarPath: finalAvatarPath,
                    );

                    final success = await DatabaseProvider.instance
                        .updateStudent(updatedStudent);
                    if (success) {
                      _showToast('Cập nhật sinh viên thành công');
                      Navigator.of(context).pop();
                      await _refreshStudentList();
                    } else {
                      _showToast('Có lỗi khi cập nhật sinh viên');
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa sinh viên ${student.studentName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );

    if (confirmed ?? false) {
      final success = await DatabaseProvider.instance.deleteStudent(
        student.studentId,
      );
      if (success) {
        _showToast('Xóa sinh viên thành công');
        await _refreshStudentList();
      } else {
        _showToast('Có lỗi khi xóa sinh viên');
      }
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
