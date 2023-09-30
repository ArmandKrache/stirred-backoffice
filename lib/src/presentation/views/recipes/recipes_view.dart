
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/domain/models/requests/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/presentation/cubits/recipes/recipe_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/recipes/recipes_cubit.dart';
import 'package:cocktail_app/src/presentation/views/recipes/recipe_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/resources/utils_data_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class RecipesView extends HookWidget {
  const RecipesView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final recipesCubit = BlocProvider.of<RecipesCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      recipesCubit.fetchList(request: RecipesListRequest());
      return ;
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
              onPressed: () async {
                /// TODO: Open create new item Modal
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                      child: _recipeCreateModal(context, recipesCubit)
                  ),
                );
              },
            ),
          ],
        ),
      body: BlocBuilder<RecipesCubit, RecipesState>(
          builder: (context, state) {
            if (state.runtimeType == RecipesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.recipes.isEmpty) {
              return const Center(child: Text("Ingredients list is empty"),);
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      /* remoteDrinksCubit.handleEvent(
                    event: SearchDrinksEvent(
                      request: SearchedCocktailsRequest(name: query),
                    )
                );*/
                    },
                    margin: const EdgeInsets.all(8),
                  ),
                  const SizedBox(height: 4,),
                  Expanded(
                      child: _buildDataTable(state.recipes, recipesCubit)
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildDataTable(List<Recipe> recipes, RecipesCubit recipesCubit ) {
    const columns = <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'id',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
    ];

    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomGenericDataTableWidget(
        columns: columns,
        data: recipes,
        buildRow: (item) {
          return DataRow(
            cells: [
              DataCell(
                SelectableText.rich(TextSpan(
                  text: item.id,
                  style: const TextStyle(color: Colors.blue,),
                  mouseCursor: SystemMouseCursors.click,
                ),
                  onTap: () async {
                    final deleted = await appRouter.push(RecipeDetailsRoute(recipe: item));
                    if (deleted == "deleted") {
                      recipesCubit.fetchList(request: RecipesListRequest());
                    }
                  },
                ),
              ),
              DataCell(SelectableText(item.name)),
              DataCell(SizedBox(
                width: 300,
                child: SelectableText(item.description,
                  style: const TextStyle(), maxLines: 2,),
              )
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _recipeCreateModal(BuildContext context, RecipesCubit recipesCubit) {
    final recipeCreateCubit = BlocProvider.of<RecipeCreateCubit>(context);
    String errorText = "";

    return BlocBuilder<RecipeCreateCubit, RecipeCreateState>(
        builder: (context, state) {
          if (state.runtimeType == RecipeCreateSuccess) {
            recipeCreateCubit.reset();
            appRouter.pop();
            recipesCubit.fetchList(request: RecipesListRequest());
            return const SizedBox();
          } else if (state.runtimeType == RecipeCreateFailed) {
            errorText = "Some fields are missing";
          }
          return RecipeEditModalWidget(
            onClose: () {
              recipeCreateCubit.reset();
              appRouter.pop();
            },
            onSave: (Map<String, dynamic> data) {
              recipeCreateCubit.createRecipe(data);
            },
            title: "New Recipe",
            errorText: errorText,
          );
        }
    );
  }
}