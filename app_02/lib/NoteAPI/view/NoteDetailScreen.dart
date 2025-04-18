import 'package:flutter/material.dart';
import '../model/note.dart';
import '../view/NoteForm.dart';
import '../api/NoteAPIService.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}';
  }

  String _priorityText(int p) {
    switch (p) {
      case 3:
        return 'Cao';
      case 2:
        return 'Trung bình';
      case 1:
      default:
        return 'Thấp';
    }
  }

  Future<void> _deleteNote(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá ghi chú'),
        content: const Text('Bạn có chắc muốn xoá ghi chú này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await NoteAPIService.instance.deleteNote(note.id!);
        if (context.mounted) Navigator.pop(context, true);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
        }
      }
    }
  }

  void _editNote(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(existingNote: note),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true); // để reload lại danh sách sau khi sửa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(note.color?.replaceFirst('#', '0xff') ?? '0xffffffff')),
      appBar: AppBar(
        title: const Text('Chi tiết ghi chú'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => _editNote(context)),
          IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteNote(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(note.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Mức độ ưu tiên: ${_priorityText(note.priority)}'),
            const SizedBox(height: 8),
            Text('Tạo lúc: ${_formatDate(note.createdAt)}'),
            Text('Cập nhật lúc: ${_formatDate(note.modifiedAt)}'),
            const Divider(height: 24),
            Text(note.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: note.tags!
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
