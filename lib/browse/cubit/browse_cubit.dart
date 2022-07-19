import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'browse_state.dart';
part 'browse_my_foods_cubit.dart';
part 'browse_my_meals_cubit.dart';
part 'browse_my_recipes_cubit.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit() : super(const BrowseState());

  void clearSearchBar() {
    emit(
      state.copyWith(
        status: BrowseStatus.init,
        ingredientResults: [],
      ),
    );
  }
}
