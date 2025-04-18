import "../model/Note.dart";
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class NoteDatabaseHelper {
  // Tạo một instance duy nhất của lớp NoteDatabaseHelper
  static final NoteDatabaseHelper _instance = NoteDatabaseHelper._internal();
  static Database? _database;

  // Hàm khởi tạo private để đảm bảo không có instance khác được tạo ra
  NoteDatabaseHelper._internal();

  // Factory constructor trả về instance duy nhất
  factory NoteDatabaseHelper() {
    return _instance;
  }

  // Truy xuất cơ sở dữ liệu, nếu chưa có thì khởi tạo
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(); // Nếu chưa có, khởi tạo DB
    return _database!;
  }

  // Khởi tạo cơ sở dữ liệu và tạo bảng nếu chưa có
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db'); // Lấy đường dẫn DB
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Khóa chính tự động tăng
            title TEXT NOT NULL,                   -- Tiêu đề ghi chú
            content TEXT NOT NULL,                 -- Nội dung ghi chú
            priority INTEGER NOT NULL,             -- Mức độ ưu tiên
            createdAt TEXT NOT NULL,               -- Thời gian tạo
            modifiedAt TEXT NOT NULL,              -- Thời gian chỉnh sửa
            tags TEXT,                             -- Thẻ (nếu có)
            color TEXT                             -- Màu sắc ghi chú
          )
        ''');
      },
    );
  }

  // Thêm ghi chú mới vào cơ sở dữ liệu
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Lấy tất cả ghi chú từ cơ sở dữ liệu
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Lấy ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Cập nhật ghi chú theo ID
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Xóa ghi chú theo ID
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Lọc ghi chú theo mức độ ưu tiên
  Future<List<Note>> getNotesByPriority(int priority) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'priority = ?',
      whereArgs: [priority],
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Tìm kiếm ghi chú theo tiêu đề hoặc nội dung
  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
