import 'package:flutter/material.dart';
import '../model/task.dart';
import '../db/databasehelper.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;
  String? status;

  final List<String> statusList = ["Việc cần làm", "Đang tiến hành", "Đã hoàn thành"];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      dueDate = widget.task!.dueDate;
      status = widget.task!.status;
    } else {
      status = statusList[0];
    }
  }

  Future<void> saveTask() async {
    final task = Task(
      id: widget.task?.id ?? DateTime.now().toString(),
      title: titleController.text,
      description: descriptionController.text,
      status: status ?? 'To do',
      priority: 2,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'user_id',
      assignedTo: null,
      category: 'General',
      attachments: [],
      completed: false,
    );

    if (widget.task == null) {
      await DatabaseHelper().insertTask(task);
    } else {
      await DatabaseHelper().updateTask(task);
    }
    Navigator.pop(context);
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != dueDate) {
      setState(() {
        dueDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Thêm Công Việc' : 'Sửa Công Việc'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tiêu đề công việc
            TextField(
              controller: titleController,
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
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),

            // Chọn ngày đến hạn
            ElevatedButton(
              onPressed: () => _selectDueDate(context),
              child: Text(dueDate == null
                  ? 'Chọn ngày đến hạn'
                  : 'Ngày đến hạn: ${dueDate!.toLocal().toString().split(' ')[0]}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 20),

            // Trạng thái công việc
            DropdownButtonFormField<String>(
              value: status,
              onChanged: (newStatus) {
                setState(() {
                  status = newStatus;
                });
              },
              items: statusList.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Trạng thái',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),

            // Nút lưu công việc
            ElevatedButton(
              onPressed: saveTask,
              child: Text('Lưu công việc'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
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
