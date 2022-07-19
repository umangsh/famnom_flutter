// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'portion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portion _$PortionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Portion',
      json,
      ($checkedConvert) {
        final val = Portion(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v! as String),
          servingSize:
              $checkedConvert('serving_size', (v) => (v! as num).toDouble()),
          servingSizeUnit:
              $checkedConvert('serving_size_unit', (v) => v! as String),
          servingsPerContainer: $checkedConvert(
            'servings_per_container',
            (v) => (v as num?)?.toDouble(),
          ),
          quantity: $checkedConvert('quantity', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'servingSize': 'serving_size',
        'servingSizeUnit': 'serving_size_unit',
        'servingsPerContainer': 'servings_per_container'
      },
    );

Map<String, dynamic> _$PortionToJson(Portion instance) => <String, dynamic>{
      'external_id': instance.externalId,
      'name': instance.name,
      'serving_size': instance.servingSize,
      'serving_size_unit': instance.servingSizeUnit,
      'servings_per_container': instance.servingsPerContainer,
      'quantity': instance.quantity,
    };
