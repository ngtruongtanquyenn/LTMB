import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../screen/login.dart'; // Màn hình Login
import '../screen/tasklistscreen.dart'; // Màn hình chính sau khi đăng nhập thành công

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Màn hình mặc định khi khởi động
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(), // Theo dõi trạng thái đăng nhập
          builder: (context, snapshot) {
            // Kiểm tra trạng thái kết nối
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // Nếu người dùng đã đăng nhập, điều hướng đến TaskListScreen
                return TaskListScreen(user: snapshot.data); // Truyền User vào TaskListScreen
              } else {
                // Nếu chưa đăng nhập, điều hướng đến LoginScreen
                return const LoginScreen();
              }
            } else {
              // Nếu trạng thái của người dùng đang được tải, hiển thị loading
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      },
    );
  }
}
