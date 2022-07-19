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
    this.subbrandName,
    this.gtinUpc,
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
  final String? subbrandName;

  /// GTIN/UPC.
  final String? gtinUpc;

  @override
  List<Object?> get props => [brandOwner, brandName, subbrandName, gtinUpc];
}
