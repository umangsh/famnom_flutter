import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class UserMemberIngredientRowWidget extends StatelessWidget {
  const UserMemberIngredientRowWidget({
    Key? key,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  final UserMemberIngredientDisplay result;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final brandDetails = result.ingredient.brand?.brandDetails;
    return InkWell(
      onTap: () {
        onTap(result.ingredient.name);
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  result.ingredient.name,
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
          if (brandDetails != null) ...[
            Row(
              children: const [
                SizedBox(height: 5),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    brandDetails,
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
