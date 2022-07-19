import 'dart:io';

import 'package:constants/constants.dart' as constants;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('FamnomApiClient', () {
    late http.Client httpClient;
    late FamnomApiClient famnomApiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
      Environment().initConfig(Environment.dev);
      dotenv.testLoad(fileInput: '''API_KEY=api_key''');
    });

    setUp(() {
      httpClient = MockHttpClient();
      famnomApiClient = FamnomApiClient(httpClient: httpClient);
      SharedPreferences.setMockInitialValues({});
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(FamnomApiClient(), isNotNull);
      });
    });

    group('login', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on invalid credentials', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn(
          '''
          {
            "non_field_errors": [
              "Unable to log in with provided credentials."
            ]
          }
          ''',
        );
        when(() => response.statusCode).thenReturn(HttpStatus.badRequest);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on unverified email', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn(
          '''
          {
            "non_field_errors": [
              "E-mail is not verified."
            ]
          }
          ''',
        );
        when(() => response.statusCode).thenReturn(HttpStatus.badRequest);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws exception on empty auth token', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.loginUser(
            email: constants.testEmail,
            password: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns AuthToken on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "key": "test_key"
          }
          ''',
        );
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        final expected = await famnomApiClient.loginUser(
          email: constants.testEmail,
          password: constants.testPassword,
        );
        expect(
          expected,
          isA<AuthToken>().having(
            (AuthToken t) => t.key,
            'key',
            constants.testAuthTokenKey,
          ),
        );
      });
    });

    group('signUpUser', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.signUpUser(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on email already exists', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn(
          '''
          {
            "email": [
              "A user is already registered with this e-mail address."
            ]
          }
          ''',
        );
        when(() => response.statusCode).thenReturn(HttpStatus.badRequest);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.signUpUser(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on common password', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn(
          '''
          {
            "password1": [
              "This password is too common."
            ]
          }
          ''',
        );
        when(() => response.statusCode).thenReturn(HttpStatus.badRequest);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.signUpUser(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-201 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.signUpUser(
            email: constants.testEmail,
            password1: constants.testPassword,
            password2: constants.testPassword,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getUser', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getUser(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getUser(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUser(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUser(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns User on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "email": "test@gmail.com"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected =
            await famnomApiClient.getUser(constants.testAuthTokenKey);
        expect(
          expected,
          isA<User>()
              .having(
                (User u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (User u) => u.email,
                'email',
                constants.testEmail,
              ),
        );
      });
    });

    group('updateUser', () {
      late User user;

      setUp(() {
        user = const User(
          externalId: constants.testUUID,
          email: constants.testEmail,
          firstName: constants.testFirstName,
          lastName: constants.testLastName,
          dateOfBirth: constants.testDateOfBirth,
          isPregnant: false,
        );
      });

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.updateUser(constants.testAuthTokenKey, user);
        } catch (_) {}
        verify(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('makes correct http request with additional params', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.updateUser(
            constants.testAuthTokenKey,
            user,
            <String, String>{'test': 'test'},
          );
        } catch (_) {}
        verify(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.updateUser('', user),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.updateUser(constants.testAuthTokenKey, user),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('logoutUser', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.logoutUser(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.logoutUser(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API Exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.logoutUser(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('search', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.search(constants.testAuthTokenKey, null, null);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API Exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.search('', null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API Exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.search(constants.testAuthTokenKey, null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns SearchResponse on valid response from requestURI',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "count": 1,
            "next": "next URL",
            "previous": "previous URL",
            "results": [{
              "external_id": "external ID",
              "dname": "name",
              "url": "url"
            }]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.search(
          constants.testAuthTokenKey,
          constants.testSearchURI,
          null,
        );
        expect(
          expected,
          isA<SearchResponse>()
              .having(
                (SearchResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (SearchResponse s) => s.next,
                'next',
                equals('next URL'),
              )
              .having(
                (SearchResponse s) => s.previous,
                'previous',
                equals('previous URL'),
              )
              .having(
                (SearchResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });

    test('returns SearchResponse on valid response from query', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(HttpStatus.ok);
      when(() => response.body).thenReturn(
        '''
          {
            "count": 1,
            "next": "next URL",
            "previous": "previous URL",
            "results": [{
              "external_id": "external ID",
              "dname": "name",
              "url": "url"
            }]
          }
          ''',
      );
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);
      final expected = await famnomApiClient.search(
        constants.testAuthTokenKey,
        null,
        constants.testQuery,
      );
      expect(
        expected,
        isA<SearchResponse>()
            .having(
              (SearchResponse s) => s.count,
              'count',
              equals(1),
            )
            .having(
              (SearchResponse s) => s.next,
              'next',
              equals('next URL'),
            )
            .having(
              (SearchResponse s) => s.previous,
              'previous',
              equals('previous URL'),
            )
            .having(
              (SearchResponse s) => s.results.length,
              'results length',
              equals(1),
            ),
      );
    });

    group('getDBFood', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getDBFood('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns DBFood on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "description": "test_db_food_name",
            "portions": [
              {
                "external_id": "${constants.testPortionExternalId}",
                "name": "${constants.testPortionName}",
                "serving_size": ${constants.testPortionSize},
                "serving_size_unit": "${constants.testPortionSizeUnit}"
              }
            ],
            "nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [
                  {
                    "id": ${constants.testNutrientId},
                    "name": "${constants.testNutrientName}",
                    "amount": ${constants.testNutrientAmount},
                    "unit": "${constants.testNutrientUnit}"
                  }
                ]
              }
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getDBFood(
          constants.testAuthTokenKey,
          constants.testUUID,
        );
        expect(
          expected,
          isA<DBFood>()
              .having(
                (DBFood u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (DBFood u) => u.description,
                'description',
                constants.testFoodName,
              ),
        );
      });
    });

    group('getUserIngredient', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getUserIngredient(
            constants.testAuthTokenKey,
            constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getUserIngredient('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserIngredient(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserIngredient(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns UserIngredientDisplay on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "display_name": "${constants.testFoodName}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getUserIngredient(
          constants.testAuthTokenKey,
          constants.testUUID,
        );
        expect(
          expected,
          isA<UserIngredientDisplay>()
              .having(
                (UserIngredientDisplay u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserIngredientDisplay u) => u.name,
                'name',
                constants.testFoodName,
              ),
        );
      });
    });

    group('getMutableUserIngredient', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMutableUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMutableUserIngredient(key: '', externalId: ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns UserIngredientMutable on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "name": "${constants.testFoodName}",
            "nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [
                  {
                    "id": ${constants.testNutrientId},
                    "name": "${constants.testNutrientName}",
                    "amount": ${constants.testNutrientAmount},
                    "unit": "${constants.testNutrientUnit}"
                  }
                ]
            }
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMutableUserIngredient(
          key: constants.testAuthTokenKey,
          externalId: constants.testUUID,
        );
        expect(
          expected,
          isA<UserIngredientMutable>()
              .having(
                (UserIngredientMutable u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserIngredientMutable u) => u.name,
                'name',
                constants.testFoodName,
              )
              .having(
                (UserIngredientMutable u) => u.nutrients.values.length,
                'nutrient values',
                equals(1),
              ),
        );
      });
    });

    group('getMutableUserRecipe', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMutableUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMutableUserRecipe(key: '', externalId: ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns UserRecipeMutable on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "${constants.testUUID}",
            "name": "${constants.testRecipeName}",
            "recipe_date": "${constants.testRecipeDate}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMutableUserRecipe(
          key: constants.testAuthTokenKey,
          externalId: constants.testUUID,
        );
        expect(
          expected,
          isA<UserRecipeMutable>()
              .having(
                (UserRecipeMutable u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserRecipeMutable u) => u.name,
                'name',
                constants.testRecipeName,
              )
              .having(
                (UserRecipeMutable u) => u.recipeDate,
                'recipe date',
                equals(constants.testRecipeDate),
              ),
        );
      });
    });

    group('getUserRecipe', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getUserRecipe(
            constants.testAuthTokenKey,
            constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getUserRecipe('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserRecipe(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserRecipe(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns UserRecipeDisplay on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "name": "${constants.testRecipeName}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getUserRecipe(
          constants.testAuthTokenKey,
          constants.testUUID,
        );
        expect(
          expected,
          isA<UserRecipeDisplay>()
              .having(
                (UserRecipeDisplay u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserRecipeDisplay u) => u.name,
                'name',
                constants.testRecipeName,
              ),
        );
      });
    });

    group('getMutableUserMeal', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMutableUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMutableUserMeal(key: '', externalId: ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMutableUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns getMutableUserMeal on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "${constants.testUUID}",
            "meal_type": "${constants.testMealType}",
            "meal_date": "${constants.testMealDate}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMutableUserMeal(
          key: constants.testAuthTokenKey,
          externalId: constants.testUUID,
        );
        expect(
          expected,
          isA<UserMealMutable>()
              .having(
                (UserMealMutable u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserMealMutable u) => u.mealType,
                'meal_type',
                constants.testMealType,
              )
              .having(
                (UserMealMutable u) => u.mealDate,
                'meal_date',
                equals(constants.testMealDate),
              ),
        );
      });
    });

    group('getUserMeal', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getUserMeal(
            constants.testAuthTokenKey,
            constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getUserMeal('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserMeal(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on empty response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getUserMeal(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns UserMealDisplay on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "external_id": "52aa70fd-556d-46eb-acb8-40898814e83e",
            "meal_type": "${constants.testMealType}",
            "meal_date": "${constants.testMealDate}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getUserMeal(
          constants.testAuthTokenKey,
          constants.testUUID,
        );
        expect(
          expected,
          isA<UserMealDisplay>()
              .having(
                (UserMealDisplay u) => u.externalId,
                'external_id',
                constants.testUUID,
              )
              .having(
                (UserMealDisplay u) => u.mealType,
                'meal type',
                constants.testMealType,
              )
              .having(
                (UserMealDisplay u) => u.mealDate,
                'meal date',
                constants.testMealDate,
              ),
        );
      });
    });

    group('getConfigNutrition', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getConfigNutrition(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getConfigNutrition(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getConfigNutrition(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns FDARDIResponse on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "results": {
              "1": {
                "123": {
                  "value": 900,
                  "threshold": "3",
                  "name": "Vitamin A",
                  "unit": "mcg"
                }
              },
              "2": {
                "345": {
                  "value": 90,
                  "threshold": "3",
                  "name": "Vitamin C",
                  "unit": "mg"
                }                
              }
            }
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient
            .getConfigNutrition(constants.testAuthTokenKey);
        expect(
          expected,
          isA<FdaRdiResponse>().having(
            (FdaRdiResponse s) => s.results.length,
            'number of RDI maps',
            equals(2),
          ),
        );
      });
    });

    group('getConfigNutritionLabel', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient
              .getConfigNutritionLabel(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getConfigNutritionLabel(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getConfigNutritionLabel(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns LabelResponse on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "results": [
              {
                "id": 900,
                "name": "Vitamin A",
                "unit": "mcg"
              },
              {
                "id": 90,
                "name": "Vitamin C",
                "unit": "mg"
              }
            ]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient
            .getConfigNutritionLabel(constants.testAuthTokenKey);
        expect(
          expected,
          isA<LabelResponse>().having(
            (LabelResponse s) => s.results.length,
            'number of nutrient labels',
            equals(2),
          ),
        );
      });
    });

    group('getAppConstants', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getAppConstants(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getAppConstants(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getAppConstants(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns LabelResponse on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "household_quantities": [
              {
                "id": "1/8",
                "name": "1/8"
              },
              {
                "id": "1/6",
                "name": "1/6"
              }
            ]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected =
            await famnomApiClient.getAppConstants(constants.testAuthTokenKey);
        expect(
          expected,
          isA<AppConstants>().having(
            (AppConstants s) => s.householdQuantities?.length,
            'number of household quantities',
            equals(2),
          ),
        );
      });
    });

    group('getNutritionPreferences', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient
              .getNutritionPreferences(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getNutritionPreferences(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getNutritionPreferences(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns list of preferences on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          [
            {
              "food_nutrient_id": 123,
              "thresholds": [
                {
                  "min_value": 90.0,
                  "max_value": null,
                  "exact_value": null
                }
              ]
            },
            {
              "food_nutrient_id": 345,
              "thresholds": [
                {
                  "min_value": null,
                  "max_value": 20.0,
                  "exact_value": null
                }
              ]
            }
          ]
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient
            .getNutritionPreferences(constants.testAuthTokenKey);
        expect(
          expected,
          isA<List<Preference>>().having(
            (List s) => s.length,
            'number of preferences',
            equals(2),
          ),
        );
      });
    });

    group('saveDBFood', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveDBFood('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('saveUserIngredient', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveUserIngredient(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveUserIngredient(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveUserIngredient(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('saveUserRecipe', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveUserRecipe(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveUserRecipe(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveUserRecipe(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('saveUserMeal', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveUserMeal(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveUserMeal(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveUserMeal(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('logDBFood', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.logDBFood(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.logDBFood(
            key: '',
            externalId: '',
            mealType: '',
            mealDate: '',
            serving: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.logDBFood(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('logUserIngredient', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.logUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.logUserIngredient(
            key: '',
            externalId: '',
            mealType: '',
            mealDate: '',
            serving: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.logUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('logUserRecipe', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.logUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.logUserRecipe(
            key: '',
            externalId: '',
            mealType: '',
            mealDate: '',
            serving: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.logUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: constants.testMealDate,
            serving: constants.testPortionExternalId,
            quantity: 4,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getMyFoods', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMyFoods(
            constants.testAuthTokenKey,
            null,
            null,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API Exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMyFoods('', null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API Exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMyFoods(constants.testAuthTokenKey, null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns MyFoodsResponse on valid response from requestURI',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "count": 1,
            "next": "next URL",
            "previous": "previous URL",
            "results": [{
              "external_id": "${constants.testUUID}",
              "display_name": "${constants.testFoodName}",
              "display_brand": {
                "brand_owner": "${constants.testBrandOwner}",
                "brand_name": "${constants.testBrandName}"
              },
              "display_portions": [{
                "external_id": "${constants.testPortionExternalId}",
                "name": "${constants.testPortionName}",
                "serving_size": ${constants.testPortionSize},
                "serving_size_unit": "${constants.testPortionSizeUnit}"
              }],
              "display_nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [{
                  "id": ${constants.testNutrientId},
                  "name": "${constants.testNutrientName}",
                  "amount": ${constants.testNutrientAmount},
                  "unit": "${constants.testNutrientUnit}"
                }]
              }
            }]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMyFoods(
          constants.testAuthTokenKey,
          constants.testSearchURI,
          null,
        );
        expect(
          expected,
          isA<MyFoodsResponse>()
              .having(
                (MyFoodsResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyFoodsResponse s) => s.next,
                'next',
                equals('next URL'),
              )
              .having(
                (MyFoodsResponse s) => s.previous,
                'previous',
                equals('previous URL'),
              )
              .having(
                (MyFoodsResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });

    test('returns MyFoods on valid response from query', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(HttpStatus.ok);
      when(() => response.body).thenReturn(
        '''
          {
            "count": 1,
            "next": "next URL",
            "previous": "previous URL",
            "results": [{
              "external_id": "${constants.testUUID}",
              "display_name": "${constants.testFoodName}",
              "display_brand": {
                "brand_owner": "${constants.testBrandOwner}",
                "brand_name": "${constants.testBrandName}"
              },
              "display_portions": [{
                "external_id": "${constants.testPortionExternalId}",
                "name": "${constants.testPortionName}",
                "serving_size": ${constants.testPortionSize},
                "serving_size_unit": "${constants.testPortionSizeUnit}"
              }],
              "display_nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [{
                  "id": ${constants.testNutrientId},
                  "name": "${constants.testNutrientName}",
                  "amount": ${constants.testNutrientAmount},
                  "unit": "${constants.testNutrientUnit}"
                }]
              }
            }]
          }
          ''',
      );
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);
      final expected = await famnomApiClient.getMyFoods(
        constants.testAuthTokenKey,
        null,
        constants.testQuery,
      );
      expect(
        expected,
        isA<MyFoodsResponse>()
            .having(
              (MyFoodsResponse s) => s.count,
              'count',
              equals(1),
            )
            .having(
              (MyFoodsResponse s) => s.next,
              'next',
              equals('next URL'),
            )
            .having(
              (MyFoodsResponse s) => s.previous,
              'previous',
              equals('previous URL'),
            )
            .having(
              (MyFoodsResponse s) => s.results.length,
              'results length',
              equals(1),
            ),
      );
    });

    group('getMyRecipes', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMyRecipes(
            constants.testAuthTokenKey,
            null,
            null,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API Exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMyRecipes('', null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API Exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMyRecipes(constants.testAuthTokenKey, null, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns MyRecipesResponse on valid response from requestURI',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "count": 1,
            "next": "next",
            "previous": "previous",
            "results": [{
              "external_id": "${constants.testUUID}",
              "name": "${constants.testRecipeName}",
              "recipe_date": "${constants.testRecipeDate}",
              "display_portions": [{
                "external_id": "${constants.testPortionExternalId}",
                "name": "${constants.testPortionName}",
                "serving_size": ${constants.testPortionSize},
                "serving_size_unit": "${constants.testPortionSizeUnit}"
              }],
              "display_nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [{
                  "id": ${constants.testNutrientId},
                  "name": "${constants.testNutrientName}",
                  "amount": ${constants.testNutrientAmount},
                  "unit": "${constants.testNutrientUnit}"
                }]
              }
            }]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMyRecipes(
          constants.testAuthTokenKey,
          constants.testSearchURI,
          null,
        );
        expect(
          expected,
          isA<MyRecipesResponse>()
              .having(
                (MyRecipesResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyRecipesResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (MyRecipesResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (MyRecipesResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });

    test('returns MyRecipesResponse on valid response from query', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(HttpStatus.ok);
      when(() => response.body).thenReturn(
        '''
          {
            "count": 1,
            "next": "next",
            "previous": "previous",
            "results": [{
              "external_id": "${constants.testUUID}",
              "name": "${constants.testRecipeName}",
              "recipe_date": "${constants.testRecipeDate}",
              "display_portions": [{
                "external_id": "${constants.testPortionExternalId}",
                "name": "${constants.testPortionName}",
                "serving_size": ${constants.testPortionSize},
                "serving_size_unit": "${constants.testPortionSizeUnit}"
              }],
              "display_nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [{
                  "id": ${constants.testNutrientId},
                  "name": "${constants.testNutrientName}",
                  "amount": ${constants.testNutrientAmount},
                  "unit": "${constants.testNutrientUnit}"
                }]
              }
            }]
          }
          ''',
      );
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);
      final expected = await famnomApiClient.getMyRecipes(
        constants.testAuthTokenKey,
        null,
        constants.testQuery,
      );
      expect(
        expected,
        isA<MyRecipesResponse>()
            .having(
              (MyRecipesResponse s) => s.count,
              'count',
              equals(1),
            )
            .having(
              (MyRecipesResponse s) => s.next,
              'next',
              equals('next'),
            )
            .having(
              (MyRecipesResponse s) => s.previous,
              'previous',
              equals('previous'),
            )
            .having(
              (MyRecipesResponse s) => s.results.length,
              'results length',
              equals(1),
            ),
      );
    });

    group('getMyMeals', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMyMeals(
            constants.testAuthTokenKey,
            null,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API Exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMyMeals('', null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API Exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMyMeals(constants.testAuthTokenKey, null),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns MyMealsResponse on valid response from requestURI',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "count": 1,
            "next": "next",
            "previous": "previous",
            "results": [{
              "external_id": "${constants.testUUID}",
              "meal_type": "${constants.testMealType}",
              "meal_date": "${constants.testMealDate}",
              "display_nutrients": {
                "serving_size": ${constants.testNutrientServingSize},
                "serving_size_unit": "${constants.testNutrientServingSizeUnit}",
                "values": [{
                  "id": ${constants.testNutrientId},
                  "name": "${constants.testNutrientName}",
                  "amount": ${constants.testNutrientAmount},
                  "unit": "${constants.testNutrientUnit}"
                }]
              }
            }]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getMyMeals(
          constants.testAuthTokenKey,
          constants.testSearchURI,
        );
        expect(
          expected,
          isA<MyMealsResponse>()
              .having(
                (MyMealsResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyMealsResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (MyMealsResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (MyMealsResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });

    group('deleteUserIngredient', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.deleteUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.deleteUserIngredient(
            key: '',
            externalId: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.deleteUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('deleteUserRecipe', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.deleteUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.deleteUserRecipe(
            key: '',
            externalId: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.deleteUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('deleteUserMeal', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.deleteUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.deleteUserMeal(
            key: '',
            externalId: '',
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.deleteUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getTracker', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getTracker(
            constants.testAuthTokenKey,
            constants.testTrackerDate,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getTracker('', ''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getTracker(
            constants.testAuthTokenKey,
            constants.testTrackerDate,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns TrackerResponse on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "display_meals": [],
            "display_nutrients": {
              "values": []
            }
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getTracker(
          constants.testAuthTokenKey,
          constants.testTrackerDate,
        );
        expect(
          expected,
          isA<TrackerResponse>()
              .having(
                (TrackerResponse s) => s.meals.length,
                'meals',
                equals(0),
              )
              .having(
                (TrackerResponse s) => s.nutrients.values.length,
                'nutrients',
                equals(0),
              ),
        );
      });
    });

    group('saveNutritionPreferences', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveNutritionPreferences(
            constants.testAuthTokenKey,
            <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveNutritionPreferences('', <String, dynamic>{}),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveNutritionPreferences(
            constants.testAuthTokenKey,
            <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getNutrientPage', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getNutrientPage(
            key: constants.testAuthTokenKey,
            nutrientId: constants.testNutrientId,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getNutrientPage(
            key: '',
            nutrientId: constants.testNutrientId,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getNutrientPage(
            key: constants.testAuthTokenKey,
            nutrientId: constants.testNutrientId,
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns TrackerResponse on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
            "id": ${constants.testNutrientId},
            "name": "${constants.testNutrientName}",
            "unit": "${constants.testNutrientUnit}",
            "description": "${constants.testNutrientDescription}"
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient.getNutrientPage(
          key: constants.testAuthTokenKey,
          nutrientId: constants.testNutrientId,
        );
        expect(
          expected,
          isA<NutrientPage>()
              .having(
                (NutrientPage s) => s.id,
                'id',
                equals(constants.testNutrientId),
              )
              .having(
                (NutrientPage s) => s.name,
                'name',
                equals(constants.testNutrientName),
              )
              .having(
                (NutrientPage s) => s.description,
                'description',
                equals(constants.testNutrientDescription),
              )
              .having(
                (NutrientPage s) => s.unit,
                'unit',
                equals(constants.testNutrientUnit),
              ),
        );
      });
    });

    group('saveMealplanFormOne', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveMealplanFormOne(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveMealplanFormOne(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveMealplanFormOne(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getMealplanFormTwo', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient.getMealplanFormTwo(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMealplanFormTwo(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMealplanFormTwo(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns list of preferences on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          [
            {
              "external_id": "${constants.testUUID}",
              "name": "${constants.testFoodName}",
              "thresholds": [
                {
                  "min_value": 90.0,
                  "max_value": null,
                  "exact_value": null
                }
              ]
            },
            {
              "external_id": "${constants.testUUID}",
              "name": "${constants.testRecipeName}",
              "thresholds": [
                {
                  "min_value": null,
                  "max_value": 20.0,
                  "exact_value": null
                }
              ]
            }
          ]
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient
            .getMealplanFormTwo(constants.testAuthTokenKey);
        expect(
          expected,
          isA<List<MealplanPreference>>().having(
            (List s) => s.length,
            'number of preferences',
            equals(2),
          ),
        );
      });
    });

    group('saveMealplanFormTwo', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveMealplanFormTwo(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveMealplanFormTwo(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveMealplanFormTwo(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });

    group('getMealplanFormThree', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        try {
          await famnomApiClient
              .getMealplanFormThree(constants.testAuthTokenKey);
        } catch (_) {}
        verify(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.getMealplanFormThree(''),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.getMealplanFormThree(constants.testAuthTokenKey),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('returns list of preferences on valid request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          '''
          {
              "infeasible": false,
              "results": [
                {
                  "external_id": "${constants.testUUID}",
                  "name": "${constants.testFoodName}",
                  "quantity": 123
                }
              ]
          }
          ''',
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        final expected = await famnomApiClient
            .getMealplanFormThree(constants.testAuthTokenKey);
        expect(
          expected,
          isA<Mealplan>().having(
            (Mealplan s) => s.infeasible,
            'infeasible',
            equals(false),
          ),
        );
      });
    });

    group('saveMealplanFormThree', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('{}');
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        try {
          await famnomApiClient.saveMealplanFormThree(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).called(1);
      });

      test('throws API exception on missing auth token', () async {
        await expectLater(
          famnomApiClient.saveMealplanFormThree(
            key: '',
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });

      test('throws API exception on non-200 response', () async {
        final response = MockResponse();
        when(() => response.body).thenReturn('{}');
        when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => response);
        await expectLater(
          famnomApiClient.saveMealplanFormThree(
            key: constants.testAuthTokenKey,
            values: <String, dynamic>{},
          ),
          throwsA(isA<FamnomAPIException>()),
        );
      });
    });
  });
}
