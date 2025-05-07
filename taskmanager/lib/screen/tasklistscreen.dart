import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/task.dart';
import '../db/databasehelper.dart';
import '../screen/taskformcscreen.dart'; // Import màn hình thêm công việc
import '../screen/taskdetailscreen.dart'; // Import màn hình chi tiết công việc
import '../screen/login.dart';

class TaskListScreen extends StatefulWidget {
  final User? user;

  TaskListScreen({this.user});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasks;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    tasks = _getTasks();
  }

  Future<List<Task>> _getTasks() async {
    return await DatabaseHelper().getTasks();
  }

  void _logout() async {
    await _auth.signOut();  // Đăng xuất người dùng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),  // Điều hướng về màn hình đăng nhập
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        backgroundColor: Colors.blueAccent,  // Thêm màu nền appBar
        actions: [
          if (widget.user != null)
            CircleAvatar(
              backgroundImage: widget.user!.photoURL != null
                  ? NetworkImage(widget.user!.photoURL!)
                  : null,
              child: widget.user!.photoURL == null ? const Icon(Icons.person) : null,
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,  // Đăng xuất
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Đã xảy ra lỗi!'));
          }

          final taskList = snapshot.data ?? [];

          if (taskList.isEmpty) {
            return const Center(child: Text('Không có công việc nào.'));
          }

          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Trạng thái: ${task.status}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DatabaseHelper().deleteTask(task.id);  // Xóa công việc
                      setState(() {
                        tasks = _getTasks();  // Cập nhật lại danh sách công việc
                      });
                    },
                  ),
                  onTap: () async {
                    // Điều hướng đến màn hình chi tiết công việc
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );

                    // Kiểm tra nếu có thay đổi từ màn hình chi tiết công việc
                    if (result != null && result is Task) {
                      setState(() {
                        tasks = _getTasks();  // Cập nhật lại danh sách công việc
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến màn hình thêm công việc
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(),
            ),
          ).then((_) {
            // Khi trở lại màn hình danh sách công việc, cập nhật danh sách
            setState(() {
              tasks = _getTasks();  // Cập nhật lại danh sách công việc
            });
          });
        },
        backgroundColor: Colors.blueAccent,  // Màu sắc của nút thêm công việc
        child: const Icon(Icons.add),
      ),
    );
  }
}
