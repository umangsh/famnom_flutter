import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:cache/cache.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart' as famnom;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template auth_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository({
    CacheClient? cache,
    famnom.FamnomApiClient? famnomApiClient,
  })  : _cache = cache ?? CacheClient(),
        _famnomApiClient = famnomApiClient ?? famnom.FamnomApiClient();

  final CacheClient _cache;
  final famnom.FamnomApiClient _famnomApiClient;

  /// Stream of [User] tracking current user in the app.
  final _controller = StreamController<User>();

  /// Close the stream controller
  void close() => _controller.close();

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Initializes the [User] stream on app launch.
  Future<void> initStream() async {
    try {
      _controller.add(await getUserFromDB());
    } catch (_) {
      _controller.add(User.empty);
    }
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user async* {
    yield* _controller.stream;
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authToken = await _famnomApiClient.loginUser(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(constants.prefAuthToken, authToken.key);

      _controller.add(await getUserFromDB());
    } on famnom.FamnomAPIException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromAPIException(e);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// SignUp with the provided [email], [password1] and [password2].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password1,
    required String password2,
  }) async {
    try {
      await _famnomApiClient.signUpUser(
        email: email,
        password1: password1,
        password2: password2,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromAPIException(e);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Gets signed in user details.
  ///
  /// Throws a [GetUserFailure] if an exception occurs.
  Future<User> getUserFromDB() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomApiUser = await _famnomApiClient.getUser(key);
      // ignore: unnecessary_null_comparison
      final user = famnomApiUser == null ? User.empty : famnomApiUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserFailure();
    }
  }

  /// Updates user details.
  ///
  /// Throws a [UpdateUserFailure] if an exception occurs.
  Future<void> updateUser(User user, [String? newFamilyMember]) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final params = <String, dynamic>{};
      if (newFamilyMember?.isNotEmpty ?? false) {
        params['newFamilyMember'] = newFamilyMember;
      }
      await _famnomApiClient.updateUser(key, user.toUser, params);
    } on famnom.FamnomAPIException catch (e) {
      throw UpdateUserFailure.fromAPIException(e);
    } catch (_) {
      throw const UpdateUserFailure();
    }
  }

  /// Signs out the current user.
  ///
  /// Throws a [LogoutFailure] if an exception occurs.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.logoutUser(key);
      _cache.delete(key: userCacheKey);
      _controller.add(User.empty);
      await prefs.clear();
    } on famnom.FamnomAPIException catch (e) {
      throw LogoutFailure.fromAPIException(e);
    } catch (_) {
      throw const LogoutFailure();
    }
  }
}

/// Conversion extension for famnom User => Auth Repository User.
extension FamnomToAuthUserConversion on famnom.User {
  /// Converter method.
  User get toUser {
    return User(
      externalId: externalId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth:
          dateOfBirth?.isEmpty ?? true ? null : DateTime.parse(dateOfBirth!),
      isPregnant: isPregnant,
      familyMembers: familyMembers,
    );
  }
}

/// Conversion extension for Auth Repository User => famnom User.
extension AuthToFamnomUserConversion on User {
  /// Converter method.
  famnom.User get toUser {
    return famnom.User(
      externalId: externalId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth == null
          ? null
          : DateFormat(constants.DATE_FORMAT).format(dateOfBirth!),
      isPregnant: isPregnant,
      familyMembers: familyMembers,
    );
  }
}
