import 'package:flutter/material.dart';
import '../model/note.dart';
import '../view/NoteDetailScreen.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback? onDeleted;
  final VoidCallback? onEdited;

  const NoteListItem({
    super.key,
    required this.note,
    this.onDeleted,
    this.onEdited,
  });

  Color _priorityColor(int p) {
    switch (p) {
      case 3:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 1:
      default:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = note.color != null
        ? Color(int.parse(note.color!.replaceFirst('#', '0xff')))
        : Colors.white;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteDetailScreen(note: note),
          ),
        ).then((value) {
          if (value == true && onEdited != null) {
            onEdited!();
          }
        });
      },
      child: Card(
        color: bgColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề + ưu tiên
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.flag, color: _priorityColor(note.priority), size: 20),
                ],
              ),
              const SizedBox(height: 8),

              // Nội dung rút gọn
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),

              // Thời gian
              Text(
                'Cập nhật: ${_formatDate(note.modifiedAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),

              const SizedBox(height: 8),

              // Tags nếu có
              if (note.tags != null && note.tags!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: note.tags!
                      .map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
