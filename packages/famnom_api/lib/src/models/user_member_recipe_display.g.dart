// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_member_recipe_display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMemberRecipeDisplay _$UserMemberRecipeDisplayFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate(
      'UserMemberRecipeDisplay',
      json,
      ($checkedConvert) {
        final val = UserMemberRecipeDisplay(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          displayRecipe: $checkedConvert(
            'display_recipe',
            (v) => UserRecipeDisplay.fromJson(v! as Map<String, dynamic>),
          ),
          displayPortion: $checkedConvert(
            'display_portion',
            (v) =>
                v == null ? null : Portion.fromJson(v as Map<String, dynamic>),
          ),
          recipePortionExternalId: $checkedConvert(
            'recipe_portion_external_id',
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
        'displayRecipe': 'display_recipe',
        'displayPortion': 'display_portion',
        'recipePortionExternalId': 'recipe_portion_external_id',
        'displayMeal': 'display_meal'
      },
    );

Map<String, dynamic> _$UserMemberRecipeDisplayToJson(
  UserMemberRecipeDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'display_recipe': instance.displayRecipe,
      'display_portion': instance.displayPortion,
      'recipe_portion_external_id': instance.recipePortionExternalId,
      'display_meal': instance.displayMeal,
    };
