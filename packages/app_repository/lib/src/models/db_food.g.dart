// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'db_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBFood _$DBFoodFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DBFood',
      json,
      ($checkedConvert) {
        final val = DBFood(
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
          lfoodExternalId:
              $checkedConvert('lfood_external_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'lfoodExternalId': 'lfood_external_id'
      },
    );

Map<String, dynamic> _$DBFoodToJson(DBFood instance) => <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'brand': instance.brand,
      'portions': instance.portions,
      'nutrients': instance.nutrients,
      'lfood_external_id': instance.lfoodExternalId,
    };
