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
          displayIngredient: $checkedConvert(
            'display_ingredient',
            (v) => UserIngredientDisplay.fromJson(v! as Map<String, dynamic>),
          ),
          displayPortion: $checkedConvert(
            'display_portion',
            (v) =>
                v == null ? null : Portion.fromJson(v as Map<String, dynamic>),
          ),
          ingredientPortionExternalId: $checkedConvert(
            'ingredient_portion_external_id',
            (v) => v as String?,
          ),
          displayMeal: $checkedConvert(
            'display_meal',
            (v) => v == null
                ? null
                : UserMealDisplay.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'displayIngredient': 'display_ingredient',
        'displayPortion': 'display_portion',
        'ingredientPortionExternalId': 'ingredient_portion_external_id',
        'displayMeal': 'display_meal'
      },
    );

Map<String, dynamic> _$UserMemberIngredientDisplayToJson(
  UserMemberIngredientDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'display_ingredient': instance.displayIngredient,
      'display_portion': instance.displayPortion,
      'ingredient_portion_external_id': instance.ingredientPortionExternalId,
      'display_meal': instance.displayMeal,
    };
