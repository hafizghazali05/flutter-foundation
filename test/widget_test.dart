// Smoke tests for the Flutter Foundation template.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_foundation/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('email accepts valid and rejects invalid', () {
      expect(Validators.email('hafiz@livewebs.my'), isNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('password requires 6+ chars', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('123'), isNotNull);
    });

    test('otp requires 6 digits', () {
      expect(Validators.otp('123456'), isNull);
      expect(Validators.otp('12ab56'), isNotNull);
    });
  });
}
