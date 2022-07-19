import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:search_repository/search_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(context.read<SearchRepository>()),
      child: const SearchView(),
    );
  }
}
