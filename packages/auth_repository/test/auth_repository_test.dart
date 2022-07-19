import 'package:auth_repository/auth_repository.dart';
import 'package:cache/cache.dart';
import 'package:constants/constants.dart' as constants;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart' as famnom_api;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockFamnomApiClient extends Mock implements famnom_api.FamnomApiClient {}

class MockCacheClient extends Mock implements CacheClient {}

class MockFamnomApiUser extends Mock implements famnom_api.User {}

class MockFamnomApiAuthToken extends Mock implements famnom_api.AuthToken {}

void main() {
  const testUser = User(
    externalId: constants.testUUID,
    email: constants.testEmail,
  );

  group('AuthRepository', () {
    late CacheClient cache;
    late famnom_api.FamnomApiClient famnomApiClient;
    late AuthRepository authRepository;

    setUpAll(() {
      Environment().initConfig(Environment.dev);
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cache = MockCacheClient();
      famnomApiClient = MockFamnomApiClient();
      authRepository = AuthRepository(
        cache: cache,
        famnomApiClient: famnomApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal Cache and FamnomApiClient when not injected',
          () {
        expect(AuthRepository(), isNotNull);
      });
    });

    group('initStream', () {
      test('emits User.empty when famnom user is null', () async {
        final exception = famnom_api.getUserFailedGeneric();
        when(() => famnomApiClient.getUser(any())).thenThrow(exception);
        await authRepository.initStream();
        await expectLater(
          authRepository.user,
          emitsInOrder(const <User>[User.empty]),
        );
      });

      test('emits User when famnom user is not null', () async {
        final famnomApiUser = MockFamnomApiUser();
        when(() => famnomApiUser.externalId).thenReturn(constants.testUUID);
        when(() => famnomApiUser.email).thenReturn(constants.testEmail);
        when(() => famnomApiClient.getUser(any())).thenAnswer(
          (_) async => famnomApiUser,
        );
        await authRepository.initStream();
        await expectLater(
          authRepository.user,
          emitsInOrder(const <User>[testUser]),
        );
        verify(
          () => cache.write(key: AuthRepository.userCacheKey, value: testUser),
        ).called(1);
      });
    });

    group('user', () {
      test('emits User.empty when famnom user is null', () async {
        final exception = famnom_api.getUserFailedGeneric();
        when(() => famnomApiClient.getUser(any())).thenThrow(exception);
        await authRepository.initStream();
        await expectLater(
          authRepository.user,
          emitsInOrder(const <User>[User.empty]),
        );
      });

      test('emits User when famnom user is not null', () async {
        final famnomApiUser = MockFamnomApiUser();
        when(() => famnomApiUser.externalId).thenReturn(constants.testUUID);
        when(() => famnomApiUser.email).thenReturn(constants.testEmail);
        when(() => famnomApiClient.getUser(any())).thenAnswer(
          (_) async => famnomApiUser,
        );
        await authRepository.initStream();
        await expectLater(
          authRepository.user,
          emitsInOrder(const <User>[testUser]),
        );
        verify(
          () => cache.write(
            key: AuthRepository.userCacheKey,
            value: testUser,
          ),
        ).called(1);
      });
    });

    group('currentUser', () {
      test('returns User.empty when cached user is null', () {
        when(
          () => cache.read<User>(key: AuthRepository.userCacheKey),
        ).thenReturn(null);
        expect(
          authRepository.currentUser,
          equals(User.empty),
        );
      });

      test('returns User when cached user is not null', () async {
        when(
          () => cache.read<User>(key: AuthRepository.userCacheKey),
        ).thenReturn(testUser);
        expect(authRepository.currentUser, equals(testUser));
      });
    });

    group('logInWithEmailAndPassword', () {
      test('calls with email and password', () async {
        final authToken = MockFamnomApiAuthToken();
        when(() => authToken.key).thenReturn(constants.testAuthTokenKey);
        when(
          () => famnomApiClient.loginUser(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => authToken,
        );

        final famnomApiUser = MockFamnomApiUser();
        when(() => famnomApiUser.externalId).thenReturn(constants.testUUID);
        when(() => famnomApiUser.email).thenReturn(constants.testEmail);
        when(() => famnomApiClient.getUser(constants.testAuthTokenKey))
            .thenAnswer(
          (_) async => famnomApiUser,
        );

        try {
          await authRepository.logInWithEmailAndPassword(
            email: constants.testEmail,
            password: constants.testPassword,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
        ).called(1);
      });

      test('throws when login fails', () async {
        final exception = famnom_api.unableToLogInWithCredentials();
        when(
          () => famnomApiClient.loginUser(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.logInWithEmailAndPassword(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogInWithEmailAndPasswordFailure &&
                  x.message == 'Login failed. Check your username / password.',
            ),
          ),
        );
      });

      test('throws when login response is non-200', () async {
        final exception = famnom_api.loginFailedGeneric();
        when(
          () => famnomApiClient.loginUser(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.logInWithEmailAndPassword(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogInWithEmailAndPasswordFailure &&
                  x.message == 'Login request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when login response malformed', () async {
        final exception = famnom_api.authTokenNotFound();
        when(
          () => famnomApiClient.loginUser(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.logInWithEmailAndPassword(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogInWithEmailAndPasswordFailure &&
                  x.message == 'Login request failed. Please try again later.',
            ),
          ),
        );
      });

      test('returns correct token on success', () async {
        final authToken = MockFamnomApiAuthToken();
        when(() => authToken.key).thenReturn(constants.testAuthTokenKey);
        when(
          () => famnomApiClient.loginUser(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => authToken,
        );

        final famnomApiUser = MockFamnomApiUser();
        when(() => famnomApiUser.externalId).thenReturn(constants.testUUID);
        when(() => famnomApiUser.email).thenReturn(constants.testEmail);
        when(() => famnomApiClient.getUser(constants.testAuthTokenKey))
            .thenAnswer(
          (_) async => famnomApiUser,
        );

        await authRepository.logInWithEmailAndPassword(
          email: constants.testEmail,
          password: constants.testPassword,
        );
        final prefs = await SharedPreferences.getInstance();
        final key = prefs.getString(constants.prefAuthToken);
        expect(key, authToken.key);
      });
    });

    group('signUpWithEmailAndPassword', () {
      test('calls with email, password1 and password2', () async {
        try {
          await authRepository.signUpWithEmailAndPassword(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.signUpUser(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
        ).called(1);
      });

      test('throws when signup email exists', () async {
        final exception = famnom_api.signupEmailExists();
        when(
          () => famnomApiClient.signUpUser(
            email: any(named: 'email'),
            password1: any(named: 'password1'),
            password2: any(named: 'password2'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.signUpWithEmailAndPassword(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is SignUpWithEmailAndPasswordFailure &&
                  x.message ==
                      'Email already registered, please login with your email/password.',
            ),
          ),
        );
      });

      test('throws when signup common password', () async {
        final exception = famnom_api.signupCommonPassword();
        when(
          () => famnomApiClient.signUpUser(
            email: any(named: 'email'),
            password1: any(named: 'password1'),
            password2: any(named: 'password2'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.signUpWithEmailAndPassword(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is SignUpWithEmailAndPasswordFailure &&
                  x.message ==
                      'Password is too common, please choose a '
                          'different password.',
            ),
          ),
        );
      });

      test('throws when signup fails', () async {
        final exception = famnom_api.signupFailedGeneric();
        when(
          () => famnomApiClient.signUpUser(
            email: any(named: 'email'),
            password1: any(named: 'password1'),
            password2: any(named: 'password2'),
          ),
        ).thenThrow(exception);
        expect(
          () async => authRepository.signUpWithEmailAndPassword(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is SignUpWithEmailAndPasswordFailure &&
                  x.message == 'SignUp request failed. Please try again later.',
            ),
          ),
        );
      });
    });

    group('getUserFromDB', () {
      test('calls with key', () async {
        try {
          await authRepository.getUserFromDB();
        } catch (_) {}
        verify(
          () => famnomApiClient.getUser(any()),
        ).called(1);
      });

      test('throws when user request fails', () async {
        final exception = famnom_api.getUserFailedGeneric();
        when(() => famnomApiClient.getUser(any())).thenThrow(exception);
        expect(
          () async => authRepository.getUserFromDB(),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserFailure &&
                  x.message ==
                      'Can not find requested user. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getUser(any())).thenThrow(exception);
        expect(
          () async => authRepository.getUserFromDB(),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user not found', () async {
        final exception = famnom_api.userNotFound();
        when(() => famnomApiClient.getUser(any())).thenThrow(exception);
        expect(
          () async => authRepository.getUserFromDB(),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserFailure &&
                  x.message == 'User not found. Please try again.',
            ),
          ),
        );
      });

      test('returns correct user on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        final famnomApiUser = MockFamnomApiUser();
        when(() => famnomApiUser.externalId).thenReturn(constants.testUUID);
        when(() => famnomApiUser.email).thenReturn(constants.testEmail);
        when(() => famnomApiClient.getUser(constants.testAuthTokenKey))
            .thenAnswer(
          (_) async => famnomApiUser,
        );

        final user = await authRepository.getUserFromDB();
        expect(user, equals(testUser));
      });
    });

    group('updateUser', () {
      test('calls with key', () async {
        try {
          await authRepository.updateUser(testUser);
        } catch (_) {}
        verify(
          () => famnomApiClient
              .updateUser(any(), testUser.toUser, <String, String>{}),
        ).called(1);
      });

      test('calls with key and extra params', () async {
        try {
          await authRepository.updateUser(testUser, 'test');
        } catch (_) {}
        verify(
          () => famnomApiClient.updateUser(
            any(),
            testUser.toUser,
            <String, String>{'newFamilyMember': 'test'},
          ),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.updateUserFailedGeneric();
        when(
          () => famnomApiClient
              .updateUser(any(), testUser.toUser, <String, String>{}),
        ).thenThrow(exception);
        expect(
          () async => authRepository.updateUser(testUser),
          throwsA(
            predicate(
              (x) =>
                  x is UpdateUserFailure &&
                  x.message ==
                      'Can not update requested user. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient
              .updateUser(any(), testUser.toUser, <String, String>{}),
        ).thenThrow(exception);
        expect(
          () async => authRepository.updateUser(testUser),
          throwsA(
            predicate(
              (x) =>
                  x is UpdateUserFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('logout', () {
      test('calls with key', () async {
        try {
          await authRepository.logout();
        } catch (_) {}
        verify(
          () => famnomApiClient.logoutUser(any()),
        ).called(1);
      });

      test('throws when logout request fails', () async {
        final exception = famnom_api.logoutFailedGeneric();
        when(() => famnomApiClient.logoutUser(any())).thenThrow(exception);
        expect(
          () async => authRepository.logout(),
          throwsA(
            predicate(
              (x) =>
                  x is LogoutFailure &&
                  x.message == 'Logout request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.logoutUser(any())).thenThrow(exception);
        expect(
          () async => authRepository.logout(),
          throwsA(
            predicate(
              (x) =>
                  x is LogoutFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('FamnomToAuthUserConversion.toUser', () {
      test('converts famnom User to auth_repository User success', () {
        const famnomApiUser = famnom_api.User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: constants.testDateOfBirth,
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        final authUser = User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: DateTime.parse(constants.testDateOfBirth),
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        expect(
          famnomApiUser.toUser,
          equals(authUser),
        );
      });

      test('converts famnom User to auth_repository User empty date of birth',
          () {
        const famnomApiUser = famnom_api.User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: '',
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        const authUser = User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        expect(
          famnomApiUser.toUser,
          equals(authUser),
        );
      });
    });

    group('AuthToFamnomUserConversion.toUser', () {
      test('converts auth_repository User to famnom User success', () {
        final authUser = User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: DateTime.parse(constants.testDateOfBirth),
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        const famnomApiUser = famnom_api.User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: constants.testDateOfBirth,
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        expect(
          authUser.toUser,
          equals(famnomApiUser),
        );
      });

      test('converts famnom User to auth_repository User empty date of birth',
          () {
        const authUser = User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        const famnomApiUser = famnom_api.User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          isPregnant: true,
          familyMembers: constants.testFamilyMembers,
        );

        expect(
          authUser.toUser,
          equals(famnomApiUser),
        );
      });
    });
  });
}
