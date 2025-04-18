
import "package:app_02/Note_Management/model/Note.dart"; // Import mô hình Note
import "package:app_02/Note_Management/view/NoteFormScreen.dart"; // Import màn hình chỉnh sửa ghi chú
import "package:flutter/material.dart"; // Thư viện UI của Flutter


class NoteDetailScreen extends StatelessWidget {
  final Note note; // Biến lưu trữ ghi chú được truyền vào từ màn hình trước

  // Constructor nhận vào đối tượng Note
  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title), // Tiêu đề màn hình là tiêu đề ghi chú
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding cho body của màn hình
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Các phần tử trong Column sẽ được căn trái
          children: [
            // Hiển thị tiêu đề ghi chú
            Text(
              note.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Khoảng cách giữa các phần tử
            // Hiển thị nội dung ghi chú
            Text(
              note.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20), // Khoảng cách giữa các phần tử
            // Hiển thị mức độ ưu tiên
            Row(
              children: [
                Text(
                  'Mức độ ưu tiên: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_getPriorityText(note.priority)), // Gọi hàm để lấy chuỗi mô tả mức độ ưu tiên
              ],
            ),
            SizedBox(height: 10),
            // Hiển thị thời gian tạo ghi chú
            Row(
              children: [
                Text(
                  'Thời gian tạo: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(note.createdAt.toString()), // Hiển thị thời gian tạo ghi chú
              ],
            ),
            SizedBox(height: 10),
            // Hiển thị thời gian cập nhật ghi chú
            Row(
              children: [
                Text(
                  'Thời gian cập nhật: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(note.modifiedAt.toString()), // Hiển thị thời gian cập nhật ghi chú
              ],
            ),
            SizedBox(height: 20),
            // Hiển thị danh sách nhãn (tags)
            Text(
              'Những nhãn: ${note.tags?.join(', ') ?? 'Không có'}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Spacer(), // Đẩy các phần tử phía trên lên trên cùng
            // Nút bấm để chuyển đến màn hình chỉnh sửa ghi chú
            ElevatedButton(
              onPressed: () {
                // Chuyển đến màn hình chỉnh sửa ghi chú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteFormScreen(note: note), // Truyền đối tượng note vào màn hình chỉnh sửa
                  ),
                );
              },
              child: Text('Chỉnh sửa ghi chú'), // Nội dung nút
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để chuyển đổi mức độ ưu tiên thành văn bản mô tả
  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Thấp'; // Mức độ ưu tiên thấp
      case 2:
        return 'Trung bình'; // Mức độ ưu tiên trung bình
      case 3:
        return 'Cao'; // Mức độ ưu tiên cao
      default:
        return 'Không xác định'; // Nếu mức độ ưu tiên không hợp lệ
    }
  }
}
