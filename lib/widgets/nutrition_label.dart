import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class NutritionLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NutritionLabel({
    Key? key,
    required this.nutrients,
    this.portion,
    this.quantity,
    this.fdaRDIs,
    this.nutritionPreferences,
  }) : super(key: key);

  final Nutrients nutrients;
  final Portion? portion;
  final double? quantity;
  final Map<FDAGroup, Map<int, FdaRdi>>? fdaRDIs;
  final Map<int, Preference>? nutritionPreferences;

  Widget labelHeader(BuildContext context) {
    return Text(
      'Nutrition Facts',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.083,
      ),
    );
  }

  EdgeInsets labelMargin() {
    return const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    );
  }

  Widget labelFooter(BuildContext context) {
    return Container(
      margin: labelMargin(),
      child: Text(
        '* The % Daily Value (DV) tells you how much a nutrient contributes to '
        'a daily diet. Your nutrition preferences are used when available, '
        'otherwise 2,000 calories a day is used for general nutrition advice.',
        softWrap: true,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: MediaQuery.of(context).size.width * 0.032,
        ),
      ),
    );
  }

  Widget thinDivider({bool withIndent = false}) {
    return Divider(
      color: Colors.black,
      height: 1,
      thickness: 1,
      indent: withIndent ? 4 : 0,
      endIndent: withIndent ? 4 : 0,
    );
  }

  Widget mediumDivider() {
    return const Divider(
      color: Colors.black,
      height: 8,
      thickness: 8,
      indent: 4,
      endIndent: 4,
    );
  }

  Widget thickDivider() {
    return const Divider(
      color: Colors.black,
      height: 14,
      thickness: 14,
      indent: 4,
      endIndent: 4,
    );
  }

  TextSpan baseRowMember({
    required String value,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextSpan(
      text: value,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
    );
  }

  Widget baseRow({
    required TextSpan lvalue,
    required TextSpan rvalue,
    String prefix = '',
    TextSpan? suffix,
  }) {
    return Container(
      margin: labelMargin(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text.rich(
            TextSpan(
              text: prefix,
              children: suffix == null
                  ? <TextSpan>[lvalue]
                  : <TextSpan>[lvalue, suffix],
            ),
          ),
          Expanded(
            child: Text.rich(rvalue, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget servingsPerContainerRow(BuildContext context) {
    return baseRow(
      lvalue: baseRowMember(
        value:
            // ignore: lines_longer_than_80_chars
            '${truncateDecimal(portion!.servingsPerContainer)} servings per container',
        fontSize: MediaQuery.of(context).size.width * 0.05,
      ),
      rvalue: baseRowMember(
        value: '',
        fontSize: MediaQuery.of(context).size.width * 0.05,
      ),
    );
  }

  Widget servingSizeRow(BuildContext context) {
    return baseRow(
      lvalue: baseRowMember(
        value: 'Serving Size',
        fontSize: MediaQuery.of(context).size.width * 0.0533,
        fontWeight: FontWeight.bold,
      ),
      rvalue: baseRowMember(
        value: portion!.name,
        fontSize: MediaQuery.of(context).size.width * 0.0533,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget quantityRow(BuildContext context) {
    return baseRow(
      lvalue: baseRowMember(
        value: 'Quantity',
        fontSize: MediaQuery.of(context).size.width * 0.0533,
        fontWeight: FontWeight.bold,
      ),
      rvalue: baseRowMember(
        value: truncateDecimal(quantity),
        fontSize: MediaQuery.of(context).size.width * 0.0533,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget caloriesRow(BuildContext context) {
    return baseRow(
      lvalue: baseRowMember(
        value: nutrients.values[constants.ENERGY_NUTRIENT_ID]!.name,
        fontSize: MediaQuery.of(context).size.width * 0.07467,
        fontWeight: FontWeight.bold,
      ),
      rvalue: baseRowMember(
        value: scaleValue(
          nutrients.values[constants.ENERGY_NUTRIENT_ID]!.amount,
          nutrients.servingSize ?? 1,
          (portion?.servingSize ?? 1) * (quantity ?? 1),
        ),
        fontSize: MediaQuery.of(context).size.width * 0.07467,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget dvRow(BuildContext context) {
    return baseRow(
      lvalue: baseRowMember(
        value: '',
        fontSize: MediaQuery.of(context).size.width * 0.0373,
      ),
      rvalue: baseRowMember(
        value: '% Daily Value*',
        fontSize: MediaQuery.of(context).size.width * 0.0373,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _getNutrientPrefix(Nutrient nutrient) {
    const singleSeparator = '    ';
    const doubleSeparator = '$singleSeparator$singleSeparator';
    return constants.LABEL_SINGLE_SPACE_NUTRIENTS.contains(nutrient.id)
        ? singleSeparator
        : constants.LABEL_DOUBLE_SPACE_NUTRIENTS.contains(nutrient.id)
            ? doubleSeparator
            : '';
  }

  String _getNutrientSuffix(Nutrient nutrient) {
    final scaledAmount = scaleValue(
      nutrient.amount,
      nutrients.servingSize ?? 1,
      (portion?.servingSize ?? 1) * (quantity ?? 1),
    );
    return '  $scaledAmount${nutrient.unit}';
  }

  String _getNutrientDV(Nutrient nutrient) {
    final preferenceDV = nutritionPreferences![nutrient.id]?.thresholdValue;
    final rdiDV = fdaRDIs![FDAGroup.adult]![nutrient.id]?.value;
    final dv = preferenceDV ?? rdiDV;
    return dv == null
        ? ''
        // ignore: prefer_interpolation_to_compose_strings
        : scaleValue(
              nutrient.amount! * 100 / dv,
              nutrients.servingSize ?? 1,
              (portion?.servingSize ?? 1) * (quantity ?? 1),
              0,
            ) +
            '%';
  }

  List<Widget> nutrientRows({
    required List<int> nutrientIds,
    required BuildContext context,
  }) {
    final widgetList = <Widget>[];
    for (final nutrient in nutrientIds) {
      if (nutrients.values[nutrient]?.amount != null) {
        widgetList
          ..add(
            baseRow(
              lvalue: baseRowMember(
                value: nutrients.values[nutrient]!.name,
                fontSize: MediaQuery.of(context).size.width * 0.0373,
                fontWeight: constants.LABEL_BOLD_NUTRIENTS
                        .contains(nutrients.values[nutrient]!.id)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontStyle: constants.LABEL_ITALIC_NUTRIENTS
                        .contains(nutrients.values[nutrient]!.id)
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              rvalue: baseRowMember(
                value: _getNutrientDV(nutrients.values[nutrient]!),
                fontSize: MediaQuery.of(context).size.width * 0.0373,
                fontWeight: FontWeight.bold,
              ),
              prefix: _getNutrientPrefix(nutrients.values[nutrient]!),
              suffix: baseRowMember(
                value: _getNutrientSuffix(nutrients.values[nutrient]!),
                fontSize: MediaQuery.of(context).size.width * 0.0373,
              ),
            ),
          )
          ..add(thinDivider(withIndent: true));
      }
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      child: Column(
        children: <Widget>[
          labelHeader(context),
          thinDivider(),
          if (portion != null) ...[
            if (portion!.servingsPerContainer != null)
              servingsPerContainerRow(context),
            servingSizeRow(context),
            if ((quantity ?? 1) > 1) ...[
              thinDivider(),
              quantityRow(context),
            ],
            thickDivider(),
          ],
          caloriesRow(context),
          mediumDivider(),
          dvRow(context),
          thinDivider(withIndent: true),
          ...nutrientRows(
            nutrientIds: constants.LABEL_TOP_HALF_NUTRIENT_IDS,
            context: context,
          ),
          if (nutrients.values.entries.any(
            (entry) =>
                constants.LABEL_TOP_HALF_NUTRIENT_IDS.contains(entry.key) &&
                entry.value.amount != null,
          ))
            thickDivider(),
          ...nutrientRows(
            nutrientIds: constants.LABEL_VITAMIN_MINERAL_NUTRIENT_IDS,
            context: context,
          ),
          if (nutrients.values.entries.any(
            (entry) =>
                constants.LABEL_VITAMIN_MINERAL_NUTRIENT_IDS
                    .contains(entry.key) &&
                entry.value.amount != null,
          ))
            mediumDivider(),
          labelFooter(context),
        ],
      ),
    );
  }
}
