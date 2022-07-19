// ignore_for_file: lines_longer_than_80_chars
import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_flutter/edit/edit.dart';
import 'package:test/test.dart';

void main() {
  group('FoodForm', () {
    group('convertToMap', () {
      test('empty FoodForm', () {
        final form = FoodForm();
        final expected = <String, dynamic>{
          'external_id': null,
          'name': null,
          'category_id': null,
          'brand_name': null,
          'subbrand_name': null,
          'brand_owner': null,
          'gtin_upc': null,
          'nutrition_tracker-userfoodportion-content_type-object_id-TOTAL_FORMS':
              0,
          'nutrition_tracker-userfoodportion-content_type-object_id-INITIAL_FORMS':
              0,
          'nutrition_tracker-userfoodportion-content_type-object_id-MIN_NUM_FORMS':
              0,
          'nutrition_tracker-userfoodportion-content_type-object_id-MAX_NUM_FORMS':
              1000
        };
        expect(form.convertToMap(), equals(expected));
      });

      test('FoodForm with values unchanged portions', () {
        const userIngredient = UserIngredientMutable(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          brand: Brand(
            brandName: constants.testBrandName,
            subBrandName: constants.testSubBrandName,
            brandOwner: constants.testBrandOwner,
            gtinUpc: constants.testGTINUPC,
          ),
          portions: [
            UserFoodPortion(
              id: constants.testPortionId,
              externalId: constants.testPortionExternalId,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: {
              constants.testNutrientId: Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            },
          ),
        );

        final form = FoodForm(
          userIngredient: userIngredient,
          externalId: userIngredient.externalId,
          name: userIngredient.name,
          brandName: userIngredient.brand?.brandName,
          subbrandName: userIngredient.brand?.subBrandName,
          brandOwner: userIngredient.brand?.brandOwner,
          gtinUpc: userIngredient.brand?.gtinUpc,
          portions: [
            FoodPortionForm(
              id: constants.testPortionId,
              servingSize: constants.testPortionSize.toString(),
              servingSizeUnit: constants.testPortionSizeUnit,
            )
          ],
          nutrients: const {
            constants.testNutrientId: '${constants.testNutrientAmount}',
          },
        );
        final expected = <String, dynamic>{
          'external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'name': 'test_db_food_name',
          'category_id': null,
          'brand_name': 'test_brand_name',
          'subbrand_name': 'test_sub_brand_name',
          'brand_owner': 'test_brand_owner',
          'gtin_upc': 'test_gtin_upc',
          'nutrition_tracker-userfoodportion-content_type-object_id-TOTAL_FORMS':
              1,
          'nutrition_tracker-userfoodportion-content_type-object_id-INITIAL_FORMS':
              1,
          'nutrition_tracker-userfoodportion-content_type-object_id-MIN_NUM_FORMS':
              0,
          'nutrition_tracker-userfoodportion-content_type-object_id-MAX_NUM_FORMS':
              1000,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-id': 123,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-servings_per_container':
              null,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-household_quantity':
              null,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-measure_unit':
              null,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-serving_size':
              '100.0',
          'nutrition_tracker-userfoodportion-content_type-object_id-0-serving_size_unit':
              'g',
          '1008': '43.22'
        };
        expect(form.convertToMap(), equals(expected));
      });

      test('FoodForm with values changed portions', () {
        const userIngredient = UserIngredientMutable(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          brand: Brand(
            brandName: constants.testBrandName,
            subBrandName: constants.testSubBrandName,
            brandOwner: constants.testBrandOwner,
            gtinUpc: constants.testGTINUPC,
          ),
          portions: [
            UserFoodPortion(
              id: constants.testPortionId,
              externalId: constants.testPortionExternalId,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: {
              constants.testNutrientId: Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            },
          ),
        );

        final form = FoodForm(
          userIngredient: userIngredient,
          externalId: userIngredient.externalId,
          name: userIngredient.name,
          brandName: userIngredient.brand?.brandName,
          subbrandName: userIngredient.brand?.subBrandName,
          brandOwner: userIngredient.brand?.brandOwner,
          gtinUpc: userIngredient.brand?.gtinUpc,
          portions: [
            FoodPortionForm(
              id: constants.testPortionId,
              householdQuantity: constants.testPortionHouseholdQuantity,
              householdUnit: constants.testPortionHouseholdUnit,
              servingSize: '83',
              servingSizeUnit: 'ml',
            )
          ],
          nutrients: const {
            constants.testNutrientId: '${constants.testNutrientAmount}',
          },
        );
        final expected = <String, dynamic>{
          'external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'name': 'test_db_food_name',
          'category_id': null,
          'brand_name': 'test_brand_name',
          'subbrand_name': 'test_sub_brand_name',
          'brand_owner': 'test_brand_owner',
          'gtin_upc': 'test_gtin_upc',
          'nutrition_tracker-userfoodportion-content_type-object_id-TOTAL_FORMS':
              1,
          'nutrition_tracker-userfoodportion-content_type-object_id-INITIAL_FORMS':
              1,
          'nutrition_tracker-userfoodportion-content_type-object_id-MIN_NUM_FORMS':
              0,
          'nutrition_tracker-userfoodportion-content_type-object_id-MAX_NUM_FORMS':
              1000,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-id': 123,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-servings_per_container':
              null,
          'nutrition_tracker-userfoodportion-content_type-object_id-0-household_quantity':
              '1/4',
          'nutrition_tracker-userfoodportion-content_type-object_id-0-measure_unit':
              'chips',
          'nutrition_tracker-userfoodportion-content_type-object_id-0-serving_size':
              '83',
          'nutrition_tracker-userfoodportion-content_type-object_id-0-serving_size_unit':
              'ml',
          '1008': '43.22'
        };
        expect(form.convertToMap(), equals(expected));
      });
    });
  });
}
