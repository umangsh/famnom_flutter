import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cache/cache.dart' as cache;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart' as famnom;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:famnom_flutter/app/app.dart';
import 'package:search_repository/search_repository.dart';

Future<void> main() {
  // Init environment config.
  const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.dev,
  );
  Environment().initConfig(environment);

  // Load environment secrets.
  dotenv.load(
    fileName: 'assets/.$environment.env',
  );

  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// Initialize shared client services.
      final cacheClient = cache.CacheClient();
      final famnomApiClient = famnom.FamnomApiClient();

      /// Initialize all repositories.
      final appRepository =
          AppRepository(cache: cacheClient, famnomApiClient: famnomApiClient);
      final authRepository =
          AuthRepository(cache: cacheClient, famnomApiClient: famnomApiClient);
      final searchRespository =
          SearchRepository(famnomApiClient: famnomApiClient);

      /// Fetch logged in user if available.
      await authRepository.initStream();

      if (authRepository.currentUser.isNotEmpty) {
        /// Initialize / fetch app constants.
        await appRepository.getAppConstants();

        /// Fetch nutrition preferences.
        await appRepository.getNutritionPreferences();
      }

      /// Run app.
      runApp(
        App(
          appRepository: appRepository,
          authRepository: authRepository,
          searchRepository: searchRespository,
        ),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}
