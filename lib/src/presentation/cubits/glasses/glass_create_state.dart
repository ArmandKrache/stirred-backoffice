part of 'glass_create_cubit.dart';

abstract class GlassCreateState extends Equatable {
  final File? selectedImage;

  const GlassCreateState({
    this.selectedImage,
  });

  @override
  List<Object?> get props => [selectedImage];
}

class GlassCreateLoading extends GlassCreateState {
  const GlassCreateLoading();
}

class GlassCreateSuccess extends GlassCreateState {
  const GlassCreateSuccess();
}

class GlassCreateImageSelectSuccess extends GlassCreateState {
  const GlassCreateImageSelectSuccess({super.selectedImage});
}

class GlassCreateFailed extends GlassCreateState {
  const GlassCreateFailed({super.selectedImage});
}