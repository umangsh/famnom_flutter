import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

/// {@template brand}
/// Brand model
/// {@endtemplate}
@JsonSerializable()
class Brand extends Equatable {
  /// {@macro brand}
  const Brand({
    this.brandOwner,
    this.brandName,
    this.subBrandName,
    this.gtinUpc,
    this.ingredients,
    this.notASignificantSourceOf,
  });

  /// Deserialize json to Brand object.
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  /// Serialize Brand object to json.
  Map<String, dynamic> toJson() => _$BrandToJson(this);

  /// Brand owner.
  final String? brandOwner;

  /// Brand name.
  final String? brandName;

  /// Sub Brand name.
  final String? subBrandName;

  /// GTIN/UPC.
  final String? gtinUpc;

  /// Ingredients list.
  final String? ingredients;

  /// Brand details.
  String? get brandDetails {
    final list = [brandName, subBrandName, brandOwner]
      ..removeWhere((v) => v == null || v.isEmpty);

    if (list.isEmpty) {
      return null;
    }

    return list.join(', ');
  }

  /// Not a significant source of.
  final String? notASignificantSourceOf;

  /// Empty brand.
  static const empty = Brand();

  /// Convenience getter to determine whether the current brand is empty.
  bool get isEmpty => this == Brand.empty;

  /// Convenience getter to determine whether the current brand is not empty.
  bool get isNotEmpty => this != Brand.empty;

  @override
  List<Object?> get props => [
        brandOwner,
        brandName,
        subBrandName,
        gtinUpc,
        ingredients,
        notASignificantSourceOf
      ];
}
