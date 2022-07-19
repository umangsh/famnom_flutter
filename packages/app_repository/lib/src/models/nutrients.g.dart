// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'nutrients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nutrient _$NutrientFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Nutrient',
      json,
      ($checkedConvert) {
        final val = Nutrient(
          id: $checkedConvert('id', (v) => v! as int),
          name: $checkedConvert('name', (v) => v! as String),
          amount: $checkedConvert('amount', (v) => (v as num?)?.toDouble()),
          unit: $checkedConvert('unit', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$NutrientToJson(Nutrient instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
    };

Nutrients _$NutrientsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Nutrients',
      json,
      ($checkedConvert) {
        final val = Nutrients(
          servingSize:
              $checkedConvert('serving_size', (v) => (v as num?)?.toDouble()),
          servingSizeUnit:
              $checkedConvert('serving_size_unit', (v) => v as String?),
          values: $checkedConvert(
            'values',
            (v) => (v! as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                int.parse(k),
                Nutrient.fromJson(e as Map<String, dynamic>),
              ),
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'servingSize': 'serving_size',
        'servingSizeUnit': 'serving_size_unit'
      },
    );

Map<String, dynamic> _$NutrientsToJson(Nutrients instance) => <String, dynamic>{
      'serving_size': instance.servingSize,
      'serving_size_unit': instance.servingSizeUnit,
      'values': instance.values.map((k, e) => MapEntry(k.toString(), e)),
    };

NutrientPage _$NutrientPageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NutrientPage',
      json,
      ($checkedConvert) {
        final val = NutrientPage(
          id: $checkedConvert('id', (v) => v! as int),
          name: $checkedConvert('name', (v) => v! as String),
          unit: $checkedConvert('unit', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          wikipediaUrl: $checkedConvert('wikipedia_url', (v) => v as String?),
          recentLfoods: $checkedConvert(
            'recent_lfoods',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      UserIngredientDisplay.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          topCfoods: $checkedConvert(
            'top_cfoods',
            (v) => (v as List<dynamic>?)
                ?.map((e) => DBFood.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          threshold:
              $checkedConvert('threshold', (v) => (v as num?)?.toDouble()),
          amountPerDay: $checkedConvert(
            'amount_per_day',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num?)?.toDouble()),
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'wikipediaUrl': 'wikipedia_url',
        'recentLfoods': 'recent_lfoods',
        'topCfoods': 'top_cfoods',
        'amountPerDay': 'amount_per_day'
      },
    );

Map<String, dynamic> _$NutrientPageToJson(NutrientPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'description': instance.description,
      'wikipedia_url': instance.wikipediaUrl,
      'recent_lfoods': instance.recentLfoods,
      'top_cfoods': instance.topCfoods,
      'threshold': instance.threshold,
      'amount_per_day': instance.amountPerDay,
    };
