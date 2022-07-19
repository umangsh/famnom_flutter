import 'package:formz/formz.dart';

/// Validation errors for the [Date] [FormzInput].
enum DateValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template date}
/// Form input for a date input.
/// {@endtemplate}
class Date extends FormzInput<String, DateValidationError> {
  /// {@macro date}
  Date.pure([String value = '']) : super.pure(value);

  /// {@macro date}
  Date.dirty([String value = '']) : super.dirty(value);

  @override
  DateValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      DateTime.parse(value);
    } catch (_) {
      return DateValidationError.invalid;
    }

    return null;
  }
}
