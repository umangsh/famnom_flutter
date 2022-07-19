import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';

class BrowseMyMealsPage extends StatelessWidget {
  const BrowseMyMealsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: BrowseMyMealsPage());

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const BrowseMyMealsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowseMyMealsCubit>(
      create: (_) => BrowseMyMealsCubit(context.read<AppRepository>()),
      child: const BrowseMyMealsView(),
    );
  }
}
