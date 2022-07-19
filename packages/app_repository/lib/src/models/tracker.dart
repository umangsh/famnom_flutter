import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracker.g.dart';

/// {@template tracker}
/// Tracker model
/// {@endtemplate}
@JsonSerializable()
class Tracker extends Equatable {
  /// {@macro tracker}
  const Tracker({
    required this.meals,
    required this.nutrients,
  });

  /// Deserialize json to Tracker object.
  factory Tracker.fromJson(Map<String, dynamic> json) =>
      _$TrackerFromJson(json);

  /// Serialize Tracker object to json.
  Map<String, dynamic> toJson() => _$TrackerToJson(this);

  /// List of meals.
  final List<UserMealDisplay> meals;

  /// List of nutrients.
  final Nutrients nutrients;

  /// Empty Tracker.
  static const empty = Tracker(
    meals: [],
    nutrients: Nutrients(values: {}),
  );

  /// Convenience getter to determine whether the current
  /// Tracker is empty.
  bool get isEmpty => this == Tracker.empty;

  /// Convenience getter to determine whether the current
  /// Tracker is not empty.
  bool get isNotEmpty => this != Tracker.empty;

  @override
  List<Object?> get props => [meals, nutrients];
}
