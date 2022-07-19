import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class UserMealRowWidget extends StatelessWidget {
  const UserMealRowWidget({
    Key? key,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  final UserMealDisplay result;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(result.mealType);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        result.mealType,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    SizedBox(height: 5),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        result.displayDate,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Icon(Icons.chevron_right, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
