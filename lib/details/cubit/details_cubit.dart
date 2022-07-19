import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_state.dart';
part 'details_db_food_cubit.dart';
part 'details_user_ingredient_cubit.dart';
part 'details_user_meal_cubit.dart';
part 'details_user_recipe_cubit.dart';

class _DetailsCubit extends Cubit<DetailsState> {
  _DetailsCubit() : super(const DetailsState());

  Future<void> fetchData({
    required String externalId,
    String? membershipExternalId,
  }) async {}

  Future<void> loadPageData({
    required String externalId,
    String? membershipExternalId,
  }) async {
    emit(state.copyWith(status: DetailsStatus.requestSubmitted));
    try {
      await fetchData(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
      );
    } on GetConfigNutritionFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } on GetNutritionPreferencesFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> selectPortion({required Portion portion}) async {
    emit(
      state.copyWith(
        status: DetailsStatus.portionSelected,
        selectedPortion: portion,
      ),
    );
  }

  Future<void> setQuantity({required double quantity}) async {
    emit(
      state.copyWith(
        status: DetailsStatus.portionSelected,
        quantity: quantity,
      ),
    );
  }

  Future<void> cancelDelete() async {
    emit(state.copyWith(status: DetailsStatus.deleteRequestCancelled));
  }
}
