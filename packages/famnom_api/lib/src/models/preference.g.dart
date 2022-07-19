// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preference _$PreferenceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Preference',
      json,
      ($checkedConvert) {
        final val = Preference(
          foodNutrientId: $checkedConvert('food_nutrient_id', (v) => v as int?),
          thresholds: $checkedConvert(
            'thresholds',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) => (e as Map<String, dynamic>).map(
                    (k, e) => MapEntry(k, (e as num?)?.toDouble()),
                  ),
                )
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'foodNutrientId': 'food_nutrient_id'},
    );

Map<String, dynamic> _$PreferenceToJson(Preference instance) =>
    <String, dynamic>{
      'food_nutrient_id': instance.foodNutrientId,
      'thresholds': instance.thresholds,
    };
