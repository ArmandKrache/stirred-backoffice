
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class RecipesView extends HookWidget {
  const RecipesView({Key? key}) : super (key: key);

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
            "Recipes",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1)),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
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
      body: const Center(child: Text("RECIPES"),),
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