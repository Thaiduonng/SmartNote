import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final NoteService _noteService = NoteService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColor;

  final List<int> _colors = [
    0xFFFFF9C4, // Vàng nhạt
    0xFFDCEDC8, // Xanh lá nhạt
    0xFFFCE4EC, // Hồng nhạt
    0xFFE3F2FD, // Xanh dương nhạt
    0xFFEDE7F6, // Tím nhạt
    0xFFFFF3E0, // Cam nhạt
    0xFFFFFFFF, // Trắng
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.colorValue ?? _colors[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      if (widget.note != null) {
        // If it was an existing note and now empty, maybe delete it or just leave it?
        // Usually, auto-save doesn't delete. I'll just skip saving if empty.
      }
      return;
    }

    if (widget.note == null) {
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        colorValue: _selectedColor,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _noteService.addNote(newNote);
    } else {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
        colorValue: _selectedColor,
        updatedAt: DateTime.now(),
      );
      await _noteService.updateNote(updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveNote();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(_selectedColor),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chọn màu nền',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _colors.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final color = _colors[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedColor = color);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Color(color),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedColor == color
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.black12,
                                      width: _selectedColor == color ? 3 : 1,
                                    ),
                                  ),
                                  child: _selectedColor == color
                                      ? Icon(Icons.check,
                                          size: 20,
                                          color: Theme.of(context).colorScheme.primary)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                  decoration: const InputDecoration(
                    hintText: 'Nội dung ghi chú...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
