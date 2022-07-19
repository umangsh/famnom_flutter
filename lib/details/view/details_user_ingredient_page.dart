import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';

class DetailsUserIngredientPage extends StatelessWidget {
  const DetailsUserIngredientPage({
    Key? key,
    required this.externalId,
    this.membershipExternalId,
    this.onDeleteRoute,
  }) : super(key: key);

  final String externalId;
  final String? membershipExternalId;
  final Route<String>? onDeleteRoute;

  static Page page({
    required String externalId,
    String? membershipExternalId,
    Route<String>? onDeleteRoute,
  }) =>
      MaterialPage<void>(
        child: DetailsUserIngredientPage(
          externalId: externalId,
          membershipExternalId: membershipExternalId,
          onDeleteRoute: onDeleteRoute,
        ),
      );

  static Route<String> route({
    required String externalId,
    String? membershipExternalId,
    Route<String>? onDeleteRoute,
  }) {
    return MaterialPageRoute(
      builder: (_) => DetailsUserIngredientPage(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        onDeleteRoute: onDeleteRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsUserIngredientCubit>(
      create: (_) => DetailsUserIngredientCubit(context.read<AppRepository>()),
      child: DetailsUserIngredientView(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        onDeleteRoute: onDeleteRoute,
      ),
    );
  }
}
