// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/app/app.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      when(() => authRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
      when(
        () => authRepository.currentUser,
      ).thenReturn(User.empty);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(authRepository: authRepository).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
        },
        build: () => AppBloc(
          authRepository: authRepository,
        ),
        seed: AppState.unauthenticated,
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        setUp: () {
          when(() => authRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
        },
        build: () => AppBloc(
          authRepository: authRepository,
        ),
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        setUp: () {
          when(
            () => authRepository.logout(),
          ).thenAnswer((_) async {});
        },
        build: () => AppBloc(
          authRepository: authRepository,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authRepository.logout()).called(1);
        },
      );
    });
  });
}
