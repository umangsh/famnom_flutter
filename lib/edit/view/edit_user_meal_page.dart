import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/edit/edit.dart';

class EditUserMealPage extends StatelessWidget {
  /// Can be used for create if externalId is not present.
  const EditUserMealPage({Key? key, this.externalId}) : super(key: key);

  final String? externalId;

  static Page page({String? externalId}) => MaterialPage<void>(
        child: EditUserMealPage(externalId: externalId),
      );

  static Route<String> route({String? externalId}) {
    return MaterialPageRoute(
      builder: (_) => EditUserMealPage(externalId: externalId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditUserMealCubit(
        context.read<AppRepository>(),
      ),
      child: EditUserMealForm(externalId: externalId),
    );
  }
}
