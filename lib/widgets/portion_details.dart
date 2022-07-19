import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class PortionDetails extends StatelessWidget {
  const PortionDetails({
    Key? key,
    required this.portions,
    required this.defaultPortion,
    this.defaultQuantity,
    required this.onChangedServings,
    required this.onChangedQuantity,
  }) : super(key: key);

  final List<Portion> portions;
  final Portion defaultPortion;
  final double? defaultQuantity;
  final Function(Object?) onChangedServings;
  final Function(Object?) onChangedQuantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ButtonTheme(
          key: const Key('model_servings_dropdownField'),
          alignedDropdown: true,
          child: DropdownButtonFormField(
            items: portions.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text.rich(
                  TextSpan(text: value.name),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            isExpanded: true,
            isDense: false,
            menuMaxHeight: 250,
            value: defaultPortion,
            onChanged: onChangedServings,
            decoration: const InputDecoration(
              labelText: 'Serving size',
              helperText: '',
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        TextFormField(
          key: const Key('model_servings_quantity_textField'),
          onChanged: onChangedQuantity,
          initialValue: '${defaultQuantity ?? ""}',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Quantity',
            helperText: '',
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}
