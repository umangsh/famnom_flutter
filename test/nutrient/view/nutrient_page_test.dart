import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;

  setUp(() {
    appRepository = MockAppRepository();
  });

  group('MyNutrientPage', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AppRepository>(
          create: (_) => appRepository,
          child: const MaterialApp(
            home: MyNutrientPage(nutrientId: constants.testNutrientId),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
