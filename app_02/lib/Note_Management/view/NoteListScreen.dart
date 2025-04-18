import 'package:app_02/Note_Management/view/NoteFormScreen.dart'; // Màn hình để thêm hoặc chỉnh sửa ghi chú
import '../db/NoteDatabaseHelper.dart'; // Truy cập cơ sở dữ liệu ghi chú
import 'package:app_02/Note_Management/model/Note.dart'; // Mô hình ghi chú
import 'package:app_02/Note_Management/view/NoteListItem.dart'; // Widget hiển thị ghi chú trong danh sách
import 'package:flutter/material.dart'; // Thư viện Flutter cho giao diện người dùng

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState(); // Trạng thái của màn hình danh sách ghi chú
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = []; // Danh sách ghi chú hiện có
  bool isGridView = false; // Kiểm tra nếu người dùng muốn xem dạng lưới (grid) hay danh sách (list)
  TextEditingController searchController = TextEditingController(); // Controller cho ô tìm kiếm
  int? selectedPriority; // Mức độ ưu tiên được chọn

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Tải tất cả ghi chú khi màn hình được khởi tạo
  }

  // Hàm tải tất cả ghi chú từ cơ sở dữ liệu
  void _loadNotes() async {
    final allNotes = await NoteDatabaseHelper().getAllNotes(); // Lấy tất cả ghi chú từ cơ sở dữ liệu
    setState(() {
      notes = allNotes; // Cập nhật danh sách ghi chú
    });
  }

  // Hàm tìm kiếm ghi chú dựa trên từ khóa
  void _searchNotes(String query) async {
    if (query.isEmpty) {
      _loadNotes(); // Nếu không có từ khóa tìm kiếm, tải tất cả ghi chú
      return;
    }
    final results = await NoteDatabaseHelper().searchNotes(query); // Tìm kiếm ghi chú
    setState(() {
      notes = results; // Cập nhật danh sách ghi chú theo kết quả tìm kiếm
    });
  }

  // Hàm lọc ghi chú theo mức độ ưu tiên
  void _filterNotesByPriority(int? priority) async {
    // Nếu priority là null, sử dụng giá trị mặc định (ví dụ: 1)
    int finalPriority = priority ?? 1; // Nếu null, gán giá trị mặc định là 1
    final results = await NoteDatabaseHelper().getNotesByPriority(finalPriority); // Lọc ghi chú theo mức độ ưu tiên
    setState(() {
      notes = results; // Cập nhật danh sách ghi chú
    });
  }

  // Hàm xóa ghi chú
  void _deleteNote(int id) async {
    await NoteDatabaseHelper().deleteNote(id); // Xóa ghi chú khỏi cơ sở dữ liệu
    _loadNotes(); // Tải lại danh sách ghi chú sau khi xóa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ghi chú cá nhân'), // Tiêu đề của màn hình
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController, // Controller của ô tìm kiếm
              decoration: InputDecoration(
                labelText: 'Tìm kiếm ghi chú',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear), // Biểu tượng xóa ô tìm kiếm
                  onPressed: () {
                    searchController.clear(); // Xóa ô tìm kiếm
                    _loadNotes(); // Tải lại tất cả ghi chú
                  },
                ),
              ),
              onChanged: _searchNotes, // Tìm kiếm khi thay đổi văn bản
            ),
          ),
          // Dropdown để lọc ghi chú theo mức độ ưu tiên
          DropdownButton<int>(
            hint: Text("Lọc theo mức độ ưu tiên"),
            value: selectedPriority, // Mức độ ưu tiên hiện tại
            onChanged: (value) {
              setState(() {
                selectedPriority = value; // Cập nhật mức độ ưu tiên đã chọn
              });
              _filterNotesByPriority(value); // Lọc ghi chú theo mức độ ưu tiên
            },
            items: [
              DropdownMenuItem(value: 1, child: Text("Thấp")), // Mức độ ưu tiên thấp
              DropdownMenuItem(value: 2, child: Text("Trung bình")), // Mức độ ưu tiên trung bình
              DropdownMenuItem(value: 3, child: Text("Cao")), // Mức độ ưu tiên cao
            ],
          ),
          Expanded(
            child: isGridView
                ? GridView.builder( // Nếu đang ở chế độ GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số cột trong Grid
              ),
              itemCount: notes.length, // Số lượng ghi chú
              itemBuilder: (context, index) {
                return NoteItem(
                  note: notes[index], // Hiển thị ghi chú dưới dạng Grid
                  onDelete: () => _deleteNote(notes[index].id!), // Thêm hành động xóa khi nhấn
                );
              },
            )
                : ListView.builder( // Nếu đang ở chế độ ListView
              itemCount: notes.length, // Số lượng ghi chú
              itemBuilder: (context, index) {
                return NoteItem(
                  note: notes[index], // Hiển thị ghi chú dưới dạng danh sách
                  onDelete: () => _deleteNote(notes[index].id!), // Thêm hành động xóa khi nhấn
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteFormScreen()), // Chuyển đến màn hình thêm ghi chú mới
          );
        },
        child: Icon(Icons.add), // Biểu tượng thêm ghi chú
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.filter_list), // Biểu tượng lọc (chưa có chức năng)
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(isGridView ? Icons.list : Icons.grid_on), // Biểu tượng chuyển đổi giữa Grid và List
              onPressed: () {
                setState(() {
                  isGridView = !isGridView; // Chuyển đổi giữa chế độ Grid và List
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
