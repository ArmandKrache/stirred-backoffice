part of 'root_navigation_cubit.dart';

abstract class RootNavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;

  const RootNavigationState({
    this.navbarItem = NavbarItem.drinks,
    this.index = 0
  });

  @override
  List<Object?> get props => [navbarItem, index];
}

class RootNavigationLoading extends RootNavigationState {
  const RootNavigationLoading();
}

class RootNavigationSuccess extends RootNavigationState {
  const RootNavigationSuccess({super.navbarItem, super.index});
}

class RootNavigationFailed extends RootNavigationState {
  const RootNavigationFailed();
}