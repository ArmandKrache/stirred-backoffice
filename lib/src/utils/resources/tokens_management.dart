// Store access token
import 'package:cocktail_app/src/config/config.dart';

Future<void> storeAccessToken(String token) async {
  await storage.write(key: 'access_token', value: token);
}

Future<void> storeRefreshToken(String token) async {
  await storage.write(key: 'refresh_token', value: token);
}

// Retrieve access token
Future<String?> getAccessToken() async {
  return await storage.read(key: 'access_token');
}

Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refresh_token');
}

// Remove access token
Future<void> deleteTokens() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
}