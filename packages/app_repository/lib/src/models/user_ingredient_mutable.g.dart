// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_ingredient_mutable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIngredientMutable _$UserIngredientMutableFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate(
      'UserIngredientMutable',
      json,
      ($checkedConvert) {
        final val = UserIngredientMutable(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
          brand: $checkedConvert(
            'brand',
            (v) => v == null ? null : Brand.fromJson(v as Map<String, dynamic>),
          ),
          portions: $checkedConvert(
            'portions',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) => UserFoodPortion.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          nutrients: $checkedConvert(
            'nutrients',
            (v) => Nutrients.fromJson(v! as Map<String, dynamic>),
          ),
          category: $checkedConvert('category', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'externalId': 'external_id'},
    );

Map<String, dynamic> _$UserIngredientMutableToJson(
  UserIngredientMutable instance,
) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'brand': instance.brand,
      'portions': instance.portions,
      'nutrients': instance.nutrients,
      'category': instance.category,
    };
