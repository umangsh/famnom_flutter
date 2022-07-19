// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:environments/environment.dart';
import 'package:flutter/material.dart';

class AppBlocObserver extends BlocObserver {
  @visibleForTesting
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (Environment().config.debugPrint ?? false) {
      print(event);
    }
  }

  @visibleForTesting
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (Environment().config.debugPrint ?? false) {
      print(error);
    }
    super.onError(bloc, error, stackTrace);
  }

  @visibleForTesting
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (Environment().config.debugPrint ?? false) {
      print(change);
    }
  }

  @visibleForTesting
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (Environment().config.debugPrint ?? false) {
      print(transition);
    }
  }
}
