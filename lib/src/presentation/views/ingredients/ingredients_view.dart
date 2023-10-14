import 'package:auto_route/auto_route.dart';
import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/ingredients/ingredients_cubit.dart';
import 'package:stirred_backoffice/src/presentation/views/ingredients/ingredient_edit_modal_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';


@RoutePage()
class IngredientsView extends HookWidget {
  const IngredientsView({Key? key}) : super (key: key);



  @override
  Widget build(BuildContext context) {
    final ingredientsCubit = BlocProvider.of<IngredientsCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController searchController = TextEditingController();


    useEffect(() {
      ingredientsCubit.fetchList();
      return;
    }, []);


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ingredients",
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
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                      child: _ingredientCreateModal(context, ingredientsCubit)
                  ),
                );
              }
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            controller: searchController,
            onChanged: (query) {
              ingredientsCubit.fetchList(query: query);
            },
            margin: const EdgeInsets.all(8),
          ),
          const SizedBox(height: 4,),
          Expanded(
            child: BlocBuilder<IngredientsCubit, IngredientsState>(
              builder: (context, state) {
                if (state.ingredients.isEmpty) {
                  return const Center(child: Text("Ingredients list is empty"),);
                } else {
                  return _buildDataTable(state.ingredients, ingredientsCubit);
                }
              }),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<Ingredient> ingredients, IngredientsCubit ingredientsCubit ) {
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
      DataColumn(
        label: Expanded(
          child: Text(
            'Matches',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Categories',
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
        data: ingredients,
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
                    final deleted = await appRouter.push(IngredientDetailsRoute(ingredient: item));
                    if (deleted == "deleted") {
                      ingredientsCubit.fetchList();
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
              DataCell(SelectableText(item.matches.map((ingredient) => ingredient.name).join(', '))),
              DataCell(SelectableText("${item.categories.keywords.isEmpty ? "" : item.categories.keywords.first}"
                "${item.categories.origins.isEmpty ? "" : ",  ${item.categories.origins.first}"}"
                "${item.categories.colors.isEmpty ? "" : ", ${item.categories.colors.first}"}"
                "${item.categories.diets.isEmpty ? "" : ", ${item.categories.diets.first}"}"
                "${item.categories.seasons.isEmpty ? "" : ",  ${item.categories.seasons.first}"}"
                "${item.categories.strengths.isEmpty ? "" : ",  ${item.categories.strengths.first}"}"
                "${item.categories.eras.isEmpty ? "" : ", ${item.categories.eras.first}"}"
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _ingredientCreateModal(BuildContext context, IngredientsCubit ingredientsCubit) {
    String errorText = "";
    final IngredientsState state = ingredientsCubit.state;

    if (state.runtimeType == IngredientCreateSuccess) {

      /// ingredientsCubit.setLoading();
      appRouter.pop();
      ingredientsCubit.fetchList();
      return const SizedBox();
    } else if (state.runtimeType == IngredientCreateFailed) {
      errorText = "Some fields are missing";
    }
    return IngredientEditModalWidget(
      onSave: (Map<String, dynamic> data) {
        ingredientsCubit.createIngredient(data, () async {
          await appRouter.pop();
          ingredientsCubit.fetchList();
        });
      },
      title: "New Ingredient",
      errorText: errorText,
      searchMatches: (query) {
        return ingredientsCubit.searchMatches(query);
      },
    );
  }

}