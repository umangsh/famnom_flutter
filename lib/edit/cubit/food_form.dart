part of 'edit_cubit.dart';

// ignore: must_be_immutable
class FoodForm extends Equatable {
  FoodForm({
    this.userIngredient,
    this.externalId,
    this.name,
    this.brandName,
    this.subbrandName,
    this.brandOwner,
    this.gtinUpc,
    this.categoryId,
    this.portions,
    this.portionsFormsetPrefix =
        'nutrition_tracker-userfoodportion-content_type-object_id',
    this.nutrients,
  });

  UserIngredientMutable? userIngredient;
  String? externalId;
  String? name;
  String? brandName;
  String? subbrandName;
  String? brandOwner;
  String? gtinUpc;
  String? categoryId;
  List<FoodPortionForm>? portions;
  String portionsFormsetPrefix;
  Map<int, String?>? nutrients;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    // Food metadata
    form['external_id'] = externalId;
    form['name'] = name;
    form['category_id'] = categoryId;

    // Brand metadata
    form['brand_name'] = brandName;
    form['subbrand_name'] = subbrandName;
    form['brand_owner'] = brandOwner;
    form['gtin_upc'] = gtinUpc;

    // Portions management form
    form['$portionsFormsetPrefix-TOTAL_FORMS'] =
        portions?.at(0) == null ? 0 : 1;
    form['$portionsFormsetPrefix-INITIAL_FORMS'] =
        userIngredient?.portions?.at(0) == null ? 0 : 1;
    form['$portionsFormsetPrefix-MIN_NUM_FORMS'] = 0;
    form['$portionsFormsetPrefix-MAX_NUM_FORMS'] = 1000;

    // Portions form
    if (portions?.at(0) != null) {
      form['$portionsFormsetPrefix-0-id'] = portions?.at(0)?.id;
      form['$portionsFormsetPrefix-0-servings_per_container'] =
          portions?.at(0)?.servingsPerContainer;
      form['$portionsFormsetPrefix-0-household_quantity'] =
          portions?.at(0)?.householdQuantity;
      form['$portionsFormsetPrefix-0-measure_unit'] =
          portions?.at(0)?.householdUnit;
      form['$portionsFormsetPrefix-0-serving_size'] =
          portions?.at(0)?.servingSize;
      form['$portionsFormsetPrefix-0-serving_size_unit'] =
          portions?.at(0)?.servingSizeUnit;
    }

    // Nutrition fields
    if (nutrients != null) {
      for (final entry in nutrients!.entries) {
        form[getFieldName(entry.key)] = entry.value;
      }
    }

    return form;
  }

  @override
  List<Object?> get props => [externalId, name];
}
