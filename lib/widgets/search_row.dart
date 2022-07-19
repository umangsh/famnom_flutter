import 'package:flutter/material.dart';
import 'package:search_repository/search_repository.dart';

class SearchRowWidget extends StatelessWidget {
  const SearchRowWidget({
    Key? key,
    required this.searchResult,
    required this.onTap,
  }) : super(key: key);

  final SearchResult searchResult;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final brandDetails = searchResult.brandDetails;
    return InkWell(
      onTap: () {
        onTap(searchResult.name);
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
                        searchResult.name,
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
