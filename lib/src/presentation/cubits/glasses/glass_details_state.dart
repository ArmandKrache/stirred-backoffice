part of 'glass_details_cubit.dart';

abstract class GlassDetailsState extends Equatable {
  final Glass? glass;
  final DioException? exception;

  const GlassDetailsState({
    this.glass,
    this.exception,
  });

  @override
  List<Object?> get props => [glass, exception];
}

class GlassDetailsLoading extends GlassDetailsState {
  const GlassDetailsLoading();
}

class GlassDetailsSuccess extends GlassDetailsState {
  const GlassDetailsSuccess({super.glass,});
}

class GlassDetailsFailed extends GlassDetailsState {
  const GlassDetailsFailed({super.glass,});
}

class GlassDeleteSuccess extends GlassDetailsState {
  const GlassDeleteSuccess({super.glass,});
}

class GlassDeleteFailed extends GlassDetailsState {
  const GlassDeleteFailed({super.glass,});
}

class GlassPatchSuccess extends GlassDetailsState {
  const GlassPatchSuccess({super.glass,});
}

class GlassPatchFailed extends GlassDetailsState {
  const GlassPatchFailed({super.glass,});
}