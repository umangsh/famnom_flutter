export 'cubit/edit_cubit.dart';
export 'view/view.dart';

extension ListAt<T extends Object> on List<T> {
  T? at(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
