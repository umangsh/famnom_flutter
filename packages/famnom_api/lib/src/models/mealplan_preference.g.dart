// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'mealplan_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealplanPreference _$MealplanPreferenceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MealplanPreference',
      json,
      ($checkedConvert) {
        final val = MealplanPreference(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
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
      fieldKeyMap: const {'externalId': 'external_id'},
    );

Map<String, dynamic> _$MealplanPreferenceToJson(MealplanPreference instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'thresholds': instance.thresholds,
    };
