import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchBar(
        controller: controller,
        onChanged: onChanged,
        hintText: 'Tìm kiếm tiêu đề...',
        leading: const Icon(Icons.search),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}
