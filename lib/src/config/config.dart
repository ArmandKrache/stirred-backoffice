import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiKey = "1";
const String baseCocktailApiUrl = "https://thecocktaildb.com/api/json/v1/$apiKey";

const String databaseName = 'app_database.db';
const String drinkTableName = "drinks_table";
const String drinkDetailsTableName = "drinks_details_table";
const String ingredientTableName = "ingredients_table";

const String localUrl = "https://127.0.0.1:8000/";
const String baseStirredAdminUrl = localUrl;
const String baseStirredApiUrl = "${localUrl}api/";
const String baseMediaUrl = "${localUrl}media/";

const storage = FlutterSecureStorage();
