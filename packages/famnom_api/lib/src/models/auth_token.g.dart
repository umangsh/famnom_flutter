// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AuthToken',
      json,
      ($checkedConvert) {
        final val = AuthToken(
          key: $checkedConvert('key', (v) => v! as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
      'key': instance.key,
    };
