// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_food_portion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFoodPortion _$UserFoodPortionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserFoodPortion',
      json,
      ($checkedConvert) {
        final val = UserFoodPortion(
          id: $checkedConvert('id', (v) => v! as int),
          externalId: $checkedConvert('external_id', (v) => v! as String),
          servingsPerContainer: $checkedConvert(
            'servings_per_container',
            (v) => (v as num?)?.toDouble(),
          ),
          householdQuantity:
              $checkedConvert('household_quantity', (v) => v as String?),
          householdUnit: $checkedConvert('household_unit', (v) => v as String?),
          servingSize:
              $checkedConvert('serving_size', (v) => (v! as num).toDouble()),
          servingSizeUnit:
              $checkedConvert('serving_size_unit', (v) => v! as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'servingsPerContainer': 'servings_per_container',
        'householdQuantity': 'household_quantity',
        'householdUnit': 'household_unit',
        'servingSize': 'serving_size',
        'servingSizeUnit': 'serving_size_unit'
      },
    );

Map<String, dynamic> _$UserFoodPortionToJson(UserFoodPortion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'external_id': instance.externalId,
      'servings_per_container': instance.servingsPerContainer,
      'household_quantity': instance.householdQuantity,
      'household_unit': instance.householdUnit,
      'serving_size': instance.servingSize,
      'serving_size_unit': instance.servingSizeUnit,
    };
