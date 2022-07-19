import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/log/log.dart';

class MockAppRepository extends Mock implements AppRepository {}

class MockDetailsUserRecipeCubit extends MockCubit<DetailsState>
    implements DetailsUserRecipeCubit {}

class MockLogUserRecipeCubit extends MockCubit<LogState>
    implements LogUserRecipeCubit {}

class MockDropdown extends Mock implements Dropdown {}

class MockDate extends Mock implements Date {}

void main() {
  const userRecipe = UserRecipeDisplay(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
    recipeDate: constants.testRecipeDate,
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
    memberIngredients: [
      UserMemberIngredientDisplay(
        externalId: constants.testUUID,
        ingredient: UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
    memberRecipes: [
      UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
  );

  late AppRepository appRepository;
  late LogUserRecipeCubit logCubit;
  late DetailsUserRecipeCubit detailsCubit;

  const mealTypeInputKey = Key('logForm_mealTypeInput_dropDownField');
  const mealDateInputKey = Key('logForm_mealDateInput_textField');
  const logKey = Key('logForm_log_raisedButton');

  group('LogUserRecipeForm', () {
    setUp(() {
      appRepository = MockAppRepository();

      logCubit = MockLogUserRecipeCubit();
      when(() => logCubit.state).thenReturn(
        LogState(
          mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
          mealDate: Date.pure(
            DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
          ),
        ),
      );
      when(
        () => logCubit.logUserRecipe(
          externalId: constants.testUUID,
          serving: userRecipe.defaultPortion!.externalId,
        ),
      ).thenAnswer((_) async {});

      detailsCubit = MockDetailsUserRecipeCubit();
      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          userRecipe: userRecipe,
          selectedPortion: userRecipe.defaultPortion,
        ),
      );
    });

    group('calls', () {
      testWidgets('mealTypeChanged when mealType changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(mealTypeInputKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text(constants.testMealType).last);
        await tester.pumpAndSettle();
        verify(() => logCubit.mealTypeChanged(constants.testMealType))
            .called(1);
      });

      testWidgets('mealDateChanged when mealDate changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(mealDateInputKey),
          constants.testMealDate,
        );
        verify(() => logCubit.mealDateChanged(constants.testMealDate))
            .called(1);
      });

      testWidgets('logUserRecipe when log button is pressed', (tester) async {
        when(() => logCubit.state).thenReturn(
          LogState(
            mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
            mealDate: Date.pure(
              DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
            ),
            status: FormzStatus.valid,
          ),
        );
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(logKey));
        verify(
          () => logCubit.logUserRecipe(
            externalId: constants.testUUID,
            serving: any(named: 'serving'),
          ),
        ).called(1);
      });
    });

    group('renders', () {
      testWidgets('Failure SnackBar when update fails', (tester) async {
        whenListen(
          logCubit,
          Stream.fromIterable(<LogState>[
            LogState(
              mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
              mealDate: Date.pure(
                DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
              ),
              status: FormzStatus.submissionInProgress,
            ),
            LogState(
              mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
              mealDate: Date.pure(
                DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
              ),
              status: FormzStatus.submissionFailure,
            ),
          ]),
        );
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
          find.text('Something went wrong, please try again.'),
          findsOneWidget,
        );
      });

      testWidgets('Success SnackBar when update fails', (tester) async {
        whenListen(
          logCubit,
          Stream.fromIterable(<LogState>[
            LogState(
              mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
              mealDate: Date.pure(
                DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
              ),
              status: FormzStatus.submissionInProgress,
            ),
            LogState(
              mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
              mealDate: Date.pure(
                DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
              ),
              status: FormzStatus.submissionSuccess,
            ),
          ]),
        );
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
          find.text('Recipe logged'),
          findsOneWidget,
        );
      });

      testWidgets('invalid meal date error text when meal date is invalid',
          (tester) async {
        final date = MockDate();
        when(() => date.invalid).thenReturn(true);
        when(() => date.value).thenReturn('invalid');
        when(() => logCubit.state).thenReturn(
          LogState(
            mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
            mealDate: date,
          ),
        );
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.text('invalid date'), findsOneWidget);
      });

      testWidgets('enabled log button when status is validated',
          (tester) async {
        when(() => logCubit.state).thenReturn(
          LogState(
            mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
            mealDate: Date.pure(
              DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
            ),
            status: FormzStatus.valid,
          ),
        );
        await tester.pumpWidget(
          RepositoryProvider<AppRepository>(
            create: (_) => appRepository,
            child: MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    BlocProvider.value(
                      value: detailsCubit,
                      child: BlocProvider.value(
                        value: logCubit,
                        child: const LogUserRecipeForm(
                          externalId: constants.testUUID,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        final logButton = tester.widget<ElevatedButton>(find.byKey(logKey));
        expect(logButton.enabled, isTrue);
      });
    });
  });
}
