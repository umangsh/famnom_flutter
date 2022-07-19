import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockBrowseMyMealsCubit extends MockCubit<BrowseState>
    implements BrowseMyMealsCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userMeal = UserMealDisplay(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
  );

  late AppRepository appRepository;
  late BrowseMyMealsCubit browseCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(() => appRepository.myMeals()).thenAnswer((_) async => [userMeal]);
    when(() => appRepository.myMealsWithURI())
        .thenAnswer((_) async => [userMeal]);

    browseCubit = MockBrowseMyMealsCubit();
    when(() => browseCubit.getResults()).thenAnswer((_) async => () {});
  });

  group('BrowseMyMealsView', () {
    testWidgets('renders BrowseMyMealsCubit init state', (tester) async {
      when(() => browseCubit.state).thenReturn(const BrowseState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyMealsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.view_week_rounded),
        findsNothing,
      );
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
                body: BrowseMyMealsView(),
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
          mealResults: [userMeal],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyMealsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userMeal.mealType), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('user ingredient results more present', (tester) async {
      when(() => browseCubit.state).thenReturn(
        const BrowseState(
          status: BrowseStatus.requestMoreFinishedWithResults,
          mealResults: [userMeal],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyMealsView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userMeal.mealType), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
