// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'fda_rdi_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FdaRdiResponse _$FdaRdiResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FdaRdiResponse',
      json,
      ($checkedConvert) {
        final val = FdaRdiResponse(
          results: $checkedConvert(
            'results',
            (v) => (v! as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                $enumDecode(_$FDAGroupEnumMap, k),
                (e as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                    k,
                    FdaRdi.fromJson(e as Map<String, dynamic>),
                  ),
                ),
              ),
            ),
          ),
        );
        return val;
      },
    );

Map<String, dynamic> _$FdaRdiResponseToJson(FdaRdiResponse instance) =>
    <String, dynamic>{
      'results':
          instance.results.map((k, e) => MapEntry(_$FDAGroupEnumMap[k], e)),
    };

const _$FDAGroupEnumMap = {
  FDAGroup.adult: '1',
  FDAGroup.infant: '2',
  FDAGroup.children: '3',
  FDAGroup.pregnant: '4',
};
