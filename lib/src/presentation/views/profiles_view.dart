import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/requests/filtered_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/searched_cocktails_request.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/remote_drinks/remote_drinks_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/drink_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/extensions/scroll_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

@RoutePage()
class ProfilesView extends HookWidget {
  const ProfilesView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final profilesCubit = BlocProvider.of<ProfilesCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      profilesCubit.handleEvent(event: ProfileListEvent(request: ProfileListRequest()));
    }, []);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profiles",
            style: TextStyle(color: Colors.black),
          ),
          actions: const [],
        ),
      body: BlocBuilder<ProfilesCubit, ProfilesState>(
          builder: (context, state) {
            if (state.profiles.isEmpty) {
              return const Center(child: Text("Profile list is empty"),);
            } else {
              return const Center(child: Text("TODO LIST VIEW OF PROFILES"),);
            }
          }),
      /*body: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onSubmitted: (query) {
                /* remoteDrinksCubit.handleEvent(
                    event: SearchDrinksEvent(
                      request: SearchedCocktailsRequest(name: query),
                    )
                );*/
              },
            ),
            const SizedBox(height: 4,),
            BlocBuilder<RemoteDrinksCubit, RemoteDrinksState>(
                builder: (_, state) {
                  switch (state.runtimeType) {
                    case RemoteDrinksLoading:
                      return const Center(child: CupertinoActivityIndicator());
                    case RemoteDrinksFailed:
                      return const Center(child: Icon(Ionicons.refresh));
                    case RemoteDrinksSuccess:
                      return Expanded(
                        child: _buildArticles(
                          scrollController,
                          state.drinks,
                          state.noMoreData,
                        ),
                      );
                    default:
                      return const SizedBox();
                  }
                }
            ),
          ],
        ) */
    );
  }


}