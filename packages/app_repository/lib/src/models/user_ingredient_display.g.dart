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
          name: $checkedConvert('name', (v) => v! as String),
          brand: $checkedConvert(
            'brand',
            (v) => v == null ? null : Brand.fromJson(v as Map<String, dynamic>),
          ),
          portions: $checkedConvert(
            'portions',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Portion.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          nutrients: $checkedConvert(
            'nutrients',
            (v) => v == null
                ? null
                : Nutrients.fromJson(v as Map<String, dynamic>),
          ),
          category: $checkedConvert('category', (v) => v as String?),
          membership: $checkedConvert(
            'membership',
            (v) => v == null
                ? null
                : UserMemberIngredientDisplay.fromJson(
                    v as Map<String, dynamic>,
                  ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'externalId': 'external_id'},
    );

Map<String, dynamic> _$UserIngredientDisplayToJson(
  UserIngredientDisplay instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'brand': instance.brand,
      'portions': instance.portions,
      'nutrients': instance.nutrients,
      'membership': instance.membership,
      'category': instance.category,
    };
