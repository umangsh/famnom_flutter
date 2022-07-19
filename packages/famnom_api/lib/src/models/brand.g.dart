// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Brand',
      json,
      ($checkedConvert) {
        final val = Brand(
          brandOwner: $checkedConvert('brand_owner', (v) => v as String?),
          brandName: $checkedConvert('brand_name', (v) => v as String?),
          subbrandName: $checkedConvert('subbrand_name', (v) => v as String?),
          gtinUpc: $checkedConvert('gtin_upc', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'brandOwner': 'brand_owner',
        'brandName': 'brand_name',
        'subbrandName': 'subbrand_name',
        'gtinUpc': 'gtin_upc'
      },
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'brand_owner': instance.brandOwner,
      'brand_name': instance.brandName,
      'subbrand_name': instance.subbrandName,
      'gtin_upc': instance.gtinUpc,
    };
