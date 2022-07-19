// ignore_for_file: prefer_const_constructors
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:famnom_flutter/profile/profile.dart';

void main() {
  const firstName = Name.dirty(constants.testFirstName);
  const lastName = Name.dirty(constants.testLastName);
  const email = Email.dirty(constants.testEmail);
  final dateOfBirth = Date.dirty(constants.testDateOfBirth);
  const isPregnant = Flag.dirty('Yes');
  const familyMember = Email.dirty(constants.testEmail);

  group('ProfileState', () {
    test('supports value comparisons', () {
      expect(ProfileState(), ProfileState());
    });

    test('returns same object when no properties are passed', () {
      expect(ProfileState().copyWith(), ProfileState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        ProfileState().copyWith(status: FormzStatus.pure),
        ProfileState(),
      );
    });

    test('returns object with updated first name when it is passed', () {
      expect(
        ProfileState().copyWith(firstName: firstName),
        ProfileState(firstName: firstName),
      );
    });

    test('returns object with updated last name when it is passed', () {
      expect(
        ProfileState().copyWith(lastName: lastName),
        ProfileState(lastName: lastName),
      );
    });

    test('returns object with updated email when it is passed', () {
      expect(
        ProfileState().copyWith(email: email),
        ProfileState(email: email),
      );
    });

    test('returns object with updated date of birth when it is passed', () {
      expect(
        ProfileState().copyWith(dateOfBirth: dateOfBirth),
        ProfileState(dateOfBirth: dateOfBirth),
      );
    });

    test('returns object with updated is pregnant when it is passed', () {
      expect(
        ProfileState().copyWith(isPregnant: isPregnant),
        ProfileState(isPregnant: isPregnant),
      );
    });

    test('returns object with updated family member when it is passed', () {
      expect(
        ProfileState().copyWith(familyMember: familyMember),
        ProfileState(familyMember: familyMember),
      );
    });
  });
}
