// ignore_for_file: prefer_const_constructors
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/sign_up/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>(
          create: (_) => MockAuthRepository(),
          child: MaterialApp(home: SignUpPage()),
        ),
      );
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });
}
