import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/kitchen/kitchen.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;

  group('KitchenPage', () {
    setUp(() {
      appRepository = MockAppRepository();
    });

    group('renders', () {
      testWidgets('kitchen', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: PageView(
                  children: const [
                    KitchenPage(),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.byType(TabBarView), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Foods'), findsOneWidget);
        expect(find.text('Recipes'), findsOneWidget);
        expect(find.text('Meals'), findsOneWidget);
      });
    });
  });
}
