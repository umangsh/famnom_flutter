import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/goals/goals.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:utils/utils.dart';

class GoalsForm extends StatelessWidget {
  const GoalsForm({Key? key}) : super(key: key);

  String _getNutrientLabel(
    GoalsState state,
    FDAGroup fdaGroup,
    int nutrientId,
  ) {
    final name = state.fdaRDIs![FDAGroup.adult]![nutrientId]!.name;
    final unit = state.fdaRDIs![FDAGroup.adult]![nutrientId]!.unit;
    return '$name ($unit)';
  }

  List<Widget> _getFormRows(User currentUser, GoalsState state) {
    var fdaGroup = FDAGroup.adult;
    if (currentUser.isPregnant ?? false) {
      fdaGroup = FDAGroup.pregnant;
    } else {
      final dateOfBirth = currentUser.dateOfBirth;
      if (dateOfBirth != null) {
        final difference = DateTime.now().difference(dateOfBirth);
        if (difference.inDays < 365) {
          // 12 months
          fdaGroup = FDAGroup.infant;
        } else if (difference.inDays < 1460) {
          // up to 4 years
          fdaGroup = FDAGroup.children;
        }
      }
    }

    final returnValue = <Widget>[];
    for (final nutrientId in state.fdaRDIs![fdaGroup]!.keys) {
      if (constants.LOW_COVERAGE_NUTRIENT_IDS.contains(nutrientId)) {
        continue;
      }

      /// Initialize state.formValues
      final thresholdInitialValue = state.status == GoalsStatus.populateDefaults
          ? state.fdaRDIs?[fdaGroup]?[nutrientId]?.thresholdType ?? ''
          : state.nutritionPreferences?[nutrientId]?.thresholdType ?? '';
      state.formValues[getThresholdFieldName(nutrientId)] =
          thresholdInitialValue;

      final amountInitialValue = state.status == GoalsStatus.populateDefaults
          ? '${state.fdaRDIs?[fdaGroup]?[nutrientId]?.value ?? ""}'
          // ignore: lines_longer_than_80_chars
          : '${state.nutritionPreferences?[nutrientId]?.thresholdValue ?? ""}';
      state.formValues[getFieldName(nutrientId)] = amountInitialValue;

      returnValue.addAll(
        [
          Row(
            children: [
              Text(
                _getNutrientLabel(state, fdaGroup, nutrientId),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ThresholdInput(
                nutrientId: nutrientId,
                initialValue: thresholdInitialValue,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: _AmountInput(
                  nutrientId: nutrientId,
                  initialValue: amountInitialValue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15)
        ],
      );
    }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<GoalsCubit, GoalsState>(
        listener: (context, state) {
          if (state.status == GoalsStatus.requestFailure) {
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

          if (state.status == GoalsStatus.populateDefaults) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Goals updated with FDA RDI recommendations. '
                    'Tap UPDATE to save.',
                  ),
                ),
              );
          }

          if (state.status == GoalsStatus.submissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Goals updated.'),
                ),
              );
          }
        },
        child: BlocBuilder<GoalsCubit, GoalsState>(
          builder: (context, state) {
            switch (state.status) {
              case GoalsStatus.init:
                context.read<GoalsCubit>().loadPageData();
                return const EmptySpinner();
              case GoalsStatus.requestFailure:
              case GoalsStatus.submissionSubmitted:
                return const EmptySpinner();
              case GoalsStatus.requestSubmitted:
              case GoalsStatus.requestSuccess:
              case GoalsStatus.populateDefaults:
              case GoalsStatus.submissionSuccess:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context.read<GoalsCubit>().refreshPage();
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(0, -1 / 3),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const Text(
                                'Daily Nutrition Goals',
                                softWrap: true,
                                style: TextStyle(fontSize: 30),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ..._getFormRows(
                                    context.read<AuthRepository>().currentUser,
                                    state,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 16,
                        child: _UpdateButton(),
                      ),
                      Positioned(
                        right: 24,
                        bottom: 19,
                        child: SizedBox(
                          width: 140,
                          child: FittedBox(
                            child: FloatingActionButton.extended(
                              onPressed:
                                  context.read<GoalsCubit>().populateDefaults,
                              autofocus: true,
                              focusElevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              tooltip: 'Fill FDA recommendations',
                              backgroundColor: theme.primaryColor,
                              icon: const Icon(Icons.edit_note),
                              label: const Text('FDA RDIs'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _ThresholdInput extends StatelessWidget {
  const _ThresholdInput({
    Key? key,
    required this.nutrientId,
    required this.initialValue,
  }) : super(key: key);

  final int nutrientId;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        return SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              items: constants.thresholdTypes.map((value) {
                return DropdownMenuItem(
                  value: value['id'],
                  child: Text.rich(
                    TextSpan(text: value['name']),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              isExpanded: true,
              isDense: false,
              menuMaxHeight: 250,
              value: initialValue,
              onChanged: (value) {
                state.formValues[getThresholdFieldName(nutrientId)] = value;
              },
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
            ),
          ),
        );
      },
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    Key? key,
    required this.nutrientId,
    required this.initialValue,
  }) : super(key: key);

  final int nutrientId;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        return TextFormField(
          controller: TextEditingController()..text = initialValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11),
          ),
          onChanged: (value) {
            state.formValues[getFieldName(nutrientId)] = value;
          },
        );
      },
    );
  }
}

class _UpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('goalsForm_update_raisedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: const Color(0xFF007BFF),
          ),
          onPressed: () {
            context.read<GoalsCubit>().saveGoals();
          },
          child: const Text('UPDATE'),
        );
      },
    );
  }
}
