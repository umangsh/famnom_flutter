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

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppRepository extends Mock implements AppRepository {}

class MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late AuthRepository authRepository;
  late AppRepository appRepository;
  late User user;

  group('HomePage', () {
    setUp(() {
      appBloc = MockAppBloc();
      authRepository = MockAuthRepository();
      appRepository = MockAppRepository();
      user = MockUser();
      when(() => authRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn(constants.testEmail);
      when(() => user.displayName).thenReturn(constants.testEmail);
    });

    group('renders', () {
      testWidgets('home', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: RepositoryProvider<AuthRepository>(
              create: (_) => authRepository,
              child: RepositoryProvider<AppRepository>(
                create: (_) => appRepository,
                child: const MaterialApp(
                  home: HomePage(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('Home'), findsNWidgets(1));
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });
    });
  });
}
