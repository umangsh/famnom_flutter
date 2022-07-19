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

  group('LogDBFoodCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(
        () => appRepository.logDBFood(
          externalId: any(named: 'externalId'),
          mealType: any(named: 'mealType'),
          mealDate: any(named: 'mealDate'),
          serving: any(named: 'serving'),
        ),
      ).thenAnswer((_) async {});
    });

    test('initial state is LogState', () {
      expect(
        LogDBFoodCubit(appRepository).state,
        LogState(
          mealType: Dropdown.pure(constants.mealTypes[0]['id']!),
          mealDate: Date.pure(
            DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
          ),
        ),
      );
    });

    group('mealTypeChanged', () {
      blocTest<LogDBFoodCubit, LogState>(
        'emits [valid] when meal type is valid',
        build: () => LogDBFoodCubit(appRepository),
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
      blocTest<LogDBFoodCubit, LogState>(
        'emits [valid] when meal date is valid',
        build: () => LogDBFoodCubit(appRepository),
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

      blocTest<LogDBFoodCubit, LogState>(
        'emits [invalid] when meal date is invalid',
        build: () => LogDBFoodCubit(appRepository),
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

    group('logDBFood', () {
      blocTest<LogDBFoodCubit, LogState>(
        'does nothing when status is not validated',
        build: () => LogDBFoodCubit(appRepository),
        act: (cubit) => cubit.logDBFood(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        expect: () => const <LogState>[],
      );

      blocTest<LogDBFoodCubit, LogState>(
        'calls logDBFood with correct fields',
        build: () => LogDBFoodCubit(appRepository),
        setUp: () {
          when(
            () => appRepository.logDBFood(
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
        act: (cubit) => cubit.logDBFood(
          externalId: constants.testUUID,
          serving: constants.testPortionExternalId,
        ),
        verify: (_) {
          verify(
            () => appRepository.logDBFood(
              externalId: constants.testUUID,
              mealDate: DateTime.parse(validMealDateString),
              mealType: validMealTypeString,
              serving: constants.testPortionExternalId,
            ),
          ).called(1);
        },
      );

      blocTest<LogDBFoodCubit, LogState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logDBFood succeeds',
        build: () => LogDBFoodCubit(appRepository),
        setUp: () {
          when(
            () => appRepository.logDBFood(
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
        act: (cubit) => cubit.logDBFood(
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

      blocTest<LogDBFoodCubit, LogState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logDBFood fails',
        setUp: () {
          when(
            () => appRepository.logDBFood(
              externalId: any(named: 'externalId'),
              mealType: any(named: 'mealType'),
              mealDate: any(named: 'mealDate'),
              serving: any(named: 'serving'),
            ),
          ).thenThrow(LogDBFoodFailure);
        },
        build: () => LogDBFoodCubit(appRepository),
        seed: () => LogState(
          status: FormzStatus.valid,
          mealDate: validMealDate,
          mealType: validMealType,
        ),
        act: (cubit) => cubit.logDBFood(
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
