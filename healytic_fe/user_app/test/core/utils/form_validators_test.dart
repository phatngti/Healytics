import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/core/utils/form_validators.dart';

void main() {
  group('FormValidators.dateOfBirth', () {
    test('accepts a birthday when the user is at least 16', () {
      final now = DateTime.now();
      final birthday = DateTime(now.year - 16, now.month, now.day);

      expect(FormValidators.dateOfBirth(birthday), isNull);
    });

    test('rejects a birthday when the user is younger than 16', () {
      final now = DateTime.now();
      final birthday = DateTime(now.year - 16, now.month, now.day + 1);

      expect(
        FormValidators.dateOfBirth(birthday),
        'You must be at least 16 years old',
      );
    });
  });
}
