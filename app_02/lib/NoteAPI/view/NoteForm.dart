import 'package:flutter/material.dart';
import '../model/note.dart';
import '../api/NoteAPIService.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? existingNote;

  const NoteFormScreen({super.key, this.existingNote});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  int _priority = 1;
  String _color = '#ffffff';

  @override
  void initState() {
    super.initState();

    final note = widget.existingNote;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _tagsController = TextEditingController(text: note?.tags?.join(', ') ?? '');
    _priority = note?.priority ?? 1;
    _color = note?.color ?? '#ffffff';
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final tags = _tagsController.text.split(',').map((e) => e.trim()).where((t) => t.isNotEmpty).toList();

      final note = Note(
        id: widget.existingNote?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: widget.existingNote?.createdAt ?? now,
        modifiedAt: now,
        tags: tags,
        color: _color,
      );

      try {
        if (widget.existingNote == null) {
          await NoteAPIService.instance.createNote(note);
        } else {
          await NoteAPIService.instance.updateNote(note);
        }

        if (context.mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Widget _buildPrioritySelector() {
    return DropdownButtonFormField<int>(
      value: _priority,
      decoration: const InputDecoration(labelText: 'Mức độ ưu tiên'),
      items: const [
        DropdownMenuItem(value: 1, child: Text('Thấp')),
        DropdownMenuItem(value: 2, child: Text('Trung bình')),
        DropdownMenuItem(value: 3, child: Text('Cao')),
      ],
      onChanged: (value) => setState(() => _priority = value!),
    );
  }

  Widget _buildColorPicker() {
    return TextFormField(
      initialValue: _color,
      decoration: const InputDecoration(labelText: 'Mã màu (hex)'),
      onChanged: (value) => _color = value,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa Ghi chú' : 'Thêm Ghi chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Nội dung'),
                maxLines: 5,
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Vui lòng nhập nội dung' : null,
              ),
              const SizedBox(height: 12),
              _buildPrioritySelector(),
              const SizedBox(height: 12),
              _buildColorPicker(),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Nhãn (tags, cách nhau bằng dấu phẩy)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text(isEditing ? 'Cập nhật' : 'Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
