import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';

class BrowseMyRecipesPage extends StatelessWidget {
  const BrowseMyRecipesPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: BrowseMyRecipesPage());

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const BrowseMyRecipesPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowseMyRecipesCubit>(
      create: (_) => BrowseMyRecipesCubit(context.read<AppRepository>()),
      child: const BrowseMyRecipesView(),
    );
  }
}
