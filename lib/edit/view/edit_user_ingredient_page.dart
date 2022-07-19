import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:search_repository/search_repository.dart';

class EditUserIngredientPage extends StatelessWidget {
  /// Can be used for create if externalId is not present.
  const EditUserIngredientPage({Key? key, this.externalId}) : super(key: key);

  final String? externalId;

  static Page page({String? externalId}) => MaterialPage<void>(
        child: EditUserIngredientPage(externalId: externalId),
      );

  static Route<String> route({String? externalId}) {
    return MaterialPageRoute(
      builder: (_) => EditUserIngredientPage(externalId: externalId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditUserIngredientCubit(
        context.read<AppRepository>(),
        context.read<SearchRepository>(),
      ),
      child: EditUserIngredientForm(externalId: externalId),
    );
  }
}
