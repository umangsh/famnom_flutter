import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;

  setUp(() {
    appRepository = MockAppRepository();
  });

  group('MealplanPage', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AppRepository>(
          create: (_) => appRepository,
          child: const MaterialApp(
            home: MealplanPage(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
