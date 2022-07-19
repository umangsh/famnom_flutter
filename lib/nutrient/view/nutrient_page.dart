import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';

class MyNutrientPage extends StatelessWidget {
  const MyNutrientPage({Key? key, required this.nutrientId}) : super(key: key);

  final int nutrientId;

  static Page page(int nutrientId) =>
      MaterialPage<void>(child: MyNutrientPage(nutrientId: nutrientId));

  static Route<String> route(int nutrientId) {
    return MaterialPageRoute(
      builder: (_) => MyNutrientPage(nutrientId: nutrientId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrientCubit>(
      create: (_) => NutrientCubit(context.read<AppRepository>()),
      child: NutrientView(nutrientId: nutrientId),
    );
  }
}
