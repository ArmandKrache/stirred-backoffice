import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/ingredients/ingredients_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glass_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


@RoutePage()
class IngredientsView extends HookWidget {
  const IngredientsView({Key? key}) : super (key: key);



  @override
  Widget build(BuildContext context) {
    final ingredientsCubit = BlocProvider.of<IngredientsCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      ingredientsCubit.fetchList(request: IngredientsListRequest());
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
      body: BlocBuilder<IngredientsCubit, IngredientsState>(
          builder: (context, state) {
            if (state.runtimeType == IngredientsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.ingredients.isEmpty) {
              return const Center(child: Text("Ingredients list is empty"),);
            } else {
              return Column(
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
                  Expanded(
                      child: _buildDataTable(state.ingredients, ingredientsCubit)
                  ),
                ],
              );
            }
          }),
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
                  /// TODO : Details View
                    /* final deleted = await appRouter.push(IngredientDetailsRoute(ingredient: item));
                    if (deleted == "deleted") {
                      ingredientsCubit.fetchList(request: IngredientsListRequest());
                    } */
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
              DataCell(SelectableText("${item.categories.keywords.first},"
                ", ${item.categories.origins.first}"
                ", ${item.categories.eras.first}"
                ", ${item.categories.diets.first}"
                ", ${item.categories.colors.first}"
                ", ${item.categories.seasons.first}"
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _ingredientCreateModal(BuildContext context, IngredientsCubit ingredientsCubit) {
    /// TODO : Create
    /* final ingredientCreateCubit = BlocProvider.of<IngredientCreateCubit>(context);
    String errorText = "";

    return BlocBuilder<IngredientCreateCubit, IngredientCreateState>(
        builder: (context, state) {
          if (state.runtimeType == IngredientCreateSuccess) {
            ingredientCreateCubit.reset();
            Navigator.pop(context);
            /// ingredientsCubit.handleEvent(event: IngredientesListEvent(request: IngredientesListRequest()));
            return const SizedBox();
          } else if (state.runtimeType == IngredientCreateFailed) {
            errorText = "Some fields are missing";
          }
          return IngredientEditModalWidget(
            onClose: () {
              ingredientCreateCubit.reset();
              Navigator.pop(context);
            },
            onSave: (Map<String, dynamic> data) {
              ingredientCreateCubit.createIngredient(data);
            },
            title: "New Ingredient",
            errorText: errorText,
          );
        }
    ); */
    return SizedBox();
  }

}