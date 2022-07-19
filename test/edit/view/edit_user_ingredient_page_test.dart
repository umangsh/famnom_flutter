import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:search_repository/search_repository.dart';

class MockAppRepository extends Mock implements AppRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late AppRepository appRepository;
  late SearchRepository searchRepository;

  setUp(() {
    appRepository = MockAppRepository();
    searchRepository = MockSearchRepository();
  });

  group('EditUserIngredientPage for create', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AppRepository>(
          create: (_) => appRepository,
          child: RepositoryProvider<SearchRepository>(
            create: (_) => searchRepository,
            child: const MaterialApp(
              home: EditUserIngredientPage(),
            ),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });

  group('EditUserIngredientPage for edit', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AppRepository>(
          create: (_) => appRepository,
          child: RepositoryProvider<SearchRepository>(
            create: (_) => searchRepository,
            child: const MaterialApp(
              home: EditUserIngredientPage(externalId: constants.testUUID),
            ),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
