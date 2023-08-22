import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/data/datasources/local/app_database.dart';
import 'package:cocktail_app/src/data/datasources/remote/cocktail_api_service.dart';
import 'package:cocktail_app/src/data/repositories/api_repository_impl.dart';
import 'package:cocktail_app/src/data/repositories/database_repository_impl.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/domain/repositories/database_repository.dart';
import 'package:dio/dio.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
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
  /*dio.options.headers['Access-Control-Allow-Origin'] = '*'; //TODO : Change it to something safer
  dio.options.headers['Access-Control-Allow-Methods'] = 'GET, DELETE, HEAD, OPTIONS, POST, PUT, PATCH';
  dio.options.headers['Access-Control-Allow-Credentials'] = 'true'; */
  locator.registerSingleton<Dio>(dio);
  locator.registerSingleton<CocktailApiService>(
    CocktailApiService(locator<Dio>()),
  );
  locator.registerSingleton<ApiRepository>(
    ApiRepositoryImpl(locator<CocktailApiService>()),
  );
 }