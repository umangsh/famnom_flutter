import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class UserMemberIngredientResults extends StatelessWidget {
  const UserMemberIngredientResults({
    Key? key,
    required this.results,
  }) : super(key: key);

  final List<UserMemberIngredientDisplay> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foods',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                for (var result in results) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: UserMemberIngredientRowWidget(
                      result: result,
                      onTap: (query) {
                        Navigator.of(context).push(
                          DetailsUserIngredientPage.route(
                            externalId: result.ingredient.externalId,
                            membershipExternalId: result.externalId,
                            onDeleteRoute: HomePage.route(selectedTab: 3),
                          ),
                        );
                      },
                    ),
                  ),
                  if (result != results.last)
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
