import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

void main() {
  testWidgets('find spinner', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: EmptySpinner()),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
