import 'package:cocktail_app/src/data/datasources/remote/admin_api_service.dart';
import 'package:cocktail_app/src/data/datasources/remote/stirred_api_service.dart';
import 'package:cocktail_app/src/data/api_repository_impl.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies ( ) async {
  /*final db = await $FloorAppDatabase.databaseBuilder(databaseName).build();
  locator.registerSingleton<AppDatabase>(db);

  locator.registerSingleton<DatabaseRepository>(
    DatabaseRepositoryImpl(locator<AppDatabase>())
  );*/

  final dio = Dio();
  dio.options = BaseOptions();
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