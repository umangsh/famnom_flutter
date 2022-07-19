import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/app/app.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/login/login.dart';
import 'package:search_repository/search_repository.dart';

class MockUser extends Mock implements User {}

class MockAppRepository extends Mock implements AppRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late AppRepository appRepository;
  late AuthRepository authRepository;
  late SearchRepository searchRepository;
  late User user;
  late AppBloc appBloc;

  setUp(() {
    appRepository = MockAppRepository();
    authRepository = MockAuthRepository();
    searchRepository = MockSearchRepository();
    user = MockUser();
    when(() => authRepository.user).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => authRepository.currentUser).thenReturn(user);
    when(() => user.isNotEmpty).thenReturn(true);
    when(() => user.isEmpty).thenReturn(false);
    when(() => user.email).thenReturn(constants.testEmail);
    when(() => user.displayName).thenReturn(constants.testEmail);
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          appRepository: appRepository,
          authRepository: authRepository,
          searchRepository: searchRepository,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    setUp(() {
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      when(() => appRepository.getTracker(any()))
          .thenAnswer((_) async => Tracker.empty);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => {});
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authRepository,
          child: RepositoryProvider.value(
            value: appRepository,
            child: MaterialApp(
              home: BlocProvider.value(value: appBloc, child: const AppView()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
