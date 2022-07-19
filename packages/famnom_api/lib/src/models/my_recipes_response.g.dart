// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'my_recipes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyRecipesResponse _$MyRecipesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MyRecipesResponse',
      json,
      ($checkedConvert) {
        final val = MyRecipesResponse(
          count: $checkedConvert('count', (v) => v! as int),
          next: $checkedConvert('next', (v) => v as String?),
          previous: $checkedConvert('previous', (v) => v as String?),
          results: $checkedConvert(
            'results',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) => UserRecipeDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$MyRecipesResponseToJson(MyRecipesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
