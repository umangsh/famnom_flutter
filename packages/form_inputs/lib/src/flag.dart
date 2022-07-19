import 'package:formz/formz.dart';

/// Validation errors for the [Flag] [FormzInput].
enum FlagValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template flag}
/// Form input for a flag input (Yes/No).
/// {@endtemplate}
class Flag extends FormzInput<String?, FlagValidationError> {
  /// {@macro flag}
  const Flag.pure([String value = '']) : super.pure(value);

  /// {@macro flag}
  const Flag.dirty([String value = '']) : super.dirty(value);

  @override
  FlagValidationError? validator(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.toLowerCase() == 'yes' ||
        value.toLowerCase() == 'no') {
      return null;
    }

    return FlagValidationError.invalid;
  }
}
