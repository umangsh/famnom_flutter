import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';

class MockNutrientCubit extends MockCubit<NutrientState>
    implements NutrientCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const nutrientPage = NutrientPage(
    id: constants.testNutrientId,
    name: constants.testNutrientName,
    amountPerDay: {
      '2022-04-03': 4,
    },
  );

  late AppRepository appRepository;
  late NutrientCubit nutrientCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(
      () => appRepository.getNutrientPage(
        nutrientId: constants.testNutrientId,
      ),
    ).thenAnswer((_) async => nutrientPage);

    nutrientCubit = MockNutrientCubit();
    when(() => nutrientCubit.fetchData(nutrientId: any(named: 'nutrientId')))
        .thenAnswer((_) async => nutrientPage);
  });

  group('NutrientView', () {
    testWidgets('renders NutrientCubit init state', (tester) async {
      when(() => nutrientCubit.state).thenReturn(const NutrientState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: nutrientCubit,
              child: const NutrientView(nutrientId: constants.testNutrientId),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => nutrientCubit.state).thenReturn(
        const NutrientState(
          status: NutrientStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: nutrientCubit,
              child: const NutrientView(nutrientId: constants.testNutrientId),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('nutrient page present', (tester) async {
      when(() => nutrientCubit.state).thenReturn(
        const NutrientState(
          status: NutrientStatus.requestSuccess,
          nutrientPage: nutrientPage,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: nutrientCubit,
              child: const NutrientView(nutrientId: constants.testNutrientId),
            ),
          ),
        ),
      );
      expect(find.text(nutrientPage.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(charts.OrdinalComboChart), findsOneWidget);
      expect(find.text('Recent Foods'), findsNothing);
    });
  });
}
