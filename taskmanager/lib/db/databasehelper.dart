import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user.dart';
import '../model/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return openDatabase(path, onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE users(
          id TEXT PRIMARY KEY,
          username TEXT,
          password TEXT,
          email TEXT,
          avatar TEXT,
          createdAt TEXT,
          lastActive TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          status TEXT,
          priority INTEGER,
          dueDate TEXT,
          createdAt TEXT,
          updatedAt TEXT,
          assignedTo TEXT,
          createdBy TEXT,
          category TEXT,
          attachments TEXT,
          completed INTEGER
        )
      ''');
    }, version: 1);
  }

  // Phương thức thêm user
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Phương thức lấy tất cả user
  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Phương thức thêm task
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Phương thức lấy tất cả task
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Cập nhật task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update('tasks', task.toMap(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  // Xóa task
  Future<int> deleteTask(String taskId) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  // Tìm kiếm task theo title
  Future<List<Task>> searchTasks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks',
        where: 'title LIKE ?', whereArgs: ['%$query%']);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}
