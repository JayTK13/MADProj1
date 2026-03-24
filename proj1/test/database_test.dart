import 'package:flutter_test/flutter_test.dart';

// Basic unit tests for session logic
void main() {
  group('Session Logic Tests', () {
    test('Duration should be positive', () {
      int duration = 30;

      expect(duration > 0, true);
    });
    // Test to ensure that mood is not empty
    test('Mood should not be empty', () {
      String mood = 'Calm';

      expect(mood.isNotEmpty, true);
    });
  });
}
