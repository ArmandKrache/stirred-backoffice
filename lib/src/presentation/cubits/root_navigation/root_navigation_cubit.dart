
import 'package:auto_route/auto_route.dart';
import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/base/base_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/root_navigation/nav_bar_items.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'root_navigation_state.dart';

class RootNavigationCubit extends BaseCubit<RootNavigationState, Map<String, dynamic>> {
  RootNavigationCubit() : super(const RootNavigationSuccess(navbarItem: NavbarItem.drinks, index: 0), {});

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
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.glasses, index: 3));
        break;
      case NavbarItem.ingredients:
        emit(const RootNavigationSuccess(navbarItem: NavbarItem.ingredients, index: 4));
        break;
    }
  }

  Future<void> logOut() async {
    if (isBusy) return;

    await run(() async {
      deleteTokens();
      appRouter.popUntil((route) => route.data?.name == "LoginRoute");
    });
  }

  }