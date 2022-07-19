// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user_food_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFoodMembership _$UserFoodMembershipFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserFoodMembership',
      json,
      ($checkedConvert) {
        final val = UserFoodMembership(
          id: $checkedConvert('id', (v) => v! as int),
          externalId: $checkedConvert('external_id', (v) => v! as String),
          childId: $checkedConvert('child_id', (v) => v! as int),
          childExternalId:
              $checkedConvert('child_external_id', (v) => v! as String),
          childName: $checkedConvert('child_name', (v) => v! as String),
          childPortionExternalId:
              $checkedConvert('child_portion_external_id', (v) => v! as String),
          childPortionName:
              $checkedConvert('child_portion_name', (v) => v! as String),
          quantity: $checkedConvert('quantity', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'childId': 'child_id',
        'childExternalId': 'child_external_id',
        'childName': 'child_name',
        'childPortionExternalId': 'child_portion_external_id',
        'childPortionName': 'child_portion_name'
      },
    );

Map<String, dynamic> _$UserFoodMembershipToJson(UserFoodMembership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'external_id': instance.externalId,
      'child_id': instance.childId,
      'child_external_id': instance.childExternalId,
      'child_name': instance.childName,
      'child_portion_external_id': instance.childPortionExternalId,
      'child_portion_name': instance.childPortionName,
      'quantity': instance.quantity,
    };
