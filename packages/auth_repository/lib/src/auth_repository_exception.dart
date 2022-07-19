import 'package:famnom_api/famnom_api.dart' as famnom;

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory LogInWithEmailAndPasswordFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return LogInWithEmailAndPasswordFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SignUpWithEmailAndPasswordFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SignUpWithEmailAndPasswordFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_user_failure}
/// Thrown during the user fetch process if a failure occurs.
/// {@endtemplate}
class GetUserFailure implements Exception {
  /// {@macro get_user_failure}
  const GetUserFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetUserFailure.fromAPIException(famnom.FamnomAPIException e) {
    return GetUserFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template update_user_failure}
/// Thrown during the user update process if a failure occurs.
/// {@endtemplate}
class UpdateUserFailure implements Exception {
  /// {@macro update_user_failure}
  const UpdateUserFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory UpdateUserFailure.fromAPIException(famnom.FamnomAPIException e) {
    return UpdateUserFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template logout_failure}
/// Thrown during the user logout process if a failure occurs.
/// {@endtemplate}
class LogoutFailure implements Exception {
  /// {@macro logout_failure}
  const LogoutFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory LogoutFailure.fromAPIException(famnom.FamnomAPIException e) {
    return LogoutFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}
