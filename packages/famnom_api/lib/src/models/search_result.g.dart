// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SearchResult',
      json,
      ($checkedConvert) {
        final val = SearchResult(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          dname: $checkedConvert('dname', (v) => v! as String),
          url: $checkedConvert('url', (v) => v! as String),
          brandName: $checkedConvert('brand_name', (v) => v as String?),
          brandOwner: $checkedConvert('brand_owner', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'brandName': 'brand_name',
        'brandOwner': 'brand_owner'
      },
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'dname': instance.dname,
      'url': instance.url,
      'brand_name': instance.brandName,
      'brand_owner': instance.brandOwner,
    };
