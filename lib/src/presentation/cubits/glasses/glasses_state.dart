part of 'glasses_cubit.dart';

abstract class GlassesState extends Equatable {
  final List<Glass> glasses;
  final bool noMoreData;
  final DioException? exception;

  const GlassesState({
    this.glasses = const [],
    this.noMoreData = true,
    this.exception,
  });

  @override
  List<Object?> get props => [glasses, noMoreData, exception];
}

class GlassesLoading extends GlassesState {
  const GlassesLoading();
}

class GlassesSuccess extends GlassesState {
  const GlassesSuccess({super.glasses, super.noMoreData});
}

class GlassesFailed extends GlassesState {
  const GlassesFailed({super.exception});
}