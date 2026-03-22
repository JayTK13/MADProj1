import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj1/screens/start_session_screen.dart';

void main() {
  testWidgets('StartSessionScreen loaded correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: StartSessionScreen()));

    expect(find.text('Start Session'), findsOneWidget);
    expect(find.text('Mood'), findsOneWidget);
    expect(find.text('Task Type'), findsOneWidget);
  });
}
