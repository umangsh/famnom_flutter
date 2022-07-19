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
          recipe: $checkedConvert(
            'recipe',
            (v) => UserRecipeDisplay.fromJson(v! as Map<String, dynamic>),
          ),
          portion: $checkedConvert(
            'portion',
            (v) =>
                v == null ? null : Portion.fromJson(v as Map<String, dynamic>),
          ),
          recipePortionExternalId: $checkedConvert(
            'recipe_portion_external_id',
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
        'recipePortionExternalId': 'recipe_portion_external_id'
      },
    );

Map<String, dynamic> _$UserMemberRecipeDisplayToJson(
  UserMemberRecipeDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'recipe': instance.recipe,
      'portion': instance.portion,
      'recipe_portion_external_id': instance.recipePortionExternalId,
      'meal': instance.meal,
    };
