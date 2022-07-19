import 'package:flutter/material.dart';

class EmptySpinner extends StatelessWidget {
  const EmptySpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.secondary,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
    );
  }
}
