import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/profile/profile.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
}

class MockEmail extends Mock implements Email {}

class MockDate extends Mock implements Date {}

void main() {
  late AuthRepository authRepository;
  late User user;

  const firstNameInputKey = Key('profileForm_firstNameInput_textField');
  const lastNameInputKey = Key('profileForm_lastNameInput_textField');
  const emailInputKey = Key('profileForm_emailInput_textField');
  const dateOfBirthInputKey = Key('profileForm_dateofbirthInput_textField');
  const isPregnantInputKey = Key('profileForm_isPregnantInput_dropdownField');
  const familyMemberKey = Key('profileForm_familyMemberInput_textField');
  const updateKey = Key('profileForm_update_raisedButton');

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
  });

  group('ProfileForm', () {
    late ProfileCubit profileCubit;

    setUp(() {
      profileCubit = MockProfileCubit();
      when(() => profileCubit.state).thenReturn(ProfileState());
      when(() => profileCubit.updateProfile()).thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('firstNameChanged when firstName changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(firstNameInputKey),
          constants.testFirstName,
        );
        verify(() => profileCubit.firstNameChanged(constants.testFirstName))
            .called(1);
      });

      testWidgets('lastNameChanged when lastName changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(lastNameInputKey),
          constants.testLastName,
        );
        verify(() => profileCubit.lastNameChanged(constants.testLastName))
            .called(1);
      });

      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), constants.testEmail);
        verify(() => profileCubit.emailChanged(constants.testEmail)).called(1);
      });

      testWidgets('dateOfBirthChanged when date of birth changes',
          (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(dateOfBirthInputKey),
          constants.testDateOfBirth,
        );
        verify(() => profileCubit.dateOfBirthChanged(constants.testDateOfBirth))
            .called(1);
      });

      testWidgets('isPregnantChanged when pregnant status changes',
          (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(isPregnantInputKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes').last);
        await tester.pumpAndSettle();
        verify(() => profileCubit.isPregnantChanged('Yes')).called(1);
      });

      testWidgets('familyMemberChanged when member changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(familyMemberKey),
          constants.testEmail,
        );
        verify(() => profileCubit.familyMemberChanged(constants.testEmail))
            .called(1);
      });

      testWidgets('updateProfile when update button is pressed',
          (tester) async {
        when(() => profileCubit.state).thenReturn(
          ProfileState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(updateKey));
        verify(() => profileCubit.updateProfile()).called(1);
      });
    });

    group('renders', () {
      testWidgets('Failure SnackBar when update fails', (tester) async {
        whenListen(
          profileCubit,
          Stream.fromIterable(<ProfileState>[
            ProfileState(status: FormzStatus.submissionInProgress),
            ProfileState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
          find.text('Something went wrong, please try again.'),
          findsOneWidget,
        );
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => email.value).thenReturn('invalid');
        when(() => profileCubit.state).thenReturn(ProfileState(email: email));
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('invalid email'), findsOneWidget);
      });

      testWidgets('invalid date error text when date of birth is invalid',
          (tester) async {
        final date = MockDate();
        when(() => date.invalid).thenReturn(true);
        when(() => date.value).thenReturn('invalid');
        when(() => profileCubit.state)
            .thenReturn(ProfileState(dateOfBirth: date));
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('invalid date'), findsOneWidget);
      });

      testWidgets(
          'invalid familyMember error text when familyMember is invalid',
          (tester) async {
        final familyMember = MockEmail();
        when(() => familyMember.invalid).thenReturn(true);
        when(() => familyMember.value).thenReturn('invalid');
        when(() => profileCubit.state)
            .thenReturn(ProfileState(familyMember: familyMember));
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('invalid email'), findsOneWidget);
      });

      testWidgets('disabled update button when status is not validated',
          (tester) async {
        when(() => profileCubit.state).thenReturn(
          ProfileState(status: FormzStatus.invalid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        final updateButton =
            tester.widget<ElevatedButton>(find.byKey(updateKey));
        expect(updateButton.enabled, isFalse);
      });

      testWidgets('enabled update button when status is validated',
          (tester) async {
        when(() => profileCubit.state).thenReturn(
          ProfileState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: profileCubit,
                  child: const ProfileForm(),
                ),
              ),
            ),
          ),
        );
        final updateButton =
            tester.widget<ElevatedButton>(find.byKey(updateKey));
        expect(updateButton.enabled, isTrue);
      });
    });
  });
}
