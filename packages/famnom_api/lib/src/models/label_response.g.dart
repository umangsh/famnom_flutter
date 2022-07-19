// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'label_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelResponse _$LabelResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LabelResponse',
      json,
      ($checkedConvert) {
        final val = LabelResponse(
          results: $checkedConvert(
            'results',
            (v) => (v! as List<dynamic>)
                .map((e) => Nutrient.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$LabelResponseToJson(LabelResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
