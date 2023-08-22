import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String access;
  final String refresh;

  const LoginResponse({
    required this.access,
    required this.refresh,
  });


  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    final data = map["data"];
    return LoginResponse(
      access: data['access'] ?? "",
      refresh: data['refresh'] ?? "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [access, refresh];

}