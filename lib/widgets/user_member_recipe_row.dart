import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class UserMemberRecipeRowWidget extends StatelessWidget {
  const UserMemberRecipeRowWidget({
    Key? key,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  final UserMemberRecipeDisplay result;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(result.recipe.name);
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  result.recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: result.portion!.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          if (result.recipe.recipeDate != null) ...[
            Row(
              children: const [
                SizedBox(height: 5),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    result.recipe.displayDate,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
