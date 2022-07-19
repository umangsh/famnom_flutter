// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_meal_mutable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMealMutable _$UserMealMutableFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserMealMutable',
      json,
      ($checkedConvert) {
        final val = UserMealMutable(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          mealType: $checkedConvert('meal_type', (v) => v! as String),
          mealDate: $checkedConvert('meal_date', (v) => v! as String),
          memberIngredients: $checkedConvert(
            'member_ingredients',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserFoodMembership.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          memberRecipes: $checkedConvert(
            'member_recipes',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserFoodMembership.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'mealType': 'meal_type',
        'mealDate': 'meal_date',
        'memberIngredients': 'member_ingredients',
        'memberRecipes': 'member_recipes'
      },
    );

Map<String, dynamic> _$UserMealMutableToJson(UserMealMutable instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'meal_type': instance.mealType,
      'meal_date': instance.mealDate,
      'member_ingredients': instance.memberIngredients,
      'member_recipes': instance.memberRecipes,
    };
