import 'package:flutter/material.dart';

class InlineSearchBar extends StatelessWidget {
  const InlineSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    required this.onClearPressed,
    this.endWidget,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final Function(String) onSubmitted;
  final VoidCallback onClearPressed;
  final Widget? endWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          height: 40,
          width: endWidget == null ? 300 : 250,
          child: Center(
            child: TextField(
              key: key,
              textAlignVertical: TextAlignVertical.bottom,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearPressed,
                ),
                hintText: hintText,
              ),
            ),
          ),
        ),
        if (endWidget != null)
          Container(
            height: 40,
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            child: endWidget,
          ),
      ],
    );
  }
}
