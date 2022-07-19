// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tracker _$TrackerFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Tracker',
      json,
      ($checkedConvert) {
        final val = Tracker(
          meals: $checkedConvert(
            'meals',
            (v) => (v! as List<dynamic>)
                .map(
                  (e) => UserMealDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          nutrients: $checkedConvert(
            'nutrients',
            (v) => Nutrients.fromJson(v! as Map<String, dynamic>),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$TrackerToJson(Tracker instance) => <String, dynamic>{
      'meals': instance.meals,
      'nutrients': instance.nutrients,
    };
