import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthkit/healthkit.dart';

part 'tracker_state.dart';

class TrackerCubit extends Cubit<TrackerState> {
  TrackerCubit(this._appRepository) : super(const TrackerState());

  final AppRepository _appRepository;

  Future<void> getTracker({required DateTime date}) async {
    emit(state.copyWith(status: TrackerStatus.requestSubmitted, date: date));
    try {
      final tracker = await _appRepository.getTracker(date);

      /// Sync data to Apple Health on page load if authorized.
      await writeToAppleHealth(date, tracker);
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences();

      emit(
        state.copyWith(
          status: TrackerStatus.requestSuccess,
          tracker: tracker,
          date: date,
          nutritionPreferences: nutritionPreferences,
        ),
      );
    } on GetTrackerFailure catch (e) {
      emit(
        state.copyWith(
          status: TrackerStatus.requestFailure,
          date: date,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TrackerStatus.requestFailure,
          date: date,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> dateChanged({required DateTime date}) async {
    emit(state.copyWith(status: TrackerStatus.dateChanged, date: date));
  }
}
