import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/ingredients/ingredient_details_cubit.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glass_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/views/ingredients/ingredient_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/categories_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_delete_alert_dialog_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/description_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/matches_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/picture_attribute_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


@RoutePage()
class IngredientDetailsView extends HookWidget {
  final Ingredient ingredient;

  const IngredientDetailsView({Key? key, required this.ingredient}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    final ingredientDetailsCubit = BlocProvider.of<IngredientDetailsCubit>(context);

    useEffect(() {
      ingredientDetailsCubit.setIngredient(ingredient);
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<IngredientDetailsCubit, IngredientDetailsState>(
          builder: (context, state) {
            return Column(
              children: [
                Text(state.ingredient?.name ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
                SelectableText(
                  "${state.ingredient?.id}",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
              ],
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 28),
        actions: [
          Row(
            children: [
              GestureDetector(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(2),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.edit, color: Colors.deepPurpleAccent,),
                          Text("Edit", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w600, fontSize: 16),),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          child: _editIngredientModal(context, ingredientDetailsCubit)
                      ),
                    );
                  }
              ),
              GestureDetector(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(2),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.delete, color: Colors.red,),
                          Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16),),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => CustomGenericAlertDialogWidget(
                        item: ingredientDetailsCubit.state.ingredient,
                        onCancel: () {
                          appRouter.pop();
                        },
                        onConfirm: () {
                           ingredientDetailsCubit.deleteIngredient(ingredientDetailsCubit.state.ingredient!.id);
                        },
                      ),
                    );
                    if (ingredientDetailsCubit.state.runtimeType == IngredientDeleteSuccess) {
                      appRouter.pop("deleted");
                    }
                  }
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<IngredientDetailsCubit, IngredientDetailsState>(
          builder: (context, state) {
            if (state.runtimeType == IngredientDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PictureAttributeWidget(src : state.ingredient!.picture),
                          const SizedBox(width: 16,),
                          DescriptionAttributeWidget(text : state.ingredient!.description),
                        ],
                      ),
                      MatchesAttributeWidget(matches: state.ingredient!.matches),
                      CategoriesAttributeWidget(categories: state.ingredient!.categories),
                    ],
                  )
              );
            }
          }),
    );
  }

  Widget _editIngredientModal(BuildContext context, IngredientDetailsCubit ingredientDetailsCubit) {
    return IngredientEditModalWidget(
      onSave: (data) async {
        /// TODO: Patch ingredient
        /// await ingredientDetailsCubit.patchIngredient(ingredientDetailsCubit.state.glass!.id, data);
      },
      title: "Edit Ingredient",
      currentItem: ingredientDetailsCubit.state.ingredient,
      searchMatches: (query) {
        return ingredientDetailsCubit.searchMatches(query);
      },
    );
  }
}