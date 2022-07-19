import 'package:auth_repository/auth_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('uses value equality', () {
      expect(
        const User(email: constants.testEmail, externalId: constants.testUUID),
        equals(
          const User(
            email: constants.testEmail,
            externalId: constants.testUUID,
          ),
        ),
      );
    });

    test('isEmpty returns true for empty user', () {
      expect(User.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty user', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
      );
      expect(user.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty user', () {
      expect(User.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty user', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
      );
      expect(user.isNotEmpty, isTrue);
    });

    test('displayName returns email', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
      );
      expect(user.displayName, equals(constants.testEmail));
    });

    test('displayName returns first name', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
        firstName: constants.testFirstName,
      );
      expect(user.displayName, equals(constants.testFirstName));
    });

    test('displayName returns last name', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
        lastName: constants.testLastName,
      );
      expect(user.displayName, equals(constants.testLastName));
    });

    test('displayName returns first name and last name', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
        firstName: constants.testFirstName,
        lastName: constants.testLastName,
      );
      expect(user.displayName, equals('test_first_name test_last_name'));
    });

    test('familyMembers returns combined string', () {
      const user = User(
        email: constants.testEmail,
        externalId: constants.testUUID,
        firstName: constants.testFirstName,
        lastName: constants.testLastName,
        familyMembers: constants.testFamilyMembers,
      );
      expect(
        user.displayFamilyMembers,
        equals('member1@gmail.com, member2@yahoo.com'),
      );
    });
  });
}
