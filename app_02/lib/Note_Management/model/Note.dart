class Note {
  int? id; // ID của ghi chú (có thể là null khi tạo mới)
  String title; // Tiêu đề ghi chú
  String content; // Nội dung ghi chú
  int priority; // Mức độ ưu tiên của ghi chú (1, 2, 3...)
  DateTime createdAt; // Thời gian tạo ghi chú
  DateTime modifiedAt; // Thời gian chỉnh sửa gần nhất của ghi chú
  List<String>? tags; // Danh sách các tag (có thể null nếu không có)
  String? color; // Màu sắc của ghi chú (có thể null nếu không có)

  // Constructor chính
  Note({
    this.id, // ID của ghi chú (tùy chọn)
    required this.title, // Tiêu đề ghi chú (bắt buộc)
    required this.content, // Nội dung ghi chú (bắt buộc)
    required this.priority, // Mức độ ưu tiên ghi chú (bắt buộc)
    required this.createdAt, // Thời gian tạo ghi chú (bắt buộc)
    required this.modifiedAt, // Thời gian chỉnh sửa ghi chú (bắt buộc)
    this.tags, // Danh sách tags (tùy chọn)
    this.color, // Màu sắc ghi chú (tùy chọn)
  });

  // Constructor tạo Note từ Map (dùng khi lấy dữ liệu từ SQLite)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'], // ID ghi chú từ Map
      title: map['title'], // Tiêu đề ghi chú từ Map
      content: map['content'], // Nội dung ghi chú từ Map
      priority: map['priority'], // Mức độ ưu tiên từ Map
      createdAt: DateTime.parse(map['createdAt']), // Chuyển đổi chuỗi thành DateTime cho thời gian tạo
      modifiedAt: DateTime.parse(map['modifiedAt']), // Chuyển đổi chuỗi thành DateTime cho thời gian chỉnh sửa
      tags: map['tags'] != null ? map['tags'].split(',') : null, // Chuyển chuỗi tags thành danh sách (nếu có)
      color: map['color'], // Màu sắc ghi chú từ Map
    );
  }

  // Chuyển Note thành Map (dùng khi lưu vào SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID của ghi chú
      'title': title, // Tiêu đề ghi chú
      'content': content, // Nội dung ghi chú
      'priority': priority, // Mức độ ưu tiên của ghi chú
      'createdAt': createdAt.toIso8601String(), // Chuyển DateTime thành chuỗi ISO8601 cho thời gian tạo
      'modifiedAt': modifiedAt.toIso8601String(), // Chuyển DateTime thành chuỗi ISO8601 cho thời gian chỉnh sửa
      'tags': tags?.join(','), // Lưu danh sách tags thành chuỗi (nếu có tags)
      'color': color, // Màu sắc ghi chú
    };
  }

  // Tạo bản sao mới với các giá trị cập nhật
  Note copyWith({
    int? id, // Cập nhật ID nếu có (tùy chọn)
    String? title, // Cập nhật tiêu đề nếu có (tùy chọn)
    String? content, // Cập nhật nội dung nếu có (tùy chọn)
    int? priority, // Cập nhật mức độ ưu tiên nếu có (tùy chọn)
    DateTime? createdAt, // Cập nhật thời gian tạo nếu có (tùy chọn)
    DateTime? modifiedAt, // Cập nhật thời gian chỉnh sửa nếu có (tùy chọn)
    List<String>? tags, // Cập nhật danh sách tags nếu có (tùy chọn)
    String? color, // Cập nhật màu sắc nếu có (tùy chọn)
  }) {
    return Note(
      id: id ?? this.id, // Nếu id không truyền vào, giữ giá trị hiện tại
      title: title ?? this.title, // Nếu title không truyền vào, giữ giá trị hiện tại
      content: content ?? this.content, // Nếu content không truyền vào, giữ giá trị hiện tại
      priority: priority ?? this.priority, // Nếu priority không truyền vào, giữ giá trị hiện tại
      createdAt: createdAt ?? this.createdAt, // Nếu createdAt không truyền vào, giữ giá trị hiện tại
      modifiedAt: modifiedAt ?? this.modifiedAt, // Nếu modifiedAt không truyền vào, giữ giá trị hiện tại
      tags: tags ?? this.tags, // Nếu tags không truyền vào, giữ giá trị hiện tại
      color: color ?? this.color, // Nếu color không truyền vào, giữ giá trị hiện tại
    );
  }

  @override
  String toString() {
    // Trả về chuỗi mô tả ghi chú
    return 'Note(id: $id, title: $title, content: $content, priority: $priority, createdAt: $createdAt, modifiedAt: $modifiedAt, tags: $tags, color: $color)';
  }
}
