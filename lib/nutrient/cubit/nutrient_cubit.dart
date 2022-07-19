import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nutrient_state.dart';

class NutrientCubit extends Cubit<NutrientState> {
  NutrientCubit(this._appRepository) : super(const NutrientState());

  final AppRepository _appRepository;
  static const chartDays = 5;

  Future<void> fetchData({required int nutrientId}) async {
    emit(state.copyWith(status: NutrientStatus.requestSubmitted));
    try {
      final nutrientPage = await _appRepository.getNutrientPage(
        nutrientId: nutrientId,
        // ignore: avoid_redundant_argument_values
        chartDays: chartDays,
      );
      emit(
        state.copyWith(
          status: NutrientStatus.requestSuccess,
          nutrientPage: nutrientPage,
        ),
      );
    } on GetNutrientPageFailure catch (e) {
      emit(
        state.copyWith(
          status: NutrientStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NutrientStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }
}
