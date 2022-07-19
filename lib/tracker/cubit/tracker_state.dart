part of 'tracker_cubit.dart';

enum TrackerStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
  dateChanged,
}

class TrackerState extends Equatable {
  const TrackerState({
    this.status = TrackerStatus.init,
    this.tracker,
    this.date,
    this.nutritionPreferences = const <int, Preference>{},
    this.errorMessage,
  });

  final TrackerStatus status;
  final Tracker? tracker;
  final DateTime? date;
  final Map<int, Preference>? nutritionPreferences;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, tracker, date, nutritionPreferences];

  TrackerState copyWith({
    TrackerStatus? status,
    Tracker? tracker,
    DateTime? date,
    Map<int, Preference>? nutritionPreferences,
    String? errorMessage,
  }) {
    return TrackerState(
      status: status ?? this.status,
      tracker: tracker ?? this.tracker,
      date: date ?? this.date,
      nutritionPreferences: nutritionPreferences ?? this.nutritionPreferences,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
