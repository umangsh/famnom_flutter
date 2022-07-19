import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:code_scan/code_scan.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockBrowseMyFoodsCubit extends MockCubit<BrowseState>
    implements BrowseMyFoodsCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userIngredient = UserIngredientDisplay(
    externalId: constants.testUUID,
    name: constants.testFoodName,
    portions: [
      Portion(
        externalId: constants.testPortionExternalId,
        name: constants.testPortionName,
        servingSize: constants.testPortionSize,
        servingSizeUnit: constants.testPortionSizeUnit,
      ),
    ],
    nutrients: Nutrients(
      servingSize: constants.testNutrientServingSize,
      servingSizeUnit: constants.testNutrientServingSizeUnit,
      values: {
        constants.testNutrientId: Nutrient(
          id: constants.testNutrientId,
          name: constants.testNutrientName,
          amount: constants.testNutrientAmount,
          unit: constants.testNutrientUnit,
        )
      },
    ),
  );

  late AppRepository appRepository;
  late BrowseMyFoodsCubit browseCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(() => appRepository.myFoodsWithQuery(query: any(named: 'query')))
        .thenAnswer((_) async => [userIngredient]);
    when(() => appRepository.myFoodsWithURI())
        .thenAnswer((_) async => [userIngredient]);

    browseCubit = MockBrowseMyFoodsCubit();
    when(() => browseCubit.getResultsWithQuery(any()))
        .thenAnswer((_) async => () {});
  });

  group('BrowseMyFoodsView', () {
    testWidgets('renders BrowseMyFoodsCubit init state', (tester) async {
      when(() => browseCubit.state).thenReturn(const BrowseState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyFoodsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.view_week_rounded),
        findsOneWidget,
      );
    });

    testWidgets('renders scanner widget', (tester) async {
      when(() => browseCubit.state)
          .thenReturn(const BrowseState(status: BrowseStatus.barcodeRequest));
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyFoodsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CodeScanner), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => browseCubit.state).thenReturn(
        const BrowseState(
          status: BrowseStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyFoodsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('user ingredient results present', (tester) async {
      when(() => browseCubit.state).thenReturn(
        const BrowseState(
          status: BrowseStatus.requestFinishedWithResults,
          ingredientResults: [userIngredient],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyFoodsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userIngredient.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('user ingredient results more present', (tester) async {
      when(() => browseCubit.state).thenReturn(
        const BrowseState(
          status: BrowseStatus.requestMoreFinishedWithResults,
          ingredientResults: [userIngredient],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyFoodsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userIngredient.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
