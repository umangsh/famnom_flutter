part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.email = const Email.pure(),
    Date? dateOfBirth,
    this.isPregnant = const Flag.pure(),
    this.familyMember = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  }) : dateOfBirth = dateOfBirth ?? Date.pure();

  final Name firstName;
  final Name lastName;
  final Email email;
  final Date dateOfBirth;
  final Flag isPregnant;
  final Email familyMember;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        dateOfBirth,
        isPregnant,
        familyMember,
        status
      ];

  ProfileState copyWith({
    Name? firstName,
    Name? lastName,
    Email? email,
    Date? dateOfBirth,
    Flag? isPregnant,
    Email? familyMember,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isPregnant: isPregnant ?? this.isPregnant,
      familyMember: familyMember ?? this.familyMember,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
