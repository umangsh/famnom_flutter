import 'package:flutter/material.dart';
import 'package:search_repository/search_repository.dart';

class AutocompleteRowWidget extends StatelessWidget {
  const AutocompleteRowWidget({
    Key? key,
    required this.suggestion,
    required this.onTap,
  }) : super(key: key);

  final AutocompleteResult suggestion;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(suggestion.query);
      },
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {
              onTap(suggestion.query);
            },
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              suggestion.query,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.north_west, size: 28),
            onPressed: () {
              onTap(suggestion.query);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ],
      ),
    );
  }
}
