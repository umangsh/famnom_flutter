part of 'edit_cubit.dart';

class FoodMemberForm {
  FoodMemberForm({
    this.id,
    this.childExternalId,

    /// Only for display
    this.childName,
    this.serving,

    /// Only for display
    this.servingName,
    this.quantity,
    this.isDeleted,
  });

  int? id;
  String? childExternalId;
  String? childName;
  String? serving;
  String? servingName;
  String? quantity;
  bool? isDeleted;
}
