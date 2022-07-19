part of 'edit_cubit.dart';

class EditUserRecipeCubit extends Cubit<EditUserRecipeState> {
  EditUserRecipeCubit(this._appRepository) : super(const EditUserRecipeState());

  final AppRepository _appRepository;

  Future<void> fetchUserRecipe({String? externalId}) async {
    emit(state.copyWith(status: EditUserRecipeStatus.requestSubmitted));

    final form = RecipeForm()
      ..recipeDate = DateFormat(constants.DATE_FORMAT).format(DateTime.now())
      ..portions = []
      ..ingredientMembers = []
      ..recipeMembers = [];

    try {
      final appConstants = await _appRepository.getAppConstants();
      final userRecipe = externalId != null
          ? await _appRepository.getMutableUserRecipe(externalId: externalId)
          : null;

      if (userRecipe != null) {
        form
          ..userRecipe = userRecipe
          ..externalId = externalId
          ..name = userRecipe.name
          ..recipeDate = userRecipe.recipeDate;

        for (final member
            in userRecipe.memberIngredients ?? <UserFoodMembership>[]) {
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

        for (final member
            in userRecipe.memberRecipes ?? <UserFoodMembership>[]) {
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

        for (final portion in userRecipe.portions ?? <UserFoodPortion>[]) {
          form.portions?.add(
            FoodPortionForm(
              id: portion.id,
              servingsPerContainer:
                  truncateDecimal(portion.servingsPerContainer, 3),
              householdQuantity: portion.householdQuantity,
              householdUnit: portion.householdUnit,
              servingSize: truncateDecimal(portion.servingSize, 3),
              servingSizeUnit: portion.servingSizeUnit,
            ),
          );
        }
      }

      emit(
        state.copyWith(
          status: EditUserRecipeStatus.requestSuccess,
          userRecipe: userRecipe,
          appConstants: appConstants,
          form: form,
        ),
      );
    } on GetUserRecipeFailure catch (e) {
      emit(
        state.copyWith(
          status: EditUserRecipeStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserRecipeStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveUserRecipe({String? externalId}) async {
    emit(state.copyWith(status: EditUserRecipeStatus.saveRequestSubmitted));

    if (state.form?.name == null) {
      emit(
        state.copyWith(
          status: EditUserRecipeStatus.saveRequestFailure,
          errorMessage: 'Name missing.',
        ),
      );
      return;
    }

    try {
      final redirectExternalId = await _appRepository.saveUserRecipe(
        values: state.form?.convertToMap() ?? <String, dynamic>{},
      );
      emit(
        state.copyWith(
          status: EditUserRecipeStatus.saveRequestSuccess,
          redirectExternalId: redirectExternalId,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserRecipeStatus.saveRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> redrawPage() async {
    emit(state.copyWith(status: EditUserRecipeStatus.redrawRequested));
    emit(state.copyWith(status: EditUserRecipeStatus.redrawDone));
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
