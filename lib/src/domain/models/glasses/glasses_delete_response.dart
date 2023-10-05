import 'package:equatable/equatable.dart';

class GlassDeleteResponse extends Equatable {
  final bool success;

  const GlassDeleteResponse({
    required this.success,
  });


  factory GlassDeleteResponse.fromMap(Map<String, dynamic> map) {
    return const GlassDeleteResponse(
        success: true
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success];

}