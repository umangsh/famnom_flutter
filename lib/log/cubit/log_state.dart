part of 'log_cubit.dart';

class LogState extends Equatable {
  LogState({
    this.mealType = const Dropdown.pure(),
    Date? mealDate,
    this.status = FormzStatus.pure,
    this.errorMessage,
  }) : mealDate = mealDate ?? Date.pure();

  final Dropdown mealType;
  final Date mealDate;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [mealType, mealDate, status];

  LogState copyWith({
    Dropdown? mealType,
    Date? mealDate,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LogState(
      mealType: mealType ?? this.mealType,
      mealDate: mealDate ?? this.mealDate,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
