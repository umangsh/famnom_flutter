// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_recipe_mutable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecipeMutable _$UserRecipeMutableFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserRecipeMutable',
      json,
      ($checkedConvert) {
        final val = UserRecipeMutable(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
          recipeDate: $checkedConvert('recipe_date', (v) => v! as String),
          portions: $checkedConvert(
            'portions',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserFoodPortion.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
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
        'recipeDate': 'recipe_date',
        'memberIngredients': 'member_ingredients',
        'memberRecipes': 'member_recipes'
      },
    );

Map<String, dynamic> _$UserRecipeMutableToJson(UserRecipeMutable instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'recipe_date': instance.recipeDate,
      'portions': instance.portions,
      'member_ingredients': instance.memberIngredients,
      'member_recipes': instance.memberRecipes,
    };
