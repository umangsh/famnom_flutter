import 'dart:io' show Platform;
import 'package:auth_repository/auth_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:healthkit/healthkit.dart';
import 'package:intl/intl.dart';
import 'package:famnom_flutter/profile/profile.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  ProfileStateClass createState() => ProfileStateClass();
}

class ProfileStateClass extends State<ProfileForm> {
  bool appleHealthConnectInProgress = false;
  bool appleHealthConnectSuccess = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<ProfileCubit, ProfileState>(
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
                  content: Text('Profile updated.'),
                ),
              );
          }
        },
        child: RefreshIndicator(
          backgroundColor: theme.scaffoldBackgroundColor,
          color: theme.colorScheme.secondary,
          onRefresh: () {
            return context.read<ProfileCubit>().refreshPage();
          },
          child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (constants.enableWritesToAppleHealth &&
                          Platform.isIOS) ...[
                        const SizedBox(height: 8),
                        FutureBuilder<bool>(
                          future: isAuthorized(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
                                if (snapshot.data == null) {
                                  return ElevatedButton.icon(
                                    icon: const Icon(Icons.apple),
                                    label: const Text(
                                      'Apple Health not available',
                                    ),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      primary: Colors.black26,
                                    ),
                                  );
                                } else if (snapshot.data!) {
                                  return ElevatedButton.icon(
                                    icon: const Icon(Icons.apple),
                                    label: const Text('Apple Health connected'),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      primary: const Color(0xFF007BFF),
                                    ),
                                  );
                                } else {
                                  return appleHealthConnectSuccess
                                      ? ElevatedButton.icon(
                                          icon: const Icon(Icons.apple),
                                          label: const Text(
                                            'Apple Health connected',
                                          ),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            primary: const Color(0xFF007BFF),
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          icon: const Icon(Icons.apple),
                                          label: appleHealthConnectInProgress
                                              ? const Text('Connecting ...')
                                              : const Text(
                                                  'Connect Apple Health',
                                                ),
                                          onPressed: () async {
                                            setState(() {
                                              appleHealthConnectInProgress =
                                                  true;
                                              appleHealthConnectSuccess = false;
                                            });
                                            await requestAuthorization();
                                            setState(() {
                                              appleHealthConnectInProgress =
                                                  false;
                                              appleHealthConnectSuccess = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            primary: theme.primaryColor,
                                          ),
                                        );
                                }
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 8),
                      _FirstNameInput(),
                      const SizedBox(height: 8),
                      _LastNameInput(),
                      const SizedBox(height: 8),
                      _EmailInput(),
                      const SizedBox(height: 8),
                      _DateOfBirthInput(),
                      const SizedBox(height: 8),
                      _IsPregnantInput(),
                      const SizedBox(height: 8),
                      _FamilyMemberInput(),
                      const SizedBox(height: 8),
                      _UpdateButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileForm_firstNameInput_textField'),
          controller: TextEditingController()
            ..text = state.firstName.value
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: state.firstName.value.length),
            ),
          onChanged: (firstName) =>
              context.read<ProfileCubit>().firstNameChanged(firstName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'first name',
            helperText: '',
            errorText: state.firstName.invalid ? 'invalid first name' : null,
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileForm_lastNameInput_textField'),
          controller: TextEditingController()
            ..text = state.lastName.value
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: state.lastName.value.length),
            ),
          onChanged: (lastName) =>
              context.read<ProfileCubit>().lastNameChanged(lastName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'last name',
            helperText: '',
            errorText: state.firstName.invalid ? 'invalid last name' : null,
          ),
        );
      },
    );
  }
}

class _DateOfBirthInput extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileForm_dateofbirthInput_textField'),
          controller: _controller..text = state.dateOfBirth.value,
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (dateOfBirth) {
                      _controller.text =
                          DateFormat(constants.DATE_FORMAT).format(dateOfBirth);
                      context
                          .read<ProfileCubit>()
                          .dateOfBirthChanged(_controller.text);
                    },
                    initialDateTime: context
                            .read<AuthRepository>()
                            .currentUser
                            .dateOfBirth ??
                        DateTime.now(),
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                  ),
                );
              },
            );
          },
          onChanged: (dateOfBirth) =>
              context.read<ProfileCubit>().dateOfBirthChanged(dateOfBirth),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'date of birth',
            helperText: '',
            errorText: state.dateOfBirth.invalid ? 'invalid date' : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileForm_emailInput_textField'),
          controller: TextEditingController()
            ..text = state.email.value
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: state.email.value.length),
            ),
          onChanged: (email) =>
              context.read<ProfileCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _IsPregnantInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.isPregnant != current.isPregnant,
      builder: (context, state) {
        return ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField(
            key: const Key('profileForm_isPregnantInput_dropdownField'),
            items: <String>['', 'Yes', 'No'].map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: state.isPregnant.value,
            isExpanded: true,
            menuMaxHeight: 250,
            onChanged: (isPregnant) => context
                .read<ProfileCubit>()
                .isPregnantChanged(isPregnant.toString()),
            decoration: InputDecoration(
              labelText: 'are you pregnant?',
              helperText: '',
              errorText: state.isPregnant.invalid ? 'invalid status' : null,
            ),
          ),
        );
      },
    );
  }
}

class _FamilyMemberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.familyMember != current.familyMember,
      builder: (context, state) {
        return TextField(
          key: const Key('profileForm_familyMemberInput_textField'),
          onChanged: (familyMember) =>
              context.read<ProfileCubit>().familyMemberChanged(familyMember),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'add family member',
            helperText: 'Other Members: '
                // ignore: lines_longer_than_80_chars
                '${context.read<AuthRepository>().currentUser.displayFamilyMembers}',
            helperMaxLines: 2,
            errorText: state.familyMember.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _UpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('profileForm_update_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: const Color(0xFF007BFF),
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<ProfileCubit>().updateProfile()
                    : null,
                child: const Text('UPDATE'),
              );
      },
    );
  }
}
