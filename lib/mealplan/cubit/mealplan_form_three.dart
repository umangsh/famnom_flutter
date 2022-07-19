part of 'mealplan_cubit.dart';

class MealplanFormThree extends Equatable {
  const MealplanFormThree({
    required this.mealTypes,
    required this.quantities,
  });

  final Map<String, String?> mealTypes;
  final Map<String, double?> quantities;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    for (final externalId in quantities.keys) {
      form[getObjectFieldName(externalId)] = quantities[externalId];
      form[getObjectMealFieldName(externalId)] = mealTypes[externalId];
    }

    return form;
  }

  @override
  List<Object?> get props => [mealTypes, quantities];
}
