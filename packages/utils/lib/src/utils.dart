import 'package:intl/intl.dart';

/// Round double [value] to [precision] digits after decimal.
/// 12.000 => 12
/// 12.34555, 2 => 12.35
String truncateDecimal(double? value, [int precision = 2]) {
  if (value == null) {
    return '';
  }

  return value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : precision);
}

/// Scale double [value] from [baseScale] to [newScale], and round result to
/// [precision] digits after decimal.
/// scaleValue(12.00, 100, 50, 1) => 6.0
String scaleValue(
  double? value,
  double baseScale,
  double newScale, [
  int precision = 2,
]) {
  if (value == null) {
    return '';
  }

  final scaledValue = (value * newScale) / baseScale;
  return truncateDecimal(scaledValue, precision);
}

/// Get field name for a given nutrient.
String getFieldName(int nutrientId) {
  return '$nutrientId';
}

/// Get field name for a given object.
String getObjectFieldName(String externalId) {
  return externalId;
}

/// Get threshold field name for a given nutrient.
String getThresholdFieldName(int nutrientId) {
  return 'threshold_$nutrientId';
}

/// Get threshold field name for a given object.
String getObjectThresholdFieldName(String externalId) {
  return 'threshold_$externalId';
}

/// Get meal field name for a given object.
String getObjectMealFieldName(String externalId) {
  return 'meal_$externalId';
}

/// Convert date format from YYYY-MM-DD to custom format.
String convertDate({
  required String date,
  String format = 'd MMM',
}) {
  return DateFormat(format).format(DateTime.parse(date));
}
