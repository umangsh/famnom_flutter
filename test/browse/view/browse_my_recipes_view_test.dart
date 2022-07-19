import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockBrowseMyRecipesCubit extends MockCubit<BrowseState>
    implements BrowseMyRecipesCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userRecipe = UserRecipeDisplay(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
  );

  late AppRepository appRepository;
  late BrowseMyRecipesCubit browseCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(() => appRepository.myRecipesWithQuery(query: any(named: 'query')))
        .thenAnswer((_) async => [userRecipe]);
    when(() => appRepository.myRecipesWithURI())
        .thenAnswer((_) async => [userRecipe]);

    browseCubit = MockBrowseMyRecipesCubit();
    when(() => browseCubit.getResultsWithQuery(any()))
        .thenAnswer((_) async => () {});
  });

  group('BrowseMyRecipesView', () {
    testWidgets('renders BrowseMyRecipesCubit init state', (tester) async {
      when(() => browseCubit.state).thenReturn(const BrowseState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyRecipesView(),
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
                body: BrowseMyRecipesView(),
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
          recipeResults: [userRecipe],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyRecipesView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userRecipe.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('user ingredient results more present', (tester) async {
      when(() => browseCubit.state).thenReturn(
        const BrowseState(
          status: BrowseStatus.requestMoreFinishedWithResults,
          recipeResults: [userRecipe],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: browseCubit,
              child: const Scaffold(
                body: BrowseMyRecipesView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(userRecipe.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
