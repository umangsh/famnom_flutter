// ignore_for_file: prefer_const_constructors
import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/log/log.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const validMealTypeString = constants.testMealType;
  const validMealType = Dropdown.dirty(validMealTypeString);

  const validMealDateString = constants.testMealDate;
  final validMealDate = Date.dirty(validMealDateString);

  const invalidMealDateString = 'invalid';
  final invalidMealDate = Date.dirty(invalidMealDateString);

  group('LogUserIngredientCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(
        () => appRepository.logUserIngredient(
          externalId: any(named: 'externalId'),
          mealType: any(named: 'mealType'),
          mealDate: any(named: 'mealDate'),
          serving: any(named: 'serving'),
        ),
      ).thenAnswer((_) async {});
    });

    test('initial state is LogState', () {
      expect(
        LogUserIngredientCubit(appRepository: appRepository).state,
        LogState(
          mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
          mealDate: Date.pure(
            DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
          ),
        ),
      );
    });

    group('mealTypeChanged', () {
      blocTest<LogUserIngredientCubit, LogState>(
        'emits [valid] when meal type is valid',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        seed: () => LogState(mealType: validMealType),
        act: (cubit) => cubit.mealTypeChanged(validMealTypeString),
        expect: () => <LogState>[
          LogState(
            mealType: validMealType,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('mealDateChanged', () {
      blocTest<LogUserIngredientCubit, LogState>(
        'emits [valid] when meal date is valid',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        seed: () => LogState(
          mealType: validMealType,
          mealDate: validMealDate,
        ),
        act: (cubit) => cubit.mealDateChanged(validMealDateString),
        expect: () => <LogState>[
          LogState(
            mealType: validMealType,
            mealDate: validMealDate,
            status: FormzStatus.valid,
          ),
        ],
      );

      blocTest<LogUserIngredientCubit, LogState>(
        'emits [invalid] when meal date is invalid',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        seed: () => LogState(
          mealType: validMealType,
          mealDate: invalidMealDate,
        ),
        act: (cubit) => cubit.mealDateChanged(invalidMealDateString),
        expect: () => <LogState>[
          LogState(
            mealType: validMealType,
            mealDate: invalidMealDate,
            status: FormzStatus.invalid,
          ),
        ],
      );
    });

    group('logUserIngredient', () {
      blocTest<LogUserIngredientCubit, LogState>(
        'does nothing when status is not validated',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        act: (cubit) => cubit.logUserIngredient(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        expect: () => const <LogState>[],
      );

      blocTest<LogUserIngredientCubit, LogState>(
        'calls logUserIngredient with correct fields',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        setUp: () {
          when(
            () => appRepository.logUserIngredient(
              externalId: any(named: 'externalId'),
              mealType: any(named: 'mealType'),
              mealDate: any(named: 'mealDate'),
              serving: any(named: 'serving'),
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => LogState(
          status: FormzStatus.valid,
          mealDate: validMealDate,
          mealType: validMealType,
        ),
        act: (cubit) => cubit.logUserIngredient(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        verify: (_) {
          verify(
            () => appRepository.logUserIngredient(
              externalId: constants.testUUID,
              mealDate: DateTime.parse(validMealDateString),
              mealType: validMealTypeString,
              serving: constants.testPortionExternalId,
            ),
          ).called(1);
        },
      );

      blocTest<LogUserIngredientCubit, LogState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logUserIngredient succeeds',
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        setUp: () {
          when(
            () => appRepository.logUserIngredient(
              externalId: any(named: 'externalId'),
              mealType: any(named: 'mealType'),
              mealDate: any(named: 'mealDate'),
              serving: any(named: 'serving'),
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => LogState(
          status: FormzStatus.valid,
          mealDate: validMealDate,
          mealType: validMealType,
        ),
        act: (cubit) => cubit.logUserIngredient(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        expect: () => <LogState>[
          LogState(
            status: FormzStatus.submissionInProgress,
            mealDate: validMealDate,
            mealType: validMealType,
          ),
          LogState(
            status: FormzStatus.submissionSuccess,
            mealDate: validMealDate,
            mealType: validMealType,
          )
        ],
      );

      blocTest<LogUserIngredientCubit, LogState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logUserIngredient fails',
        setUp: () {
          when(
            () => appRepository.logUserIngredient(
              externalId: any(named: 'externalId'),
              mealType: any(named: 'mealType'),
              mealDate: any(named: 'mealDate'),
              serving: any(named: 'serving'),
            ),
          ).thenThrow(LogUserIngredientFailure);
        },
        build: () => LogUserIngredientCubit(appRepository: appRepository),
        seed: () => LogState(
          status: FormzStatus.valid,
          mealDate: validMealDate,
          mealType: validMealType,
        ),
        act: (cubit) => cubit.logUserIngredient(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        expect: () => <LogState>[
          LogState(
            status: FormzStatus.submissionInProgress,
            mealDate: validMealDate,
            mealType: validMealType,
          ),
          LogState(
            status: FormzStatus.submissionFailure,
            mealDate: validMealDate,
            mealType: validMealType,
          )
        ],
      );
    });
  });
}
