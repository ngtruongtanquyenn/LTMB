import 'package:app_02/Note_Management/view/NoteDetailScreen.dart';
import 'package:flutter/material.dart';
import '../model/Note.dart'; // Mô hình Note (được sử dụng trong widget này)
import '../db/NoteDatabaseHelper.dart'; // Truy cập cơ sở dữ liệu ghi chú

class NoteItem extends StatelessWidget {
  final Note note; // Đối tượng Note được truyền vào từ widget cha
  final VoidCallback onDelete; // Hàm gọi khi xóa ghi chú

  // Constructor để nhận một Note và onDelete làm tham số
  NoteItem({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0), // Khoảng cách giữa các Card trong danh sách
      color: _getPriorityColor(note.priority), // Màu nền của Card được xác định theo mức độ ưu tiên
      child: ListTile(
        title: Text(note.title), // Tiêu đề của ghi chú
        subtitle: Text(
          note.content.length > 50
              ? note.content.substring(0, 50) + '...' // Nếu nội dung quá dài, chỉ hiển thị 50 ký tự đầu và thêm "..."
              : note.content,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              note.priority == 1
                  ? 'Thấp' // Mức độ ưu tiên Thấp
                  : (note.priority == 2 ? 'Trung bình' : 'Cao'), // Mức độ ưu tiên Trung bình hoặc Cao
              style: TextStyle(color: Colors.white), // Text có màu trắng
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white), // Biểu tượng xóa
              onPressed: onDelete, // Gọi hàm xóa khi nhấn nút
            ),
          ],
        ),
        onTap: () {
          // Khi người dùng nhấn vào ghi chú, điều hướng đến màn hình chi tiết ghi chú
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteDetailScreen(note: note)), // Chuyển đến màn hình chi tiết
          );
        },
      ),
    );
  }

  // Hàm này trả về màu sắc cho ghi chú dựa trên mức độ ưu tiên
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green; // Màu xanh cho mức độ ưu tiên thấp
      case 2:
        return Colors.yellow; // Màu vàng cho mức độ ưu tiên trung bình
      case 3:
        return Colors.red; // Màu đỏ cho mức độ ưu tiên cao
      default:
        return Colors.white; // Mặc định là màu trắng nếu không xác định mức độ ưu tiên
    }
  }
}
