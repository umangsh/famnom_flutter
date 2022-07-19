// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_member_ingredient_display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMemberIngredientDisplay _$UserMemberIngredientDisplayFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate(
      'UserMemberIngredientDisplay',
      json,
      ($checkedConvert) {
        final val = UserMemberIngredientDisplay(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          ingredient: $checkedConvert(
            'ingredient',
            (v) => UserIngredientDisplay.fromJson(v! as Map<String, dynamic>),
          ),
          portion: $checkedConvert(
            'portion',
            (v) =>
                v == null ? null : Portion.fromJson(v as Map<String, dynamic>),
          ),
          ingredientPortionExternalId: $checkedConvert(
            'ingredient_portion_external_id',
            (v) => v as String?,
          ),
          meal: $checkedConvert(
            'meal',
            (v) => v == null
                ? null
                : UserMealDisplay.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'ingredientPortionExternalId': 'ingredient_portion_external_id'
      },
    );

Map<String, dynamic> _$UserMemberIngredientDisplayToJson(
  UserMemberIngredientDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'ingredient': instance.ingredient,
      'portion': instance.portion,
      'ingredient_portion_external_id': instance.ingredientPortionExternalId,
      'meal': instance.meal,
    };
