part of 'nutrient_cubit.dart';

enum NutrientStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
}

class NutrientState extends Equatable {
  const NutrientState({
    this.status = NutrientStatus.init,
    this.nutrientPage,
    this.errorMessage,
  });

  final NutrientStatus status;
  final NutrientPage? nutrientPage;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, nutrientPage];

  NutrientState copyWith({
    NutrientStatus? status,
    NutrientPage? nutrientPage,
    String? errorMessage,
  }) {
    return NutrientState(
      status: status ?? this.status,
      nutrientPage: nutrientPage ?? this.nutrientPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
