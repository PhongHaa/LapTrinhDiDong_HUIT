import 'package:flutter/material.dart';
import '../screens/class_management_page.dart';
import '../screens/student_management_page.dart';
import '../widgets/menu_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ quản lý sinh viên'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Class Management Button
            MenuButton(
              title: 'QUẢN LÝ LỚP HỌC',
              icon: 'assets/class_icon.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClassManagementPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Student Management Button
            MenuButton(
              title: 'QUẢN LÝ SINH VIÊN',
              icon: 'assets/class_icon.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentManagementPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}