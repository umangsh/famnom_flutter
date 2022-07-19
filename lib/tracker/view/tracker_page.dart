import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/tracker/tracker.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: TrackerPage());

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const TrackerPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackerCubit>(
      create: (_) => TrackerCubit(context.read<AppRepository>()),
      child: const TrackerView(),
    );
  }
}
