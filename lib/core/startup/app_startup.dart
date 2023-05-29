import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/network/network_info.dart';
import 'package:sonalysis/core/startup/cache_svg.dart';
import 'package:sonalysis/core/startup/error_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'environment.dart';
import 'register_cubit.dart';

final GetIt serviceLocator = GetIt.I;

Future initLocator() async {
  await setupConfig();
  // do not put anything before setupconfig
  errorLogConfig();
  //cacheSvg();

  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());

  serviceLocator.registerSingleton<NavigationService>(NavigationService());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  serviceLocator.registerSingleton(
    LocalStorage(
      sharedPreferences: sharedPreferences,
      flutterSecureStorage: flutterSecureStorage,
    ),
  );

  registerCubit(serviceLocator);
}
