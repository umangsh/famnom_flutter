// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'my_foods_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFoodsResponse _$MyFoodsResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MyFoodsResponse',
      json,
      ($checkedConvert) {
        final val = MyFoodsResponse(
          count: $checkedConvert('count', (v) => v! as int),
          next: $checkedConvert('next', (v) => v as String?),
          previous: $checkedConvert('previous', (v) => v as String?),
          results: $checkedConvert(
            'results',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) =>
                      UserIngredientDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$MyFoodsResponseToJson(MyFoodsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
