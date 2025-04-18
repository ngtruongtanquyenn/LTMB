import 'package:flutter/material.dart';
import '../model/note.dart';
import '../api/NoteAPIService.dart';
import '../view/NoteForm.dart';
import '../view/NoteDetailScreen.dart';

class NoteListScreen extends StatefulWidget {
  final Future<void> Function() onLogout; // ✅ Nhận hàm logout

  const NoteListScreen({super.key, required this.onLogout});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];
  bool isLoading = true;
  bool isGridView = true;
  String searchQuery = '';
  int? filterPriority;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() => isLoading = true);
    try {
      List<Note> allNotes = await NoteAPIService.instance.getAllNotes();
      if (searchQuery.isNotEmpty) {
        allNotes = allNotes
            .where((note) => note.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      if (filterPriority != null) {
        allNotes = allNotes.where((note) => note.priority == filterPriority).toList();
      }
      setState(() => notes = allNotes);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    fetchNotes();
  }

  void _onFilterPriority(int? priority) {
    setState(() {
      filterPriority = priority;
    });
    fetchNotes();
  }

  void _toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onLogout(); // ✅ Gọi hàm logout từ widget
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green[200]!;
      case 2:
        return Colors.orange[200]!;
      case 3:
        return Colors.red[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú của bạn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNotes,
          ),
          PopupMenuButton<int?>(
            onSelected: _onFilterPriority,
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('Tất cả')),
              const PopupMenuItem(value: 1, child: Text('Ưu tiên Thấp')),
              const PopupMenuItem(value: 2, child: Text('Ưu tiên Trung bình')),
              const PopupMenuItem(value: 3, child: Text('Ưu tiên Cao')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleViewMode,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _showLogoutDialog();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text('Không có ghi chú nào.'))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: isGridView
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: notes.length,
          itemBuilder: (_, index) => _buildNoteItem(notes[index]),
        )
            : ListView.builder(
          itemCount: notes.length,
          itemBuilder: (_, index) => _buildNoteItem(notes[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
          if (result == true) fetchNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteDetailScreen(note: note),
          ),
        );
      },
      child: Card(
        color: _getPriorityColor(note.priority),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                note.content,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (note.tags != null && note.tags!.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: note.tags!
                      .map((tag) => Chip(label: Text(tag), backgroundColor: Colors.white70))
                      .toList(),
                ),
              const SizedBox(height: 6),
              Text(
                'Cập nhật: ${note.modifiedAt.toLocal().toString().split('.').first}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
