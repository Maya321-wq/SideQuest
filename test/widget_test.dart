import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sidequest/main.dart';

void main() {
  testWidgets('SideQuest app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SideQuestApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
