part of 'mealplan_cubit.dart';

class MealplanFormTwo extends Equatable {
  const MealplanFormTwo({
    required this.thresholdTypes,
    required this.thresholdValues,
  });

  final Map<String, String?> thresholdTypes;
  final Map<String, double?> thresholdValues;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    for (final externalId in thresholdTypes.keys) {
      form[getObjectFieldName(externalId)] = thresholdValues[externalId];
      form[getObjectThresholdFieldName(externalId)] =
          thresholdTypes[externalId];
    }

    return form;
  }

  @override
  List<Object?> get props => [thresholdTypes, thresholdValues];
}
