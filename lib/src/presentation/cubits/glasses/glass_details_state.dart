part of 'glass_details_cubit.dart';

abstract class GlassDetailsState extends Equatable {
  final Glass glass;
  final DioException? exception;

  const GlassDetailsState({
    required this.glass,
    this.exception,
  });

  @override
  List<Object?> get props => [glass, exception];
}

class GlassDetailsLoading extends GlassDetailsState {
  const GlassDetailsLoading({required super.glass,});
}

class GlassDetailsSuccess extends GlassDetailsState {
  const GlassDetailsSuccess({required super.glass,});
}

class GlassDetailsFailed extends GlassDetailsState {
  const GlassDetailsFailed({required super.glass,});
}