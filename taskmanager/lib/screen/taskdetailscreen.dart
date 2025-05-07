import 'package:flutter/material.dart';
import '../model/task.dart';
import '../db/databasehelper.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị ban đầu từ task hiện tại
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
  }

  // Cập nhật trạng thái của task
  void _updateStatus(BuildContext context, String newStatus) async {
    Task updatedTask = widget.task.copyWith(status: newStatus);
    await DatabaseHelper().updateTask(updatedTask);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã cập nhật trạng thái')));
    Navigator.pop(context, updatedTask); // Trở về với task đã cập nhật
  }

  // Lưu thay đổi task
  void _saveChanges() async {
    Task updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
    );

    await DatabaseHelper().updateTask(updatedTask);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã lưu thay đổi')));

    // Trở về và gửi task đã cập nhật về màn hình trước
    Navigator.pop(context, updatedTask);
  }

  // Chọn ngày hết hạn
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _dueDate) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        backgroundColor: Colors.blueAccent,  // Thêm màu nền appBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Tiêu đề công việc
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),

            // Mô tả công việc
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),

            // Trạng thái công việc
            Text('Trạng thái: ${widget.task.status}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),

            // Chọn ngày hết hạn
            ElevatedButton(
              onPressed: () => _selectDueDate(context),
              child: Text(_dueDate == null ? 'Chọn ngày hết hạn' : 'Ngày hết hạn: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Cập nhật trạng thái
            Text('Cập nhật trạng thái:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ["Việc cần làm", "Đang tiến hành", "Đã hoàn thành", "Hủy bỏ"].map((status) {
                return ElevatedButton(
                  onPressed: () => _updateStatus(context, status),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.task.status == status ? Colors.grey : Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(status),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Nút lưu thay đổi
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Lưu thay đổi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
