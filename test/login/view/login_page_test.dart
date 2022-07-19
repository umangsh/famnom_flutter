import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/login/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginPage', () {
    test('has a page', () {
      expect(LoginPage.page(), isA<MaterialPage>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>(
          create: (_) => MockAuthRepository(),
          child: const MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
