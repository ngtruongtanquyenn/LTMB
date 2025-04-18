import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note.dart';

class NoteAPIService {
  static final NoteAPIService instance = NoteAPIService._init();
  final String baseUrl = 'https://my-json-server.typicode.com/ngtruongtanquyenn/testflutter1';

  NoteAPIService._init();

  // CREATE
  Future<Note> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );

    _handleError(response);
    return Note.fromMap(jsonDecode(response.body));
  }

  // READ - get all
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));

    _handleError(response);
    List data = jsonDecode(response.body);
    return data.map((json) => Note.fromMap(json)).toList();
  }

  // READ - get by id
  Future<Note?> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      _handleError(response);
      return null;
    }
  }

  // UPDATE
  Future<Note> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );

    _handleError(response);
    return Note.fromMap(jsonDecode(response.body));
  }

  // DELETE
  Future<bool> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      _handleError(response);
      return false;
    }
  }

  // COUNT
  Future<int> countNotes() async {
    final notes = await getAllNotes();
    return notes.length;
  }

  // SEARCH by title or content
  Future<List<Note>> searchNotes(String query) async {
    final notes = await getAllNotes();
    return notes.where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // FILTER by priority
  Future<List<Note>> getNotesByPriority(int priority) async {
    final notes = await getAllNotes();
    return notes.where((note) => note.priority == priority).toList();
  }

  // PATCH
  Future<Note> patchNote(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    _handleError(response);
    return Note.fromMap(jsonDecode(response.body));
  }

  // ERROR HANDLER
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('API error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
