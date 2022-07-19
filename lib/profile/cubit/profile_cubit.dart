import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository)
      : super(
          ProfileState(
            firstName: Name.pure(_authRepository.currentUser.firstName ?? ''),
            lastName: Name.pure(_authRepository.currentUser.lastName ?? ''),
            email: Email.pure(_authRepository.currentUser.email),
            dateOfBirth: _authRepository.currentUser.dateOfBirth == null
                ? Date.pure()
                : Date.pure(
                    DateFormat(constants.DATE_FORMAT)
                        .format(_authRepository.currentUser.dateOfBirth!),
                  ),
            isPregnant: _authRepository.currentUser.isPregnant == null
                ? const Flag.pure()
                : _authRepository.currentUser.isPregnant!
                    ? const Flag.pure('Yes')
                    : const Flag.pure('No'),
          ),
        );

  final AuthRepository _authRepository;

  void firstNameChanged(String value) {
    final firstName = Name.dirty(value);
    emit(
      state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          firstName,
          state.lastName,
          state.email,
          state.dateOfBirth,
          state.isPregnant,
          state.familyMember,
        ]),
      ),
    );
  }

  void lastNameChanged(String value) {
    final lastName = Name.dirty(value);
    emit(
      state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          state.firstName,
          lastName,
          state.email,
          state.dateOfBirth,
          state.isPregnant,
          state.familyMember,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          state.firstName,
          state.lastName,
          email,
          state.dateOfBirth,
          state.isPregnant,
          state.familyMember,
        ]),
      ),
    );
  }

  void dateOfBirthChanged(String value) {
    final dateOfBirth = Date.dirty(value);
    emit(
      state.copyWith(
        dateOfBirth: dateOfBirth,
        status: Formz.validate([
          state.firstName,
          state.lastName,
          state.email,
          dateOfBirth,
          state.isPregnant,
          state.familyMember,
        ]),
      ),
    );
  }

  void isPregnantChanged(String value) {
    final isPregnant = Flag.dirty(value);
    emit(
      state.copyWith(
        isPregnant: isPregnant,
        status: Formz.validate([
          state.firstName,
          state.lastName,
          state.email,
          state.dateOfBirth,
          isPregnant,
          state.familyMember,
        ]),
      ),
    );
  }

  void familyMemberChanged(String value) {
    final familyMember = Email.dirty(value);
    emit(
      state.copyWith(
        familyMember: familyMember,
        status: Formz.validate([
          state.firstName,
          state.lastName,
          state.email,
          state.dateOfBirth,
          state.isPregnant,
          familyMember,
        ]),
      ),
    );
  }

  Future<void> refreshPage() async {
    emit(ProfileState(status: FormzStatus.valid));
    await _authRepository.getUserFromDB();
    emit(
      ProfileState(
        firstName: Name.pure(_authRepository.currentUser.firstName ?? ''),
        lastName: Name.pure(_authRepository.currentUser.lastName ?? ''),
        email: Email.pure(_authRepository.currentUser.email),
        dateOfBirth: _authRepository.currentUser.dateOfBirth == null
            ? Date.pure()
            : Date.pure(
                DateFormat(constants.DATE_FORMAT)
                    .format(_authRepository.currentUser.dateOfBirth!),
              ),
        isPregnant: _authRepository.currentUser.isPregnant == null
            ? const Flag.pure()
            : _authRepository.currentUser.isPregnant!
                ? const Flag.pure('Yes')
                : const Flag.pure('No'),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.updateUser(
        User(
          externalId: _authRepository.currentUser.externalId,
          firstName:
              state.firstName.value.isNotEmpty ? state.firstName.value : null,
          lastName:
              state.lastName.value.isNotEmpty ? state.lastName.value : null,
          email: state.email.value,
          dateOfBirth: state.dateOfBirth.value.isNotEmpty
              ? DateTime.parse(state.dateOfBirth.value)
              : null,
          isPregnant: state.isPregnant.value?.toLowerCase() == 'yes'
              ? true
              : state.isPregnant.value?.toLowerCase() == 'no'
                  ? false
                  : null,
        ),
        state.familyMember.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));

      // Refresh [User] from DB.
      await _authRepository.getUserFromDB();
    } on UpdateUserFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
