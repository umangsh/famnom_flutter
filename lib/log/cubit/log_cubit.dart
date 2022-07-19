import 'package:app_repository/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'log_state.dart';
part 'log_db_food_cubit.dart';
part 'log_user_ingredient_cubit.dart';
part 'log_user_recipe_cubit.dart';

class LogCubit extends Cubit<LogState> {
  LogCubit({String? mealType, String? mealDate})
      : super(
          LogState(
            mealType: Dropdown.pure(mealType ?? constants.mealTypes[0]['id']!),
            mealDate: Date.pure(
              mealDate ??
                  DateFormat(constants.DATE_FORMAT).format(DateTime.now()),
            ),
            status: mealType != null && mealDate != null
                ? FormzStatus.valid
                : FormzStatus.pure,
          ),
        );

  void mealTypeChanged(String value) {
    final mealType = Dropdown.dirty(value);
    emit(
      state.copyWith(
        mealType: mealType,
        status: Formz.validate([mealType, state.mealDate]),
      ),
    );
  }

  void mealDateChanged(String value) {
    final mealDate = Date.dirty(value);
    emit(
      state.copyWith(
        mealDate: mealDate,
        status: Formz.validate([state.mealType, mealDate]),
      ),
    );
  }
}
