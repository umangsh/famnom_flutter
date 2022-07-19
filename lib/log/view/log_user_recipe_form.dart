import 'package:constants/constants.dart' as constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/log/log.dart';

class LogUserRecipeForm extends StatelessWidget {
  const LogUserRecipeForm({
    Key? key,
    required this.externalId,
    this.membershipExternalId,
  }) : super(key: key);

  final String externalId;
  final String? membershipExternalId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogUserRecipeCubit, LogState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
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
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Recipe logged'),
              ),
            );
          Navigator.of(context).push(HomePage.route());
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MealTypeInput(),
          const SizedBox(height: 8),
          _MealDateInput(),
          _LogButton(
            externalId: externalId,
            membershipExternalId: membershipExternalId,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MealTypeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogUserRecipeCubit, LogState>(
      buildWhen: (previous, current) => previous.mealType != current.mealType,
      builder: (context, state) {
        return ButtonTheme(
          key: const Key('logForm_mealTypeInput_dropDownField'),
          alignedDropdown: true,
          child: DropdownButtonFormField(
            items: constants.mealTypes.map((value) {
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
            value: state.mealType.value,
            onChanged: (mealType) => context
                .read<LogUserRecipeCubit>()
                .mealTypeChanged(mealType!.toString()),
            decoration: InputDecoration(
              labelText: 'Meal type',
              helperText: '',
              errorText: state.mealType.invalid ? 'invalid meal type' : null,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        );
      },
    );
  }
}

class _MealDateInput extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogUserRecipeCubit, LogState>(
      buildWhen: (previous, current) => previous.mealDate != current.mealDate,
      builder: (context, state) {
        return TextFormField(
          key: const Key('logForm_mealDateInput_textField'),
          controller: _controller..text = state.mealDate.value,
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (mealDate) {
                      _controller.text =
                          DateFormat(constants.DATE_FORMAT).format(mealDate);
                      context
                          .read<LogUserRecipeCubit>()
                          .mealDateChanged(_controller.text);
                    },
                    initialDateTime: DateTime.now(),
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                  ),
                );
              },
            );
          },
          onChanged: (mealDate) =>
              context.read<LogUserRecipeCubit>().mealDateChanged(mealDate),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'Meal date',
            helperText: '',
            alignLabelWithHint: true,
            errorText: state.mealDate.invalid ? 'invalid date' : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        );
      },
    );
  }
}

class _LogButton extends StatelessWidget {
  const _LogButton({
    Key? key,
    required this.externalId,
    this.membershipExternalId,
  }) : super(key: key);

  final String externalId;
  final String? membershipExternalId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogUserRecipeCubit, LogState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('logForm_log_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: const Color(0xFF007BFF),
                ),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LogUserRecipeCubit>().logUserRecipe(
                              externalId: externalId,
                              membershipExternalId: membershipExternalId,
                              serving: context
                                  .read<DetailsUserRecipeCubit>()
                                  .state
                                  .selectedPortion!
                                  .externalId,
                              quantity: context
                                  .read<DetailsUserRecipeCubit>()
                                  .state
                                  .quantity,
                            );
                      }
                    : null,
                child: const Text('LOG'),
              );
      },
    );
  }
}
