// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'db_branded_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBBrandedFood _$DBBrandedFoodFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DBBrandedFood',
      json,
      ($checkedConvert) {
        final val = DBBrandedFood(
          brandOwner: $checkedConvert('brand_owner', (v) => v as String?),
          brandName: $checkedConvert('brand_name', (v) => v as String?),
          subBrandName: $checkedConvert('sub_brand_name', (v) => v as String?),
          gtinUpc: $checkedConvert('gtin_upc', (v) => v as String?),
          ingredients: $checkedConvert('ingredients', (v) => v as String?),
          notASignificantSourceOf: $checkedConvert(
            'not_a_significant_source_of',
            (v) => v as String?,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'brandOwner': 'brand_owner',
        'brandName': 'brand_name',
        'subBrandName': 'sub_brand_name',
        'gtinUpc': 'gtin_upc',
        'notASignificantSourceOf': 'not_a_significant_source_of'
      },
    );

Map<String, dynamic> _$DBBrandedFoodToJson(DBBrandedFood instance) =>
    <String, dynamic>{
      'brand_owner': instance.brandOwner,
      'brand_name': instance.brandName,
      'sub_brand_name': instance.subBrandName,
      'gtin_upc': instance.gtinUpc,
      'ingredients': instance.ingredients,
      'not_a_significant_source_of': instance.notASignificantSourceOf,
    };
