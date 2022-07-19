import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: theme.colorScheme.secondary,
          ),
        ),
        foregroundColor: theme.primaryColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        shadowColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}
