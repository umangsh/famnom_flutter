import 'package:formz/formz.dart';

/// Validation errors for the [Dropdown] [FormzInput].
enum DropdownValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template dropdown}
/// Form input for a dropdown input.
/// {@endtemplate}
class Dropdown extends FormzInput<String, DropdownValidationError> {
  /// {@macro dropdown}
  const Dropdown.pure([String value = '']) : super.pure(value);

  /// {@macro dropdown}
  const Dropdown.dirty([String value = '']) : super.dirty(value);

  @override
  DropdownValidationError? validator(String? value) {
    if (value == '') {
      return DropdownValidationError.invalid;
    }

    return null;
  }
}
