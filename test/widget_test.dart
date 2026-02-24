import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_note/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartNoteApp());

    // Verify that the title is present.
    expect(find.textContaining('Smart Note'), findsWidgets);
  });
}
