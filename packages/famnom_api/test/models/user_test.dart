import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    group('fromJson', () {
      test('returns User', () {
        expect(
          User.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'email': constants.testEmail,
              'first_name': constants.testFirstName,
              'last_name': constants.testLastName,
              'is_pregnant': false,
              'date_of_birth': constants.testDateOfBirth,
              'family_members': constants.testFamilyMembers,
            },
          ),
          isA<User>()
              .having(
                (User u) => u.externalId,
                'external_id',
                equals(constants.testUUID),
              )
              .having(
                (User u) => u.email,
                'email',
                equals(constants.testEmail),
              )
              .having(
                (User u) => u.firstName,
                'first_name',
                equals(constants.testFirstName),
              )
              .having(
                (User u) => u.lastName,
                'last_name',
                equals(constants.testLastName),
              )
              .having(
                (User u) => u.dateOfBirth,
                'date of birth',
                equals(constants.testDateOfBirth),
              )
              .having(
                (User u) => u.isPregnant,
                'pregnant',
                equals(false),
              )
              .having(
                (User u) => u.familyMembers,
                'family members',
                equals(constants.testFamilyMembers),
              ),
        );
      });
    });
  });
}
