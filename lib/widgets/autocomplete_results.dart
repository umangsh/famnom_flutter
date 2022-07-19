import 'package:flutter/material.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:search_repository/search_repository.dart';

class AutocompleteResults extends StatelessWidget {
  const AutocompleteResults({
    Key? key,
    required this.results,
    required this.onTap,
  }) : super(key: key);

  final List<AutocompleteResult> results;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: results
            .map(
              (result) => AutocompleteRowWidget(
                suggestion: result,
                onTap: onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}
