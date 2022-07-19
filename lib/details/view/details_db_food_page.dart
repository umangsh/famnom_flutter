import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';

class DetailsDBFoodPage extends StatelessWidget {
  const DetailsDBFoodPage({Key? key, required this.externalId})
      : super(key: key);

  final String externalId;

  static Page page(String externalId) =>
      MaterialPage<void>(child: DetailsDBFoodPage(externalId: externalId));

  static Route<String> route(String externalId) {
    return MaterialPageRoute(
      builder: (_) => DetailsDBFoodPage(externalId: externalId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsDBFoodCubit>(
      create: (_) => DetailsDBFoodCubit(context.read<AppRepository>()),
      child: DetailsDBFoodView(externalId: externalId),
    );
  }
}
