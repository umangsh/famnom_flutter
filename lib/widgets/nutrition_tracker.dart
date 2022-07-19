import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';
import 'package:utils/utils.dart';

// ignore: must_be_immutable
class NutritionTracker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NutritionTracker({
    Key? key,
    required this.nutrients,
    this.nutritionPreferences,
  }) : super(key: key);

  final Nutrients nutrients;
  final Map<int, Preference>? nutritionPreferences;

  late double widgetWidth;

  String _getNutrientTrackerLabel(
    double? amount,
    double? threshold,
    String? unit,
  ) {
    return '${truncateDecimal(amount ?? 0, 1)}/${truncateDecimal(threshold, 0)}$unit';
  }

  double _getNutrientTrackerRatio(
    double? amount,
    double? threshold,
  ) {
    return (amount ?? 0) / (threshold ?? 1);
  }

  String _getNutrientTrackerPercentage(
    double? amount,
    double? threshold,
  ) {
    // ignore: lines_longer_than_80_chars
    return '${truncateDecimal(_getNutrientTrackerRatio(amount, threshold) * 100, 0)}%';
  }

  @override
  Widget build(BuildContext context) {
    widgetWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        for (var item in nutrients.values.values)
          if (nutritionPreferences != null &&
              nutritionPreferences!.containsKey(item.id))
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(MyNutrientPage.route(item.id));
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: item.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: constants
                                                .LABEL_BOLD_NUTRIENTS
                                                .contains(item.id)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: _getNutrientTrackerLabel(
                                        item.amount,
                                        nutritionPreferences![item.id]!
                                            .thresholdValue,
                                        item.unit,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: _getNutrientTrackerPercentage(
                                        item.amount,
                                        nutritionPreferences![item.id]!
                                            .thresholdValue,
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              SizedBox(
                                height: 4,
                                width: widgetWidth * 0.85,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.black12,
                                  color: constants.TRACKER_NUTIRENTS_COLOR_MAP
                                          .containsKey(item.id)
                                      ? Color(
                                          constants.TRACKER_NUTIRENTS_COLOR_MAP[
                                              item.id]!,
                                        )
                                      : const Color(
                                          constants
                                              .TRACKER_NUTRTIENT_DEFAULT_COLOR,
                                        ),
                                  value: _getNutrientTrackerRatio(
                                    item.amount,
                                    nutritionPreferences![item.id]!
                                        .thresholdValue,
                                  ),
                                  semanticsLabel: item.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
      ],
    );
  }
}
