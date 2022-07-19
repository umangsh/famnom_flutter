import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

/// {@template auth_token}
/// AuthToken model
/// {@endtemplate}
@JsonSerializable()
class AuthToken extends Equatable {
  /// {@macro auth_token}
  const AuthToken({
    required this.key,
  });

  /// Deseralize json to AuthToken object.
  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  /// Serialize AuthToken object to json.
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  /// The auth token key.
  final String key;

  @override
  List<Object?> get props => [key];
}
