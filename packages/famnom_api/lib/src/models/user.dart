import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.externalId,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.isPregnant,
    this.familyMembers,
  });

  /// Deserialize json to User object.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Serialize User object to json.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// The current user's email address.
  final String email;

  /// The current user's external id.
  final String externalId;

  /// The current user's first name.
  final String? firstName;

  /// The current user's last name.
  final String? lastName;

  /// The current user's date of birth.
  final String? dateOfBirth;

  /// The current user's is_pregnant flag.
  final bool? isPregnant;

  /// If the current user is in a family, this field includes the list of all
  /// other users in the family. Empty otherwise.
  final List<String>? familyMembers;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(externalId: '', email: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        email,
        externalId,
        firstName,
        lastName,
        dateOfBirth,
        isPregnant,
        familyMembers,
      ];
}
