// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'app_constants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConstants _$AppConstantsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AppConstants',
      json,
      ($checkedConvert) {
        final val = AppConstants(
          fdaRdis: $checkedConvert(
            'fda_rdis',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(
                $enumDecode(_$FDAGroupEnumMap, k),
                (e as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                    int.parse(k),
                    FdaRdi.fromJson(e as Map<String, dynamic>),
                  ),
                ),
              ),
            ),
          ),
          labelNutrients: $checkedConvert(
            'label_nutrients',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(
                int.parse(k),
                Nutrient.fromJson(e as Map<String, dynamic>),
              ),
            ),
          ),
          categories: $checkedConvert(
            'categories',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Map<String, String>.from(e as Map))
                .toList(),
          ),
          householdQuantities: $checkedConvert(
            'household_quantities',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Map<String, String>.from(e as Map))
                .toList(),
          ),
          householdUnits: $checkedConvert(
            'household_units',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Map<String, String>.from(e as Map))
                .toList(),
          ),
          servingSizeUnits: $checkedConvert(
            'serving_size_units',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Map<String, String>.from(e as Map))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'fdaRdis': 'fda_rdis',
        'labelNutrients': 'label_nutrients',
        'householdQuantities': 'household_quantities',
        'householdUnits': 'household_units',
        'servingSizeUnits': 'serving_size_units'
      },
    );

Map<String, dynamic> _$AppConstantsToJson(AppConstants instance) =>
    <String, dynamic>{
      'fda_rdis': instance.fdaRdis?.map(
        (k, e) => MapEntry(
          _$FDAGroupEnumMap[k],
          e.map((k, e) => MapEntry(k.toString(), e)),
        ),
      ),
      'label_nutrients':
          instance.labelNutrients?.map((k, e) => MapEntry(k.toString(), e)),
      'categories': instance.categories,
      'household_quantities': instance.householdQuantities,
      'household_units': instance.householdUnits,
      'serving_size_units': instance.servingSizeUnits,
    };

const _$FDAGroupEnumMap = {
  FDAGroup.adult: '1',
  FDAGroup.infant: '2',
  FDAGroup.children: '3',
  FDAGroup.pregnant: '4',
};
