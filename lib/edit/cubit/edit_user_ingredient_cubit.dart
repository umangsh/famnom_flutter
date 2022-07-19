part of 'edit_cubit.dart';

class EditUserIngredientCubit extends Cubit<EditUserIngredientState> {
  EditUserIngredientCubit(this._appRepository, this._searchRepository)
      : super(const EditUserIngredientState());

  final AppRepository _appRepository;
  final SearchRepository _searchRepository;

  Future<void> fetchUserIngredient({String? externalId}) async {
    emit(state.copyWith(status: EditUserIngredientStatus.requestSubmitted));

    final form = FoodForm()
      ..nutrients = {}
      ..portions = [];

    var nutritionServing = '${constants.DEFAULT_PORTION_SIZE}'
        '${constants.DEFAULT_PORTION_SIZE_UNIT}';

    try {
      final appConstants = await _appRepository.getAppConstants();
      final userIngredient = externalId != null
          ? await _appRepository.getMutableUserIngredient(
              externalId: externalId,
            )
          : null;

      if (userIngredient != null) {
        nutritionServing =
            '${truncateDecimal(userIngredient.nutrients.servingSize)}'
            '${userIngredient.nutrients.servingSizeUnit}';

        form
          ..userIngredient = userIngredient
          ..externalId = externalId
          ..name = userIngredient.name
          ..brandName = userIngredient.brand?.brandName
          ..subbrandName = userIngredient.brand?.subBrandName
          ..brandOwner = userIngredient.brand?.brandOwner
          ..gtinUpc = userIngredient.brand?.gtinUpc
          ..categoryId = appConstants.categories?.firstWhereOrNull(
            (element) => element['name'] == userIngredient.category,
          )?['id'];

        for (final entry in userIngredient.nutrients.values.entries) {
          form.nutrients?[entry.key] = truncateDecimal(entry.value.amount, 3);
        }

        for (final portion in userIngredient.portions ?? <UserFoodPortion>[]) {
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
          status: EditUserIngredientStatus.requestSuccess,
          userIngredient: userIngredient,
          appConstants: appConstants,
          form: form,
          nutritionServing: nutritionServing,
        ),
      );
    } on GetUserIngredientFailure catch (e) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> saveUserIngredient({String? externalId}) async {
    emit(state.copyWith(status: EditUserIngredientStatus.saveRequestSubmitted));

    if (state.form?.name == null) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.saveRequestFailure,
          errorMessage: 'Name missing.',
        ),
      );
      return;
    }

    if (state.form?.nutrients?[constants.ENERGY_NUTRIENT_ID] == null) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.saveRequestFailure,
          errorMessage: 'Calories (kcal) missing.',
        ),
      );
      return;
    }

    try {
      final redirectExternalId = await _appRepository.saveUserIngredient(
        values: state.form?.convertToMap() ?? <String, dynamic>{},
      );
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.saveRequestSuccess,
          redirectExternalId: redirectExternalId,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.saveRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> scanInit() async {
    emit(state.copyWith(status: EditUserIngredientStatus.barcodeRequest));
  }

  Future<void> scanBarcode({required String barcode}) async {
    state.form?.gtinUpc = barcode;
    try {
      final searchResults =
          await _searchRepository.searchWithQuery(query: barcode);

      searchResults.isEmpty
          ? emit(
              state.copyWith(
                status: EditUserIngredientStatus.barcodeNotFoundOrFailed,
              ),
            )
          : emit(
              state.copyWith(
                status: EditUserIngredientStatus.barcodeFound,
                redirectExternalId: searchResults[0].externalId,
              ),
            );
    } catch (_) {
      emit(
        state.copyWith(
          status: EditUserIngredientStatus.barcodeNotFoundOrFailed,
        ),
      );
    }
  }

  Future<void> scanClose() async {
    emit(state.copyWith(status: EditUserIngredientStatus.barcodeCancelled));
  }

  Future<void> servingChanged() async {
    // Only update the serving string when new foods are created.
    if (state.userIngredient != null) {
      return;
    }

    final servingSize = state.form?.portions?.at(0)?.servingSize ??
        constants.DEFAULT_PORTION_SIZE;
    final servingSizeUnit = state.form?.portions?.at(0)?.servingSizeUnit ??
        constants.DEFAULT_PORTION_SIZE_UNIT;
    final nutritionServing = '$servingSize$servingSizeUnit';

    if (state.nutritionServing != nutritionServing) {
      emit(
        state.copyWith(
          nutritionServing: '$servingSize$servingSizeUnit',
        ),
      );
    }
  }
}
