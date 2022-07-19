// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'fda_rdi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FdaRdi _$FdaRdiFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FdaRdi',
      json,
      ($checkedConvert) {
        final val = FdaRdi(
          name: $checkedConvert('name', (v) => v! as String),
          value: $checkedConvert('value', (v) => (v as num?)?.toDouble()),
          unit: $checkedConvert('unit', (v) => v as String?),
          threshold: $checkedConvert(
            'threshold',
            (v) => $enumDecodeNullable(_$ThresholdEnumMap, v),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$FdaRdiToJson(FdaRdi instance) => <String, dynamic>{
      'name': instance.name,
      'unit': instance.unit,
      'value': instance.value,
      'threshold': _$ThresholdEnumMap[instance.threshold],
    };

const _$ThresholdEnumMap = {
  Threshold.max: '1',
  Threshold.exact: '2',
  Threshold.min: '3',
};
