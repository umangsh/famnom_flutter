part of 'edit_cubit.dart';

// ignore: must_be_immutable
class MealForm extends Equatable {
  MealForm({
    this.userMeal,
    this.externalId,
    this.mealType,
    this.mealDate,
    this.ingredientMembers,
    this.ingredientMembersFormsetPrefix = 'food',
    this.recipeMembers,
    this.recipeMembersFormsetPrefix = 'recipe',
  });

  UserMealMutable? userMeal;
  String? externalId;
  String? mealType;
  String? mealDate;
  List<FoodMemberForm>? ingredientMembers;
  String ingredientMembersFormsetPrefix;
  List<FoodMemberForm>? recipeMembers;
  String recipeMembersFormsetPrefix;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    // Food metadata
    form['external_id'] = externalId;
    form['meal_type'] = mealType;
    form['meal_date'] = mealDate;

    // Ingredient members management form
    form['$ingredientMembersFormsetPrefix-TOTAL_FORMS'] =
        ingredientMembers?.length ?? 0;
    form['$ingredientMembersFormsetPrefix-INITIAL_FORMS'] =
        userMeal?.memberIngredients?.length ?? 0;
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
        userMeal?.memberRecipes?.length ?? 0;
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
  List<Object?> get props => [externalId, mealType, mealDate];
}
