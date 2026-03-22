import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj1/screens/start_session_screen.dart';

void main() {
  testWidgets('Full session flow works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: StartSessionScreen()));

    await tester.tap(find.text('Start Session'));
    await tester.pump();

    expect(find.text('Session Saved'), findsOneWidget);
  });
}
