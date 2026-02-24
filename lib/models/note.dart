import 'dart:convert';

class Note {
  String id;           // UUID duy nhất (uuid package)
  String title;        // Tiêu đề ghi chú
  String content;      // Nội dung ghi chú
  int colorValue;      // Màu nền (lưu dưới dạng int: color.value)
  DateTime createdAt;  // Ngày tạo
  DateTime updatedAt;  // Ngày chỉnh sửa cuối

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.colorValue,
    required this.createdAt,
    required this.updatedAt,
  });

  // Chuyển đổi sang Map để jsonEncode
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'colorValue': colorValue,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // Khôi phục từ Map sau jsonDecode
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    colorValue: json['colorValue'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Note copyWith({
    String? title,
    String? content,
    int? colorValue,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
