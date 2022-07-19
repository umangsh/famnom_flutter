// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_meal_display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMealDisplay _$UserMealDisplayFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserMealDisplay',
      json,
      ($checkedConvert) {
        final val = UserMealDisplay(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          mealDate: $checkedConvert('meal_date', (v) => v! as String),
          mealType: $checkedConvert('meal_type', (v) => v! as String),
          nutrients: $checkedConvert(
            'display_nutrients',
            (v) => v == null
                ? null
                : Nutrients.fromJson(v as Map<String, dynamic>),
          ),
          memberIngredients: $checkedConvert(
            'member_ingredients',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserMemberIngredientDisplay.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          ),
          memberRecipes: $checkedConvert(
            'member_recipes',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserMemberRecipeDisplay.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'mealDate': 'meal_date',
        'mealType': 'meal_type',
        'nutrients': 'display_nutrients',
        'memberIngredients': 'member_ingredients',
        'memberRecipes': 'member_recipes'
      },
    );

Map<String, dynamic> _$UserMealDisplayToJson(UserMealDisplay instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'meal_date': instance.mealDate,
      'meal_type': instance.mealType,
      'display_nutrients': instance.nutrients,
      'member_ingredients': instance.memberIngredients,
      'member_recipes': instance.memberRecipes,
    };
