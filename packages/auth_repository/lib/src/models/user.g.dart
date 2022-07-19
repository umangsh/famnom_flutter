// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          externalId: $checkedConvert('external_id', (v) => v! as String),
          email: $checkedConvert('email', (v) => v! as String),
          firstName: $checkedConvert('first_name', (v) => v as String?),
          lastName: $checkedConvert('last_name', (v) => v as String?),
          dateOfBirth: $checkedConvert(
            'date_of_birth',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          isPregnant: $checkedConvert('is_pregnant', (v) => v as bool?),
          familyMembers: $checkedConvert(
            'family_members',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'firstName': 'first_name',
        'lastName': 'last_name',
        'dateOfBirth': 'date_of_birth',
        'isPregnant': 'is_pregnant',
        'familyMembers': 'family_members'
      },
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'external_id': instance.externalId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'is_pregnant': instance.isPregnant,
      'family_members': instance.familyMembers,
    };
