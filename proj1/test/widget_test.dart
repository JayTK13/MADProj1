import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj1/screens/start_session_screen.dart';

// Basic widget test to ensure StartSessionScreen loads correctly
void main() {
  testWidgets('StartSessionScreen loaded correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: StartSessionScreen()));

    // Verify that key UI elements are present
    expect(find.text('Start Session'), findsWidgets);
    expect(find.text('Mood'), findsOneWidget);
    expect(find.text('Task Type'), findsOneWidget);
  });
}
