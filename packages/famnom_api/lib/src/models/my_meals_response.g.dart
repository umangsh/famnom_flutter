// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'my_meals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMealsResponse _$MyMealsResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MyMealsResponse',
      json,
      ($checkedConvert) {
        final val = MyMealsResponse(
          count: $checkedConvert('count', (v) => v! as int),
          next: $checkedConvert('next', (v) => v as String?),
          previous: $checkedConvert('previous', (v) => v as String?),
          results: $checkedConvert(
            'results',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) => UserMealDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$MyMealsResponseToJson(MyMealsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
