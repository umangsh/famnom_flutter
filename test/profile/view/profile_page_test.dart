import 'package:auth_repository/auth_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/profile/profile.dart';

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ProfilePage', () {
    late AuthRepository authRepository;
    late User user;

    setUp(() {
      authRepository = MockAuthRepository();
      user = MockUser();
      when(() => authRepository.currentUser).thenReturn(user);
      when(() => user.email).thenReturn(constants.testEmail);
    });

    test('has a page', () {
      expect(ProfilePage.page(), isA<MaterialPage>());
    });

    testWidgets('renders a ProfileForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>(
          create: (_) => authRepository,
          child: const MaterialApp(home: Scaffold(body: ProfilePage())),
        ),
      );
      expect(find.byType(ProfileForm), findsOneWidget);
    });
  });
}
