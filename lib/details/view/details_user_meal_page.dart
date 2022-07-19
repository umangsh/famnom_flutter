import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';

class DetailsUserMealPage extends StatelessWidget {
  const DetailsUserMealPage({Key? key, required this.externalId})
      : super(key: key);

  final String externalId;

  static Page page(String externalId) => MaterialPage<void>(
        child: DetailsUserMealPage(externalId: externalId),
      );

  static Route<String> route(String externalId) {
    return MaterialPageRoute(
      builder: (_) => DetailsUserMealPage(externalId: externalId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsUserMealCubit>(
      create: (_) => DetailsUserMealCubit(context.read<AppRepository>()),
      child: DetailsUserMealView(externalId: externalId),
    );
  }
}
