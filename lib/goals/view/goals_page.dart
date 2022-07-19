import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/goals/goals.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: GoalsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalsCubit(
        context.read<AppRepository>(),
        context.read<AuthRepository>(),
      ),
      child: const GoalsForm(),
    );
  }
}
