import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';

class MealplanPage extends StatelessWidget {
  const MealplanPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MealplanPage());

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const MealplanPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealplanCubit>(
      create: (_) => MealplanCubit(context.read<AppRepository>()),
      child: const MealplanView(),
    );
  }
}
