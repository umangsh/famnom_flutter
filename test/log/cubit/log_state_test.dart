// ignore_for_file: prefer_const_constructors
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:famnom_flutter/log/log.dart';

void main() {
  const mealType = Dropdown.dirty(constants.testMealType);
  final mealDate = Date.dirty(constants.testMealDate);

  group('LogState', () {
    test('supports value comparisons', () {
      expect(LogState(), LogState());
    });

    test('returns same object when no properties are passed', () {
      expect(LogState().copyWith(), LogState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LogState().copyWith(status: FormzStatus.pure),
        LogState(),
      );
    });

    test('returns object with updated meal type when it is passed', () {
      expect(
        LogState().copyWith(mealType: mealType),
        LogState(mealType: mealType),
      );
    });

    test('returns object with updated meal date when it is passed', () {
      expect(
        LogState().copyWith(mealDate: mealDate),
        LogState(mealDate: mealDate),
      );
    });
  });
}
