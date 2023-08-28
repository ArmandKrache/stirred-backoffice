import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/requests/filtered_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/requests/searched_cocktails_request.dart';
import 'package:cocktail_app/src/presentation/cubits/remote_drinks/remote_drinks_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/profile_list_element_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/extensions/scroll_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

@RoutePage()
class DrinksView extends HookWidget {
  const DrinksView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    /// final remoteDrinksCubit = BlocProvider.of<RemoteDrinksCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      /// remoteDrinksCubit.handleEvent(event: FilteredDrinksEvent(request: FilteredCocktailsRequest(ingredients: "Vodka")));

    }, const []);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Drinks",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1)),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.deepPurpleAccent,
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add, color: Colors.white,),
                    Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                  ],
                ),
              ),
              onPressed: () {
                /// TODO: Open create new item Modal
              },
            ),
          ],
        ),
      body: const Center(child: Text("DRINKS"),),
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