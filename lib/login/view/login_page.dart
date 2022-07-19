import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: theme.colorScheme.secondary,
          ),
        ),
        foregroundColor: theme.primaryColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        shadowColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthRepository>()),
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
