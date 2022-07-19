import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/goals/goals.dart';

class MockAppRepository extends Mock implements AppRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AppRepository appRepository;
  late AuthRepository authRepository;

  setUp(() {
    appRepository = MockAppRepository();
    authRepository = MockAuthRepository();
  });

  group('GoalsPage', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AppRepository>(
          create: (_) => appRepository,
          child: RepositoryProvider<AuthRepository>(
            create: (_) => authRepository,
            child: const MaterialApp(
              home: GoalsPage(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
