// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_ingredient_display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIngredientDisplay _$UserIngredientDisplayFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate(
      'UserIngredientDisplay',
      json,
      ($checkedConvert) {
        final val = UserIngredientDisplay(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('display_name', (v) => v! as String),
          brand: $checkedConvert(
            'display_brand',
            (v) => v == null ? null : Brand.fromJson(v as Map<String, dynamic>),
          ),
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
          category: $checkedConvert('display_category', (v) => v as String?),
          membership: $checkedConvert(
            'display_membership',
            (v) => v == null
                ? null
                : UserMemberIngredientDisplay.fromJson(
                    v as Map<String, dynamic>,
                  ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'name': 'display_name',
        'brand': 'display_brand',
        'portions': 'display_portions',
        'nutrients': 'display_nutrients',
        'category': 'display_category',
        'membership': 'display_membership'
      },
    );

Map<String, dynamic> _$UserIngredientDisplayToJson(
  UserIngredientDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'display_name': instance.name,
      'display_brand': instance.brand,
      'display_portions': instance.portions,
      'display_nutrients': instance.nutrients,
      'display_category': instance.category,
      'display_membership': instance.membership,
    };
