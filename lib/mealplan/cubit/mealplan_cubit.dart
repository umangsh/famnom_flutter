import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:utils/utils.dart';

part 'mealplan_state.dart';
part 'mealplan_form_one.dart';
part 'mealplan_form_two.dart';
part 'mealplan_form_three.dart';

class MealplanCubit extends Cubit<MealplanState> {
  MealplanCubit(this._appRepository) : super(const MealplanState());

  final AppRepository _appRepository;
  final pageSize = 400;

  Future<void> refreshPage() async {
    emit(state.copyWith(status: MealplanStatus.init));
  }

  Future<void> loadItems() async {
    emit(state.copyWith(status: MealplanStatus.loadRequestSubmitted));
    try {
      final allFoods =
          await _appRepository.myFoodsWithQuery(pageSize: pageSize);
      final allRecipes =
          await _appRepository.myRecipesWithQuery(pageSize: pageSize);

      final availableFoods = await _appRepository.myFoodsWithQuery(
        flagSet: constants.FLAG_IS_AVAILABLE,
      );
      final availableRecipes = await _appRepository.myRecipesWithQuery(
        flagSet: constants.FLAG_IS_AVAILABLE,
      );

      final mustHaveFoods = await _appRepository.myFoodsWithQuery(
        flagSet: constants.FLAG_IS_NOT_ZEROABLE,
      );
      final mustHaveRecipes = await _appRepository.myRecipesWithQuery(
        flagSet: constants.FLAG_IS_NOT_ZEROABLE,
      );

      final dontHaveFoods = await _appRepository.myFoodsWithQuery(
        flagSet: constants.FLAG_IS_NOT_ALLOWED,
      );
      final dontHaveRecipes = await _appRepository.myRecipesWithQuery(
        flagSet: constants.FLAG_IS_NOT_ALLOWED,
      );

      final dontRepeatFoods = await _appRepository.myFoodsWithQuery(
        flagSet: constants.FLAG_IS_NOT_REPEATABLE,
      );
      final dontRepeatRecipes = await _appRepository.myRecipesWithQuery(
        flagSet: constants.FLAG_IS_NOT_REPEATABLE,
      );

      final form = MealplanFormOne(
        allFoods: allFoods,
        allRecipes: allRecipes,
        availableFoods: availableFoods,
        availableRecipes: availableRecipes,
        mustHaveFoods: mustHaveFoods,
        mustHaveRecipes: mustHaveRecipes,
        dontHaveFoods: dontHaveFoods,
        dontHaveRecipes: dontHaveRecipes,
        dontRepeatFoods: dontRepeatFoods,
        dontRepeatRecipes: dontRepeatRecipes,
      );

      emit(
        state.copyWith(
          status: MealplanStatus.loadRequestSuccess,
          formOne: form,
        ),
      );
    } on MyFoodsFailure catch (e) {
      emit(
        state.copyWith(
          status: MealplanStatus.loadRequestFailure,
          errorMessage: e.message,
        ),
      );
    } on MyRecipesFailure catch (e) {
      emit(
        state.copyWith(
          status: MealplanStatus.loadRequestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.loadRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveItems() async {
    try {
      await _appRepository.saveMealplanFormOne(
        values: state.formOne?.convertToMap() ?? <String, dynamic>{},
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> loadThresholds() async {
    emit(state.copyWith(status: MealplanStatus.thresholdsRequestSubmitted));
    try {
      final preferences = await _appRepository.getMealplanFormTwo();
      final form = MealplanFormTwo(
        thresholdTypes: {
          for (final preference in preferences)
            preference.externalId: preference.thresholdType
        },
        thresholdValues: {
          for (final preference in preferences)
            preference.externalId: preference.thresholdValue
        },
      );

      emit(
        state.copyWith(
          status: MealplanStatus.thresholdsRequestSuccess,
          preferences: {
            for (final preference in preferences)
              preference.externalId: preference
          },
          formTwo: form,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.thresholdsRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveThresholds() async {
    try {
      await _appRepository.saveMealplanFormTwo(
        values: state.formTwo?.convertToMap() ?? <String, dynamic>{},
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> loadMealplan() async {
    emit(state.copyWith(status: MealplanStatus.mealplanRequestSubmitted));
    try {
      final mealplan = await _appRepository.getMealplanFormThree();
      final form = MealplanFormThree(
        // ignore: prefer_const_literals_to_create_immutables
        mealTypes: <String, String>{},
        quantities: {
          for (final result in mealplan.results)
            result.externalId: result.quantity
        },
      );

      emit(
        state.copyWith(
          status: MealplanStatus.mealplanRequestSuccess,
          mealplanInfeasible: mealplan.infeasible,
          mealplanResults: {
            for (final result in mealplan.results) result.externalId: result
          },
          formThree: form,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.mealplanRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveMealplan() async {
    try {
      await _appRepository.saveMealplanFormThree(
        values: state.formThree?.convertToMap() ?? <String, dynamic>{},
      );
      emit(state.copyWith(status: MealplanStatus.mealplanSaved));
    } catch (_) {
      emit(
        state.copyWith(
          status: MealplanStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }
}
