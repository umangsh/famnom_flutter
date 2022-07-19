import 'package:auth_repository/auth_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/tracker/tracker.dart';
import 'package:famnom_flutter/widgets/user_tracker_meal.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class TrackerView extends StatefulWidget {
  const TrackerView({Key? key}) : super(key: key);

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView>
    with AutomaticKeepAliveClientMixin<TrackerView> {
  @override
  bool get wantKeepAlive => true;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final dateFormat = DateFormat(constants.DISPLAY_DATE_FORMAT);
    return BlocBuilder<TrackerCubit, TrackerState>(
      builder: (context, state) {
        switch (state.status) {
          case TrackerStatus.init:
            context.read<TrackerCubit>().getTracker(date: DateTime.now());
            return const EmptySpinner();
          case TrackerStatus.requestSubmitted:
          case TrackerStatus.requestFailure:
            return const EmptySpinner();
          case TrackerStatus.dateChanged:
          case TrackerStatus.requestSuccess:
            return RefreshIndicator(
              backgroundColor: theme.scaffoldBackgroundColor,
              color: theme.colorScheme.secondary,
              onRefresh: () {
                return context
                    .read<TrackerCubit>()
                    .getTracker(date: DateTime.now());
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Text(
                      // ignore: lines_longer_than_80_chars
                      'Welcome ${context.read<AuthRepository>().currentUser.displayName},',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: TextFormField(
                      controller: _controller
                        ..text = dateFormat.format(state.date!),
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height *
                                  0.25,
                              color: Colors.white,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (date) {
                                  _controller.text = dateFormat.format(date);
                                  context
                                      .read<TrackerCubit>()
                                      .dateChanged(date: date);
                                },
                                initialDateTime:
                                    dateFormat.parse(_controller.text),
                                minimumYear: 1900,
                                maximumYear: DateTime.now().year,
                              ),
                            );
                          },
                        );
                      },
                      onFieldSubmitted: (date) {
                        try {
                          context
                              .read<TrackerCubit>()
                              .getTracker(date: dateFormat.parse(date));
                        } catch (_) {}
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                  ),
                  if (state.nutritionPreferences == null ||
                      state.nutritionPreferences!.isEmpty)
                    EmptyResults(
                      firstLine: 'No nutrition goals found.',
                      secondLine: 'Set goals to track your health.',
                      buttonText: 'Add Goals',
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(HomePage.route(selectedTab: 1));
                      },
                    ),
                  if (state.nutritionPreferences != null &&
                      state.nutritionPreferences!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: NutritionTracker(
                        nutrients: state.tracker!.nutrients,
                        nutritionPreferences: state.nutritionPreferences,
                      ),
                    ),
                  ],
                  for (var meal in state.tracker!.meals) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: UserTrackerMeal(meal: meal),
                    ),
                  ],
                  if (state.tracker!.meals.isEmpty)
                    EmptyResults(
                      firstLine: 'No meals added yet.',
                      secondLine: 'Add your first meal for the day!',
                      buttonText: 'Add Meal',
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(EditUserMealPage.route());
                      },
                    ),
                ],
              ),
            );
        }
      },
    );
  }
}
