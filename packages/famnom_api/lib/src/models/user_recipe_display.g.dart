// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_recipe_display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecipeDisplay _$UserRecipeDisplayFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserRecipeDisplay',
      json,
      ($checkedConvert) {
        final val = UserRecipeDisplay(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
          recipeDate: $checkedConvert('recipe_date', (v) => v as String?),
          portions: $checkedConvert(
            'display_portions',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Portion.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
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
          membership: $checkedConvert(
            'display_membership',
            (v) => v == null
                ? null
                : UserMemberRecipeDisplay.fromJson(
                    v as Map<String, dynamic>,
                  ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'recipeDate': 'recipe_date',
        'portions': 'display_portions',
        'nutrients': 'display_nutrients',
        'memberIngredients': 'member_ingredients',
        'memberRecipes': 'member_recipes',
        'membership': 'display_membership'
      },
    );

Map<String, dynamic> _$UserRecipeDisplayToJson(UserRecipeDisplay instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'recipe_date': instance.recipeDate,
      'display_portions': instance.portions,
      'display_nutrients': instance.nutrients,
      'member_ingredients': instance.memberIngredients,
      'member_recipes': instance.memberRecipes,
      'display_membership': instance.membership,
    };
