import 'package:constants/constants.dart' as constants;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.isnum = false,
  }) : super(key: key);

  final String label;
  final Object? initialValue;
  final Function(String)? onChanged;
  final bool isnum;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key ?? UniqueKey(),
      controller: TextEditingController()
        ..text = initialValue?.toString() ?? ''
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: initialValue?.toString().length ?? 0),
        ),
      keyboardType: isnum
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      ),
      onChanged: onChanged,
    );
  }
}

class DateInput extends StatelessWidget {
  DateInput({
    Key? key,
    required this.label,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final String? initialValue;
  final Function(DateTime) onChanged;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(constants.DISPLAY_DATE_FORMAT);
    final initialDate =
        initialValue == null ? DateTime.now() : DateTime.parse(initialValue!);

    return TextFormField(
      key: key ?? UniqueKey(),
      controller: controller..text = dateFormat.format(initialDate),
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              key: UniqueKey(),
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (date) {
                  controller.text = dateFormat.format(date);
                  onChanged(date);
                },
                initialDateTime: dateFormat.parse(controller.text),
                minimumYear: 1900,
                maximumYear: DateTime.now().year,
              ),
            );
          },
        );
      },
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
      ),
    );
  }
}

class DropdownInput extends StatelessWidget {
  const DropdownInput({
    Key? key,
    required this.label,
    required this.choices,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final List<Map<String, String>> choices;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        key: key ?? UniqueKey(),
        items: choices.map((value) {
          return DropdownMenuItem(
            value: value['id'],
            child: Text.rich(
              TextSpan(text: value['name']),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        isExpanded: true,
        isDense: false,
        menuMaxHeight: 250,
        value: initialValue ?? '',
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: label,
        ),
      ),
    );
  }
}

class DropdownSearchInput<T> extends StatelessWidget {
  const DropdownSearchInput({
    Key? key,
    required this.label,
    required this.asyncItems,
    this.compareFn,
    this.showSearchBox,
    this.showSelectedItems,
    this.isFilterOnline,
    this.onChanged,
    this.selectedItem,
    required this.emptyText,
  }) : super(key: key);

  final String label;
  final DropdownSearchOnFind<T>? asyncItems;
  final DropdownSearchCompareFn<T>? compareFn;
  final bool? showSearchBox;
  final bool? showSelectedItems;
  final bool? isFilterOnline;
  final ValueChanged<T?>? onChanged;
  final T? selectedItem;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: key ?? UniqueKey(),
      asyncItems: asyncItems,
      compareFn: compareFn,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox ?? false,
        showSelectedItems: showSelectedItems ?? false,
        isFilterOnline: isFilterOnline ?? false,
        emptyBuilder: (context, item) => Center(child: Text(emptyText)),
      ),
      onChanged: onChanged,
      selectedItem: selectedItem,
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    this.label = 'SAVE',
    this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key ?? UniqueKey(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: const Color(0xFF007BFF),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
