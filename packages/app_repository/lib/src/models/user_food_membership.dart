import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_food_membership.g.dart';

/// {@template user_food_membership}
/// UserFoodMembership model
/// {@endtemplate}
@JsonSerializable()
class UserFoodMembership extends Equatable {
  /// {@macro user_food_membership}
  const UserFoodMembership({
    required this.id,
    required this.externalId,
    required this.childId,
    required this.childExternalId,
    required this.childName,
    required this.childPortionExternalId,
    required this.childPortionName,
    this.quantity,
  });

  /// Deserialize json to UserFoodMembership object.
  factory UserFoodMembership.fromJson(Map<String, dynamic> json) =>
      _$UserFoodMembershipFromJson(json);

  /// Serialize UserFoodMembership object to json.
  Map<String, dynamic> toJson() => _$UserFoodMembershipToJson(this);

  /// Portion ID.
  final int id;

  /// Portion external ID.
  final String externalId;

  /// Child ID.
  final int childId;

  /// Child external ID.
  final String childExternalId;

  /// Child name.
  final String childName;

  /// Child portion external ID.
  final String childPortionExternalId;

  /// Child portion name.
  final String childPortionName;

  /// Member quantity.
  final double? quantity;

  @override
  List<Object?> get props => [
        id,
        externalId,
        childId,
        childExternalId,
        childName,
        childPortionExternalId,
        childPortionName,
        quantity
      ];
}
