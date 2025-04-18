import 'package:app_02/Note_Management/db/NoteDatabaseHelper.dart'; // Thư viện để tương tác với cơ sở dữ liệu lưu trữ ghi chú
import 'package:flutter/material.dart'; // Thư viện UI của Flutter
import 'package:app_02/Note_Management/model/Note.dart'; // Mô hình Note

class NoteFormScreen extends StatefulWidget {
  final Note? note; // Dữ liệu ghi chú được truyền vào nếu có (có thể là null nếu là màn hình thêm mới)

  NoteFormScreen({this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Khóa toàn cục cho Form để kiểm tra tính hợp lệ của các trường
  late TextEditingController _titleController; // Controller cho trường Tiêu đề
  late TextEditingController _contentController; // Controller cho trường Nội dung
  int _priority = 1; // Mặc định mức độ ưu tiên là 1 (Thấp)
  List<String> _tags = []; // Danh sách các nhãn gắn kèm với ghi chú
  String _color = 'blue'; // Màu sắc mặc định của ghi chú là 'blue'

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Nếu có ghi chú (chỉnh sửa), khởi tạo các trường với giá trị từ ghi chú cũ
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
      _priority = widget.note!.priority;
      _tags = widget.note!.tags ?? [];
      _color = widget.note!.color ?? 'blue';
    } else {
      // Nếu không có ghi chú (thêm mới), khởi tạo các trường rỗng
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm mới ghi chú' : 'Chỉnh sửa ghi chú'), // Tiêu đề thay đổi theo điều kiện
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding cho toàn bộ nội dung trong màn hình
        child: Form(
          key: _formKey, // Gắn khóa Form cho việc kiểm tra tính hợp lệ
          child: Column(
            children: [
              // Trường Tiêu đề
              TextFormField(
                controller: _titleController, // Controller để lấy giá trị nhập vào
                decoration: InputDecoration(labelText: 'Tiêu đề'), // Hiển thị nhãn cho trường Tiêu đề
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tiêu đề không được để trống'; // Kiểm tra nếu trường này trống
                  }
                  return null;
                },
              ),
              // Trường Nội dung
              TextFormField(
                controller: _contentController, // Controller để lấy giá trị nhập vào
                decoration: InputDecoration(labelText: 'Nội dung'), // Hiển thị nhãn cho trường Nội dung
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nội dung không được để trống'; // Kiểm tra nếu trường này trống
                  }
                  return null;
                },
              ),
              // Dropdown cho mức độ ưu tiên
              DropdownButton<int>(
                value: _priority, // Giá trị mặc định là _priority
                onChanged: (newValue) {
                  setState(() {
                    _priority = newValue!; // Cập nhật giá trị mức độ ưu tiên khi chọn một giá trị mới
                  });
                },
                items: [
                  DropdownMenuItem(child: Text('Thấp'), value: 1),
                  DropdownMenuItem(child: Text('Trung bình'), value: 2),
                  DropdownMenuItem(child: Text('Cao'), value: 3),
                ],
              ),
              SizedBox(height: 20),
              // Nút bấm để gửi dữ liệu form
              ElevatedButton(
                onPressed: _submitForm, // Gọi hàm _submitForm khi nhấn nút
                child: Text(widget.note == null ? 'Thêm mới' : 'Cập nhật'), // Nút thay đổi theo việc thêm mới hay cập nhật
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm để xử lý việc gửi form và lưu ghi chú vào cơ sở dữ liệu
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Nếu các trường nhập vào hợp lệ (không trống)
      final note = Note(
        id: widget.note?.id, // Lấy ID của ghi chú cũ (nếu có)
        title: _titleController.text, // Lấy giá trị Tiêu đề
        content: _contentController.text, // Lấy giá trị Nội dung
        priority: _priority, // Lấy giá trị Mức độ ưu tiên
        createdAt: widget.note?.createdAt ?? DateTime.now(), // Nếu là thêm mới, lấy thời gian hiện tại
        modifiedAt: DateTime.now(), // Thời gian cập nhật luôn là thời gian hiện tại
        tags: _tags, // Nhãn gắn kèm ghi chú
        color: _color, // Màu sắc của ghi chú
      );

      if (widget.note == null) {
        // Nếu là thêm mới ghi chú
        NoteDatabaseHelper().insertNote(note);
      } else {
        // Nếu là chỉnh sửa ghi chú
        NoteDatabaseHelper().updateNote(note);
      }

      // Quay lại màn hình trước
      Navigator.pop(context);
    }
  }
}
