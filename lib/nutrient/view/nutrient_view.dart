import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_element.dart' as charts_text;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_style.dart' as charts_style;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utils/utils.dart';

const nutrientKey = 'NutrientsPerDay';
const thresholdKey = 'ThresholdPerDay';

class DayValue {
  const DayValue(this.day, this.value);

  final String day;
  final double? value;
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static Map<String, String?> values = {};

  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    charts.Color? fillColor,
    charts.FillPatternType? fillPattern,
    charts.Color? strokeColor,
    double? strokeWidthPx,
  }) {
    super.paint(
      canvas,
      bounds,
      dashPattern: dashPattern,
      fillColor: fillColor,
      fillPattern: fillPattern,
      strokeColor: strokeColor,
      strokeWidthPx: strokeWidthPx,
    );
    canvas.drawRect(
      Rectangle(
        bounds.left - 5,
        bounds.top - 30,
        bounds.width + 10,
        bounds.height + 10,
      ),
      fill: charts.Color.white,
    );

    final textStyle = charts_style.TextStyle()
      ..color = charts.Color.black
      ..fontSize = 15;
    canvas.drawText(
      charts_text.TextElement(
        '${values[nutrientKey]} / ${values[thresholdKey]}',
        style: textStyle,
      ),
      (bounds.left).round(),
      (bounds.top - 28).round(),
    );
  }
}

class NutrientView extends StatefulWidget {
  const NutrientView({Key? key, required this.nutrientId}) : super(key: key);

  final int nutrientId;

  @override
  State<NutrientView> createState() => _NutrientViewState();
}

class _NutrientViewState extends State<NutrientView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const MyAppBar(showLogo: false),
      body: BlocListener<NutrientCubit, NutrientState>(
        listener: (context, state) {
          if (state.status == NutrientStatus.requestFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    state.errorMessage ??
                        'Something went wrong, please try again.',
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<NutrientCubit, NutrientState>(
          builder: (context, state) {
            switch (state.status) {
              case NutrientStatus.init:
                context.read<NutrientCubit>().fetchData(
                      nutrientId: widget.nutrientId,
                    );
                return const EmptySpinner();
              case NutrientStatus.requestSubmitted:
              case NutrientStatus.requestFailure:
                return const EmptySpinner();
              case NutrientStatus.requestSuccess:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context.read<NutrientCubit>().fetchData(
                          nutrientId: widget.nutrientId,
                        );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    children: <Widget>[
                      /// Food name.
                      Text(
                        state.nutrientPage!.name,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Nutrient chart.
                      SizedBox(
                        width: 200,
                        height: 300,
                        child: charts.OrdinalComboChart(
                          [
                            charts.Series<DayValue, String>(
                              id: nutrientKey,
                              colorFn: (_, __) =>
                                  charts.ColorUtil.fromDartColor(
                                theme.colorScheme.secondary,
                              ),
                              domainFn: (DayValue dayValue, _) => dayValue.day,
                              measureFn: (DayValue dayValue, _) =>
                                  dayValue.value,
                              data: state.nutrientPage!.amountPerDay!.entries
                                  .map(
                                    (entry) => DayValue(
                                      convertDate(date: entry.key),
                                      entry.value ?? 0,
                                    ),
                                  )
                                  .toList(),
                            ),
                            charts.Series<DayValue, String>(
                              id: thresholdKey,
                              colorFn: (_, __) =>
                                  charts.MaterialPalette.green.shadeDefault,
                              domainFn: (DayValue dayValue, _) => dayValue.day,
                              measureFn: (DayValue dayValue, _) =>
                                  dayValue.value,
                              data: state.nutrientPage!.amountPerDay!.entries
                                  .map(
                                    (entry) => DayValue(
                                      convertDate(date: entry.key),
                                      state.nutrientPage!.threshold,
                                    ),
                                  )
                                  .toList(),
                            )
                              // Configure our custom line renderer.
                              ..setAttribute(
                                charts.rendererIdKey,
                                'customLine',
                              ),
                          ],
                          behaviors: [
                            charts.LinePointHighlighter(
                              showHorizontalFollowLine: charts
                                  .LinePointHighlighterFollowLineType.none,
                              showVerticalFollowLine:
                                  charts.LinePointHighlighterFollowLineType.all,
                              symbolRenderer: CustomCircleSymbolRenderer(),
                            ),
                            charts.SelectNearest(
                              eventTrigger: charts.SelectionTrigger.tapAndDrag,
                            ),
                            charts.DomainHighlighter(),
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                              changedListener: (charts.SelectionModel model) {
                                final selectedDatum = model.selectedDatum;
                                final values = <String, String?>{};
                                if (selectedDatum.isNotEmpty) {
                                  for (final datumPair in selectedDatum) {
                                    values[datumPair.series.id] =
                                        truncateDecimal(
                                              (datumPair.datum as DayValue)
                                                  .value,
                                            ) +
                                            state.nutrientPage!.unit!;
                                  }
                                  CustomCircleSymbolRenderer.values = values;
                                }
                              },
                            )
                          ],
                          animate: true,
                          customSeriesRenderers: [
                            charts.LineRendererConfig(
                              customRendererId: 'customLine',
                              includePoints: true,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recent Foods
                      if (state.nutrientPage!.recentLfoods != null &&
                          state.nutrientPage!.recentLfoods!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Recent Foods',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...state.nutrientPage!.recentLfoods!
                            .map(
                              (result) => [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                  child: UserIngredientRowWidget(
                                    result: result,
                                    onTap: (query) {
                                      Navigator.of(context).push(
                                        DetailsUserIngredientPage.route(
                                          externalId: result.externalId,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (result !=
                                    state.nutrientPage!.recentLfoods!.last)
                                  Divider(
                                    color: theme.colorScheme.secondary,
                                    indent: 6,
                                    endIndent: 6,
                                  )
                              ],
                            )
                            .expand((i) => i)
                            .toList(),
                      ],

                      // Top CFoods
                      if (state.nutrientPage!.topCfoods != null &&
                          state.nutrientPage!.topCfoods!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'From food database',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...state.nutrientPage!.topCfoods!
                            .map(
                              (result) => [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 6, 10, 6),
                                  child: DBFoodRowWidget(
                                    result: result,
                                    onTap: (query) {
                                      Navigator.of(context).push(
                                        DetailsDBFoodPage.route(
                                          result.externalId,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (result !=
                                    state.nutrientPage!.topCfoods!.last)
                                  Divider(
                                    color: theme.colorScheme.secondary,
                                    indent: 6,
                                    endIndent: 8,
                                  )
                              ],
                            )
                            .expand((i) => i)
                            .toList(),
                      ],

                      if (state.nutrientPage!.description != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
                          child: Text(
                            state.nutrientPage!.description!,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (state.nutrientPage!.wikipediaUrl != null) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final url = state.nutrientPage!.wikipediaUrl!;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(8, 6, 10, 6),
                              child: Text(
                                'Read more on Wikipedia',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF007BFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],

                      /// Space at bottom.
                      const SizedBox(height: 16),
                    ],
                  ),
                );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomBar(
        onTap: (index) async {
          await Navigator.of(context).push(HomePage.route(selectedTab: index));
        },
      ),
    );
  }
}
