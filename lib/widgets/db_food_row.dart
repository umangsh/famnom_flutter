import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class DBFoodRowWidget extends StatelessWidget {
  const DBFoodRowWidget({
    Key? key,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  final DBFood result;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final brandDetails = result.brand?.brandDetails;
    return InkWell(
      onTap: () {
        onTap(result.name);
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
                        result.name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
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
