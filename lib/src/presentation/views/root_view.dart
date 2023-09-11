
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/presentation/cubits/root_navigation/nav_bar_items.dart';
import 'package:cocktail_app/src/presentation/cubits/root_navigation/root_navigation_cubit.dart';
import 'package:cocktail_app/src/presentation/views/drinks_view.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glasses_view.dart';
import 'package:cocktail_app/src/presentation/views/ingredients/ingredients_view.dart';
import 'package:cocktail_app/src/presentation/views/profiles/profiles_view.dart';
import 'package:cocktail_app/src/presentation/views/recipes_view.dart';
import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class RootView extends HookWidget {
  const RootView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final rootNavigationCubit = BlocProvider.of<RootNavigationCubit>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          margin: EdgeInsets.zero,
                          child: Center(
                            child: Image.asset(iconAsset),
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(iconAsset, width: 32,),
                          title: const Text('Drinks'),
                          onTap: () {
                            BlocProvider.of<RootNavigationCubit>(context)
                                .getNavBarItem(NavbarItem.drinks);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_rounded, size: 32,),
                          title: const Text('Profiles'),
                          onTap: () {
                            BlocProvider.of<RootNavigationCubit>(context)
                                .getNavBarItem(NavbarItem.profiles);
                          },
                        ),
                        ListTile(
                          leading: Image.asset(iconAsset, width: 32,),
                          title: const Text('Recipes'),
                          onTap: () {
                            BlocProvider.of<RootNavigationCubit>(context)
                                .getNavBarItem(NavbarItem.recipes);
                          },
                        ),
                        ListTile(
                          leading: Image.asset(iconAsset, width: 32,),
                          title: const Text('Glasses'),
                          onTap: () {
                            BlocProvider.of<RootNavigationCubit>(context)
                                .getNavBarItem(NavbarItem.glasses);
                          },
                        ),
                        ListTile(
                          leading: Image.asset(iconAsset, width: 32,),
                          title: const Text('Ingredients'),
                          onTap: () {
                            BlocProvider.of<RootNavigationCubit>(context)
                                .getNavBarItem(NavbarItem.ingredients);
                          },
                        ),
                      ],
            ),
                  GestureDetector(
                    onTap: () {
                      rootNavigationCubit.logOut();
                    },
                    child: Center(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: const Text("Log out",
                          style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Expanded(
              child: BlocBuilder<RootNavigationCubit, RootNavigationState>(
                builder: (_, state) {
                  if (state.navbarItem == NavbarItem.drinks) {
                    return const DrinksView();
                  } else if (state.navbarItem == NavbarItem.profiles) {
                    return const ProfilesView();
                  } else if (state.navbarItem == NavbarItem.recipes) {
                    return const RecipesView();
                  } else if (state.navbarItem == NavbarItem.glasses) {
                    return const GlassesView();
                  } else if (state.navbarItem == NavbarItem.ingredients) {
                    return const IngredientsView();
                  }
                  return const SizedBox();
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

