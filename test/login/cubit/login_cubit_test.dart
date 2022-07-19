// ignore_for_file: prefer_const_constructors
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/login/login.dart';

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

  group('LoginCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      when(
        () => authRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(authRepository).state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authRepository),
        seed: () => LoginState(password: validPassword),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authRepository),
        seed: () => LoginState(email: validEmail),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginCubit(authRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        verify: (_) {
          verify(
            () => authRepository.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginCubit(authRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
          )
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails',
        setUp: () {
          when(
            () => authRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
          )
        ],
      );
    });
  });
}
