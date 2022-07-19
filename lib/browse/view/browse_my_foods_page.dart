import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';

class BrowseMyFoodsPage extends StatelessWidget {
  const BrowseMyFoodsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: BrowseMyFoodsPage());

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const BrowseMyFoodsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowseMyFoodsCubit>(
      create: (_) => BrowseMyFoodsCubit(context.read<AppRepository>()),
      child: const BrowseMyFoodsView(),
    );
  }
}
