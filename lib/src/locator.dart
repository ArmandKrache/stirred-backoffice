import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies ( ) async {
  /*final db = await $FloorAppDatabase.databaseBuilder(databaseName).build();
  locator.registerSingleton<AppDatabase>(db);

  locator.registerSingleton<DatabaseRepository>(
    DatabaseRepositoryImpl(locator<AppDatabase>())
  );*/

  final dio = Dio();
  dio.options = BaseOptions();
  dio.interceptors.add(TokenInterceptor());
  locator.registerSingleton<Dio>(dio);
  locator.registerSingleton<AdminApiService>(
    AdminApiService(locator<Dio>()),
  );
  locator.registerSingleton<StirredApiService>(
    StirredApiService(locator<Dio>()),
  );
  locator.registerSingleton<ApiRepository>(
    ApiRepositoryImpl(locator<AdminApiService>(), locator<StirredApiService>()),
  );
 }