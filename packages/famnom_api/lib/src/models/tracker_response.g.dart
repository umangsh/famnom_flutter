// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'tracker_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackerResponse _$TrackerResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TrackerResponse',
      json,
      ($checkedConvert) {
        final val = TrackerResponse(
          meals: $checkedConvert(
            'display_meals',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) => UserMealDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          nutrients: $checkedConvert(
            'display_nutrients',
            (v) => Nutrients.fromJson(v! as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'meals': 'display_meals',
        'nutrients': 'display_nutrients'
      },
    );

Map<String, dynamic> _$TrackerResponseToJson(TrackerResponse instance) =>
    <String, dynamic>{
      'display_meals': instance.meals,
      'display_nutrients': instance.nutrients,
    };
