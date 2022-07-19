import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

void main() {
  testWidgets('find text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyResults(
          firstLine: "Don't see any saved items?",
          secondLine: 'Add and log your own food.',
          buttonText: 'Add Food',
          onPressed: () {},
        ),
      ),
    );
    expect(find.text("Don't see any saved items?"), findsOneWidget);
    expect(find.text('Add and log your own food.'), findsOneWidget);
    expect(find.text('Add Food'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
