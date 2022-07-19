// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'mealplan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealplanItem _$MealplanItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MealplanItem',
      json,
      ($checkedConvert) {
        final val = MealplanItem(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
          quantity: $checkedConvert('quantity', (v) => (v! as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'externalId': 'external_id'},
    );

Map<String, dynamic> _$MealplanItemToJson(MealplanItem instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'quantity': instance.quantity,
    };

Mealplan _$MealplanFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Mealplan',
      json,
      ($checkedConvert) {
        final val = Mealplan(
          infeasible: $checkedConvert('infeasible', (v) => v! as bool),
          results: $checkedConvert(
            'results',
            (v) => (v! as List<dynamic>)
                .map((e) => MealplanItem.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$MealplanToJson(Mealplan instance) => <String, dynamic>{
      'infeasible': instance.infeasible,
      'results': instance.results,
    };
