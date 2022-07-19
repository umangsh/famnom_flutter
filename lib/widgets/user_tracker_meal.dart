import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class UserTrackerMeal extends StatelessWidget {
  const UserTrackerMeal({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final UserMealDisplay meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(DetailsUserMealPage.route(meal.externalId));
            },
            child: Wrap(
              children: [
                Text(
                  meal.mealType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.secondary,
              ),
            ),
            child: Column(
              children: [
                for (var result in meal.memberIngredients ??
                    <UserMemberIngredientDisplay>[]) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: UserMemberIngredientRowWidget(
                      result: result,
                      onTap: (query) {
                        Navigator.of(context).push(
                          DetailsUserIngredientPage.route(
                            externalId: result.ingredient.externalId,
                            membershipExternalId: result.externalId,
                            onDeleteRoute: HomePage.route(),
                          ),
                        );
                      },
                    ),
                  ),
                  if ((meal.memberRecipes != null &&
                          meal.memberRecipes!.isNotEmpty) ||
                      (meal.memberIngredients != null &&
                          result != meal.memberIngredients!.last))
                    Divider(
                      color: theme.colorScheme.secondary,
                      height: 1,
                      thickness: 1,
                    )
                ],
                for (var result
                    in meal.memberRecipes ?? <UserMemberRecipeDisplay>[]) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: UserMemberRecipeRowWidget(
                      result: result,
                      onTap: (query) {
                        Navigator.of(context).push(
                          DetailsUserRecipePage.route(
                            externalId: result.recipe.externalId,
                            membershipExternalId: result.externalId,
                            onDeleteRoute: HomePage.route(),
                          ),
                        );
                      },
                    ),
                  ),
                  if (meal.memberRecipes != null &&
                      result != meal.memberRecipes!.last)
                    Divider(
                      color: theme.colorScheme.secondary,
                      height: 1,
                      thickness: 1,
                    )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
