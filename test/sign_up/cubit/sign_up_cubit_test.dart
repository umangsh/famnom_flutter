// ignore_for_file: prefer_const_constructors
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/sign_up/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 't0pS3cret1234';
  const validPassword = Password.dirty(validPasswordString);

  const invalidConfirmedPasswordString = 'invalid';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: invalidConfirmedPasswordString,
  );

  const validConfirmedPasswordString = 't0pS3cret1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: validConfirmedPasswordString,
  );

  group('SignUpCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      when(
        () => authRepository.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password1: any(named: 'password1'),
          password2: any(named: 'password2'),
        ),
      ).thenAnswer((_) async {});
    });

    test('initial state is SignUpState', () {
      expect(SignUpCubit(authRepository).state, SignUpState());
    });

    group('emailChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <SignUpState>[
          SignUpState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            confirmedPassword: ConfirmedPassword.dirty(
              password: invalidPasswordString,
            ),
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          email: validEmail,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when confirmedPasswordChanged is called first and then '
        'passwordChanged is called',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          email: validEmail,
        ),
        act: (cubit) => cubit
          ..confirmedPasswordChanged(validConfirmedPasswordString)
          ..passwordChanged(validPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.invalid,
          ),
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authRepository),
        act: (cubit) {
          cubit.confirmedPasswordChanged(invalidConfirmedPasswordString);
        },
        expect: () => const <SignUpState>[
          SignUpState(
            confirmedPassword: invalidConfirmedPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(email: validEmail, password: validPassword),
        act: (cubit) => cubit.confirmedPasswordChanged(
          validConfirmedPasswordString,
        ),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when passwordChanged is called first and then '
        'confirmedPasswordChanged is called',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(email: validEmail),
        act: (cubit) => cubit
          ..passwordChanged(validPasswordString)
          ..confirmedPasswordChanged(validConfirmedPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPasswordString,
            ),
            status: FormzStatus.invalid,
          ),
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('signUpFormSubmitted', () {
      blocTest<SignUpCubit, SignUpState>(
        'does nothing when status is not validated',
        build: () => SignUpCubit(authRepository),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpCubit, SignUpState>(
        'calls signUp with correct email/password/confirmedPassword',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.signUpFormSubmitted(),
        verify: (_) {
          verify(
            () => authRepository.signUpWithEmailAndPassword(
              email: validEmailString,
              password1: validPasswordString,
              password2: validConfirmedPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when signUp succeeds',
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          ),
          SignUpState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          )
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signUp fails',
        setUp: () {
          when(
            () => authRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password1: any(named: 'password1'),
              password2: any(named: 'password2'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.signUpFormSubmitted(),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          ),
          SignUpState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          )
        ],
      );
    });
  });
}
