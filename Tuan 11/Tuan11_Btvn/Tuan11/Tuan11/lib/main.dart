import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuan11/providers/student_provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_task_screen.dart';
import 'services/notification_service.dart';
import 'services/db_class_service.dart';
import 'screens/home_student_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final notificationService = NotificationService();
//   await notificationService.init();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => TaskProvider(),
//       child: MaterialApp(
//         title: 'Nhiệm vụ mỗi ngày',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           scaffoldBackgroundColor: Colors.white,
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//             elevation: 0,
//           ),
//         ),
//         home: const HomeScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sinh viên',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}