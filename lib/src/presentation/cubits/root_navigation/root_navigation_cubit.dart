import 'package:bloc/bloc.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/root_navigation/nav_bar_items.dart';
import 'package:equatable/equatable.dart';

part 'root_navigation_state.dart';

class RootNavigationCubit extends Cubit<RootNavigationState> {
  RootNavigationCubit() : super(const RootNavigationSuccess(navbarItem: NavbarItem.drinks, index: 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.drinks:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.drinks, index: 0));
        break;
      case NavbarItem.profiles:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.profiles, index: 1));
        break;
      case NavbarItem.recipes:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.recipes, index: 2));
        break;
      case NavbarItem.glasses:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.glasses, index: 2));
        break;
      case NavbarItem.ingredients:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.ingredients, index: 2));
        break;
    }
  }
}