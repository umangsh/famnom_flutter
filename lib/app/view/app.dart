import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/app/app.dart';
import 'package:famnom_flutter/theme.dart';
import 'package:search_repository/search_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AppRepository appRepository,
    required AuthRepository authRepository,
    required SearchRepository searchRepository,
  })  : _appRepository = appRepository,
        _authRepository = authRepository,
        _searchRepository = searchRepository,
        super(key: key);

  final AppRepository _appRepository;
  final AuthRepository _authRepository;
  final SearchRepository _searchRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _appRepository,
        ),
        RepositoryProvider.value(
          value: _authRepository,
        ),
        RepositoryProvider.value(
          value: _searchRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authRepository: _authRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
