import 'package:bloc_test/bloc_test.dart';
import 'package:code_scan/code_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:search_repository/search_repository.dart';

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

void main() {
  late SearchCubit searchCubit;

  setUp(() {
    searchCubit = MockSearchCubit();
  });

  group('SearchView', () {
    testWidgets('renders SearchCubit init state', (tester) async {
      when(() => searchCubit.state).thenReturn(const SearchState());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('Search food database...'), findsOneWidget);
    });

    testWidgets('tapping search bar invokes SearchCubit autocomplete state',
        (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.autocomplete,
          autocompleteResults: [
            AutocompleteResult(query: 'query', timestamp: 1)
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('query'), findsOneWidget);
    });

    testWidgets('tapping barcode icon invokes SearchCubit barcodeRequest state',
        (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(status: SearchStatus.barcodeRequest),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.textContaining('Scanning'), findsOneWidget);
      expect(find.byType(CodeScanner), findsOneWidget);
    });

    testWidgets('tapping autocomplete item invokes search query',
        (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestSubmitted,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('search request failure', (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('search results empty', (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestFinishedEmptyResults,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('Add Food'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('search results present', (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestFinishedWithResults,
          searchResults: [
            SearchResult(externalId: 'externalId', name: 'name', url: 'url')
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('name'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('search results more present', (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestMoreFinishedWithResults,
          searchResults: [
            SearchResult(externalId: 'externalId', name: 'name', url: 'url')
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('name'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('search results more empty', (tester) async {
      when(() => searchCubit.state).thenReturn(
        const SearchState(
          status: SearchStatus.requestMoreFinishedEmptyResults,
          searchResults: [
            SearchResult(externalId: 'externalId', name: 'name', url: 'url')
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        ),
      );
      expect(find.text('name'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
