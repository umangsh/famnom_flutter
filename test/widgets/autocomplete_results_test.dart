import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:search_repository/search_repository.dart';

void main() {
  final autoCompleteResults = [
    const AutocompleteResult(query: 'query', timestamp: 1),
    const AutocompleteResult(query: 'sample', timestamp: 2),
  ];

  testWidgets('find autocomplete result text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AutocompleteResults(
            results: autoCompleteResults,
            onTap: (query) {},
          ),
        ),
      ),
    );
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('query'), findsOneWidget);
    expect(find.text('sample'), findsOneWidget);
  });
}
