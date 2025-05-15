import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/class.dart';
import '../providers/student_provider.dart';
import '../widgets/class_list_item.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({Key? key}) : super(key: key);

  @override
  _ClassManagementPageState createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  List<Class> classes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshClassList();
  }

  Future<void> _refreshClassList() async {
    setState(() {
      isLoading = true;
    });

    final classList = await DatabaseProvider.instance.getClasses();

    setState(() {
      classes = classList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý lớp học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : classes.isEmpty
          ? const Center(child: Text('Chưa có lớp học nào'))
          : ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return ClassListItem(
            classItem: classes[index],
            onEdit: () => _editClass(classes[index]),
            onDelete: () => _deleteClass(classes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClass,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addClass() async {
    final TextEditingController classIdController = TextEditingController();
    final TextEditingController classNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm lớp học mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classIdController,
                decoration: const InputDecoration(labelText: 'Mã lớp'),
              ),
              TextField(
                controller: classNameController,
                decoration: const InputDecoration(labelText: 'Tên lớp'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (classIdController.text.isNotEmpty && classNameController.text.isNotEmpty) {
                  final newClass = Class(
                    classId: classIdController.text,
                    className: classNameController.text,
                  );

                  final result = await DatabaseProvider.instance.addClass(newClass);

                  if (result) {
                    Navigator.pop(context);
                    _refreshClassList();
                    _showToast('Đã thêm lớp học mới');
                  } else {
                    _showToast('Lỗi khi thêm lớp học');
                  }
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editClass(Class classItem) async {
    final TextEditingController classIdController = TextEditingController(text: classItem.classId);
    final TextEditingController classNameController = TextEditingController(text: classItem.className);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa thông tin lớp học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classIdController,
                decoration: const InputDecoration(labelText: 'Mã lớp'),
                enabled: false, // Cannot change class ID
              ),
              TextField(
                controller: classNameController,
                decoration: const InputDecoration(labelText: 'Tên lớp'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (classNameController.text.isNotEmpty) {
                  final updatedClass = Class(
                    classId: classItem.classId,
                    className: classNameController.text,
                  );

                  final result = await DatabaseProvider.instance.updateClass(updatedClass);

                  if (result) {
                    Navigator.pop(context);
                    _refreshClassList();
                    _showToast('Đã cập nhật thông tin lớp học');
                  } else {
                    _showToast('Lỗi khi cập nhật lớp học');
                  }
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteClass(Class classItem) async {
    bool confirmDelete = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa lớp ${classItem.className}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                confirmDelete = true;
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      final result = await DatabaseProvider.instance.deleteClass(classItem.classId);

      if (result) {
        _refreshClassList();
        _showToast('Đã xóa lớp học');
      } else {
        _showToast('Không thể xóa lớp học có sinh viên');
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