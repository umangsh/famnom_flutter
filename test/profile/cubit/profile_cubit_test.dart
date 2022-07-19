// ignore_for_file: prefer_const_constructors
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/profile/profile.dart';

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const validFirstNameString = 'New First Name';
  const validFirstName = Name.dirty(validFirstNameString);

  const validLastNameString = 'New Last Name';
  const validLastName = Name.dirty(validLastNameString);

  const validEmailString = 'new@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validDateString = '2021-12-12';
  final validDate = Date.dirty(validDateString);

  const validIsPregnantString = 'No';
  const validIsPregnant = Flag.dirty(validIsPregnantString);

  const validFamilyMemberString = 'newmember@gmail.com';
  const validFamilyMember = Email.dirty(validFamilyMemberString);

  const invalidFamilyMemberString = 'invalid';
  const invalidFamilyMember = Email.dirty(invalidFamilyMemberString);

  group('ProfileCubit', () {
    late AuthRepository authRepository;
    late User user;

    setUp(() {
      authRepository = MockAuthRepository();
      user = MockUser();
      when(() => authRepository.currentUser).thenReturn(user);
      when(() => user.externalId).thenReturn(constants.testUUID);
      when(() => user.firstName).thenReturn(constants.testFirstName);
      when(() => user.lastName).thenReturn(constants.testLastName);
      when(() => user.email).thenReturn(constants.testEmail);
      when(() => user.dateOfBirth)
          .thenReturn(DateTime.parse(constants.testDateOfBirth));
      when(() => user.isPregnant).thenReturn(true);
      when(
        () => authRepository.updateUser(user),
      ).thenAnswer((_) async {});
      when(
        () => authRepository.getUserFromDB(),
      ).thenAnswer((_) async => user);
    });

    test('initial state is ProfileState', () {
      expect(
        ProfileCubit(authRepository).state,
        ProfileState(
          firstName: Name.pure(constants.testFirstName),
          lastName: Name.pure(constants.testLastName),
          email: Email.pure(constants.testEmail),
          dateOfBirth: Date.pure(constants.testDateOfBirth),
          isPregnant: Flag.pure('Yes'),
        ),
      );
    });

    group('firstNameChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when first name is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(firstName: validFirstName),
        act: (cubit) => cubit.firstNameChanged(validFirstNameString),
        expect: () => <ProfileState>[
          ProfileState(
            firstName: validFirstName,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('lastNameChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when last name is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(lastName: validLastName),
        act: (cubit) => cubit.lastNameChanged(validLastNameString),
        expect: () => <ProfileState>[
          ProfileState(
            lastName: validLastName,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('emailChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [invalid] when email is invalid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(firstName: validFirstName),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => <ProfileState>[
          ProfileState(
            firstName: validFirstName,
            email: invalidEmail,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when email is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(firstName: validFirstName),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => <ProfileState>[
          ProfileState(
            firstName: validFirstName,
            email: validEmail,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('dateChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when date is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(dateOfBirth: validDate),
        act: (cubit) => cubit.dateOfBirthChanged(validDateString),
        expect: () => <ProfileState>[
          ProfileState(
            dateOfBirth: validDate,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('isPregnantChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when isPregnant is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(isPregnant: validIsPregnant),
        act: (cubit) => cubit.isPregnantChanged(validIsPregnantString),
        expect: () => <ProfileState>[
          ProfileState(
            isPregnant: validIsPregnant,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('familyMemberChanged', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [invalid] when family member is invalid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(firstName: validFirstName),
        act: (cubit) => cubit.familyMemberChanged(invalidFamilyMemberString),
        expect: () => <ProfileState>[
          ProfileState(
            firstName: validFirstName,
            familyMember: invalidFamilyMember,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [valid] when email is valid',
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(firstName: validFirstName),
        act: (cubit) => cubit.familyMemberChanged(validFamilyMemberString),
        expect: () => <ProfileState>[
          ProfileState(
            firstName: validFirstName,
            familyMember: validFamilyMember,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('updateProfile', () {
      blocTest<ProfileCubit, ProfileState>(
        'does nothing when status is not validated',
        build: () => ProfileCubit(authRepository),
        act: (cubit) => cubit.updateProfile(),
        expect: () => const <ProfileState>[],
      );

      blocTest<ProfileCubit, ProfileState>(
        'calls updateProfile with correct user',
        build: () => ProfileCubit(authRepository),
        setUp: () {
          when(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                firstName: validFirstNameString,
                lastName: validLastNameString,
                email: validEmailString,
                dateOfBirth: DateTime.parse(validDateString),
                isPregnant: false,
              ),
              '',
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => ProfileState(
          status: FormzStatus.valid,
          firstName: validFirstName,
          lastName: validLastName,
          email: validEmail,
          dateOfBirth: validDate,
          isPregnant: validIsPregnant,
        ),
        act: (cubit) => cubit.updateProfile(),
        verify: (_) {
          verify(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                firstName: validFirstNameString,
                lastName: validLastNameString,
                email: validEmailString,
                dateOfBirth: DateTime.parse(validDateString),
                isPregnant: false,
              ),
              '',
            ),
          ).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'calls updateProfile with correct user and familyMember',
        build: () => ProfileCubit(authRepository),
        setUp: () {
          when(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                firstName: validFirstNameString,
                lastName: validLastNameString,
                email: validEmailString,
                dateOfBirth: DateTime.parse(validDateString),
                isPregnant: false,
              ),
              validFamilyMemberString,
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => ProfileState(
          status: FormzStatus.valid,
          firstName: validFirstName,
          lastName: validLastName,
          email: validEmail,
          dateOfBirth: validDate,
          isPregnant: validIsPregnant,
          familyMember: validFamilyMember,
        ),
        act: (cubit) => cubit.updateProfile(),
        verify: (_) {
          verify(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                firstName: validFirstNameString,
                lastName: validLastNameString,
                email: validEmailString,
                dateOfBirth: DateTime.parse(validDateString),
                isPregnant: false,
              ),
              validFamilyMemberString,
            ),
          ).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when updateProfile succeeds',
        build: () => ProfileCubit(authRepository),
        setUp: () {
          when(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                email: validEmailString,
              ),
              '',
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => ProfileState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (cubit) => cubit.updateProfile(),
        expect: () => <ProfileState>[
          ProfileState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          ProfileState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
          )
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [submissionInProgress, submissionFailure] '
        'when updateProfile fails',
        setUp: () {
          when(
            () => authRepository.updateUser(
              User(
                externalId: constants.testUUID,
                email: validEmailString,
              ),
              '',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => ProfileCubit(authRepository),
        seed: () => ProfileState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (cubit) => cubit.updateProfile(),
        expect: () => <ProfileState>[
          ProfileState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          ProfileState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
          )
        ],
      );
    });
  });
}
