part of 'edit_cubit.dart';

class EditUserMealCubit extends Cubit<EditUserMealState> {
  EditUserMealCubit(this._appRepository) : super(const EditUserMealState());

  final AppRepository _appRepository;

  Future<void> fetchUserMeal({String? externalId}) async {
    emit(state.copyWith(status: EditUserMealStatus.requestSubmitted));

    final form = MealForm()
      ..mealDate = DateFormat(constants.DATE_FORMAT).format(DateTime.now())
      ..ingredientMembers = []
      ..recipeMembers = [];

    try {
      final appConstants = await _appRepository.getAppConstants();
      final userMeal = externalId != null
          ? await _appRepository.getMutableUserMeal(externalId: externalId)
          : null;

      if (userMeal != null) {
        form
          ..userMeal = userMeal
          ..externalId = externalId
          ..mealType = userMeal.mealType
          ..mealDate = userMeal.mealDate;

        for (final member
            in userMeal.memberIngredients ?? <UserFoodMembership>[]) {
          form.ingredientMembers?.add(
            FoodMemberForm(
              id: member.id,
              childExternalId: member.childExternalId,
              childName: member.childName,
              serving: member.childPortionExternalId,
              servingName: member.childPortionName,
              quantity: member.quantity?.toString(),
            ),
          );
        }

        for (final member in userMeal.memberRecipes ?? <UserFoodMembership>[]) {
          form.recipeMembers?.add(
            FoodMemberForm(
              id: member.id,
              childExternalId: member.childExternalId,
              childName: member.childName,
              serving: member.childPortionExternalId,
              servingName: member.childPortionName,
              quantity: member.quantity?.toString(),
            ),
          );
        }
      }

      emit(
        state.copyWith(
          status: EditUserMealStatus.requestSuccess,
          userMeal: userMeal,
          appConstants: appConstants,
          form: form,
        ),
      );
    } on GetUserMealFailure catch (e) {
      emit(
        state.copyWith(
          status: EditUserMealStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserMealStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveUserMeal({String? externalId}) async {
    emit(state.copyWith(status: EditUserMealStatus.saveRequestSubmitted));

    if (state.form?.mealType == null) {
      emit(
        state.copyWith(
          status: EditUserMealStatus.saveRequestFailure,
          errorMessage: 'Meal type missing.',
        ),
      );
      return;
    }

    try {
      final redirectExternalId = await _appRepository.saveUserMeal(
        values: state.form?.convertToMap() ?? <String, dynamic>{},
      );
      emit(
        state.copyWith(
          status: EditUserMealStatus.saveRequestSuccess,
          redirectExternalId: redirectExternalId,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserMealStatus.saveRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> redrawPage() async {
    emit(state.copyWith(status: EditUserMealStatus.redrawRequested));
    emit(state.copyWith(status: EditUserMealStatus.redrawDone));
  }

  Future<List<UserIngredientDisplay>> getMyFoods({String? query}) {
    return _appRepository.myFoodsWithQuery(query: query ?? '');
  }

  Future<List<UserRecipeDisplay>> getMyRecipes({String? query}) {
    return _appRepository.myRecipesWithQuery(query: query ?? '');
  }

  Future<List<Portion>> getFoodPortions({required String externalId}) async {
    final userIngredient = await _appRepository.getUserIngredient(externalId);
    return Future.value(userIngredient.portions);
  }

  Future<List<Portion>> getRecipePortions({required String externalId}) async {
    final userRecipe = await _appRepository.getUserRecipe(externalId);
    return Future.value(userRecipe.portions);
  }
}
