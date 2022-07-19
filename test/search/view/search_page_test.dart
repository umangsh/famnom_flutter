import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:search_repository/search_repository.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchRepository searchRepository;

  setUp(() {
    searchRepository = MockSearchRepository();
  });

  group('SearchPage', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<SearchRepository>(
          create: (_) => searchRepository,
          child: const MaterialApp(home: SearchPage()),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
