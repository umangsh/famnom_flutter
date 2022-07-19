part of 'edit_cubit.dart';

// ignore: must_be_immutable
class RecipeForm extends Equatable {
  RecipeForm({
    this.userRecipe,
    this.externalId,
    this.name,
    this.recipeDate,
    this.portions,
    this.portionsFormsetPrefix = 'servings',
    this.ingredientMembers,
    this.ingredientMembersFormsetPrefix = 'food',
    this.recipeMembers,
    this.recipeMembersFormsetPrefix = 'recipe',
  });

  UserRecipeMutable? userRecipe;
  String? externalId;
  String? name;
  String? recipeDate;
  List<FoodPortionForm>? portions;
  String portionsFormsetPrefix;
  List<FoodMemberForm>? ingredientMembers;
  String ingredientMembersFormsetPrefix;
  List<FoodMemberForm>? recipeMembers;
  String recipeMembersFormsetPrefix;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    // Food metadata
    form['external_id'] = externalId;
    form['name'] = name;
    form['recipe_date'] = recipeDate;

    // Portions management form
    form['$portionsFormsetPrefix-TOTAL_FORMS'] =
        portions?.at(0) == null ? 0 : 1;
    form['$portionsFormsetPrefix-INITIAL_FORMS'] =
        userRecipe?.portions?.at(0) == null ? 0 : 1;
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

    // Ingredient members management form
    form['$ingredientMembersFormsetPrefix-TOTAL_FORMS'] =
        ingredientMembers?.length ?? 0;
    form['$ingredientMembersFormsetPrefix-INITIAL_FORMS'] =
        userRecipe?.memberIngredients?.length ?? 0;
    form['$ingredientMembersFormsetPrefix-MIN_NUM_FORMS'] = 0;
    form['$ingredientMembersFormsetPrefix-MAX_NUM_FORMS'] = 1000;

    // Ingredient members form.
    for (final entry
        in (ingredientMembers ?? <FoodMemberForm>[]).asMap().entries) {
      form['$ingredientMembersFormsetPrefix-${entry.key}-id'] = entry.value.id;
      form['$ingredientMembersFormsetPrefix-${entry.key}-child_external_id'] =
          entry.value.childExternalId;
      form['$ingredientMembersFormsetPrefix-${entry.key}-serving'] =
          entry.value.serving;
      form['$ingredientMembersFormsetPrefix-${entry.key}-quantity'] =
          entry.value.quantity;

      if (entry.value.isDeleted ?? false) {
        form['$ingredientMembersFormsetPrefix-${entry.key}-DELETE'] = true;
      }
    }

    // Recipe members management form
    form['$recipeMembersFormsetPrefix-TOTAL_FORMS'] =
        recipeMembers?.length ?? 0;
    form['$recipeMembersFormsetPrefix-INITIAL_FORMS'] =
        userRecipe?.memberRecipes?.length ?? 0;
    form['$recipeMembersFormsetPrefix-MIN_NUM_FORMS'] = 0;
    form['$recipeMembersFormsetPrefix-MAX_NUM_FORMS'] = 1000;

    // Recipe members form.
    for (final entry in (recipeMembers ?? <FoodMemberForm>[]).asMap().entries) {
      form['$recipeMembersFormsetPrefix-${entry.key}-id'] = entry.value.id;
      form['$recipeMembersFormsetPrefix-${entry.key}-child_external_id'] =
          entry.value.childExternalId;
      form['$recipeMembersFormsetPrefix-${entry.key}-serving'] =
          entry.value.serving;
      form['$recipeMembersFormsetPrefix-${entry.key}-quantity'] =
          entry.value.quantity;

      if (entry.value.isDeleted ?? false) {
        form['$recipeMembersFormsetPrefix-${entry.key}-DELETE'] = true;
      }
    }

    return form;
  }

  void addFoodMember() {
    ingredientMembers ??= [];
    return _addMember(ingredientMembers!);
  }

  void addRecipeMember() {
    recipeMembers ??= [];
    return _addMember(recipeMembers!);
  }

  void _addMember(List<FoodMemberForm> members) {
    members.add(FoodMemberForm());
  }

  void deleteFoodMember(int index) {
    ingredientMembers ??= [];
    return _deleteMember(ingredientMembers!, index);
  }

  void deleteRecipeMember(int index) {
    recipeMembers ??= [];
    return _deleteMember(recipeMembers!, index);
  }

  void _deleteMember(List<FoodMemberForm> members, int index) {
    final member = members.at(index);
    if (member == null) {
      return;
    }

    if (member.id == null) {
      members.removeAt(index);
    } else {
      member.isDeleted = true;
    }
  }

  @override
  List<Object?> get props => [externalId, name, recipeDate];
}
