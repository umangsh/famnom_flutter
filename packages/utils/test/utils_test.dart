import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';
import 'package:utils/utils.dart';

void main() {
  group('truncateDecimal', () {
    test('return empty on null', () {
      expect(truncateDecimal(null, 5), equals(''));
    });

    test('removes trailing zeroes', () {
      // ignore: prefer_int_literals
      expect(truncateDecimal(12.00, 3), equals('12'));
    });

    test('rounds to default precision', () {
      expect(truncateDecimal(12.3455), equals('12.35'));
    });

    test('rounds to provided precision', () {
      expect(truncateDecimal(12.3455, 3), equals('12.345'));
    });
  });

  group('scaleValue', () {
    test('return empty on null', () {
      expect(scaleValue(null, 5, 10), equals(''));
    });

    test('rounds to default precision', () {
      // ignore: prefer_int_literals
      expect(scaleValue(12.00, 100, 50), equals('6'));
    });
  });

  group('getFieldName', () {
    test('returns correct value', () {
      expect(getFieldName(142), equals('142'));
    });
  });

  group('getObjectFieldName', () {
    test('returns correct value', () {
      expect(
        getObjectFieldName(constants.testUUID),
        equals(constants.testUUID),
      );
    });
  });

  group('getThresholdFieldName', () {
    test('returns correct value', () {
      expect(getThresholdFieldName(142), equals('threshold_142'));
    });
  });

  group('getObjectThresholdFieldName', () {
    test('returns correct value', () {
      expect(
        getObjectThresholdFieldName(constants.testUUID),
        equals('threshold_52aa70fd-556d-46eb-acb8-40898814e83e'),
      );
    });
  });

  group('getObjectMealFieldName', () {
    test('returns correct value', () {
      expect(
        getObjectMealFieldName(constants.testUUID),
        equals('meal_52aa70fd-556d-46eb-acb8-40898814e83e'),
      );
    });
  });

  group('convertDate', () {
    test('returns correctly formatted date', () {
      expect(convertDate(date: '2022-04-04'), equals('4 Apr'));
    });

    test('returns correctly formatted date with custom format', () {
      expect(
        convertDate(date: '2022-04-04', format: 'dd MMM'),
        equals('04 Apr'),
      );
    });
  });
}
