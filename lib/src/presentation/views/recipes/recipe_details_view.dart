import 'package:auto_route/auto_route.dart';
import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/recipes/recipe_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/views/recipes/recipe_edit_modal_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/custom_generic_delete_alert_dialog_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/description_attribute_widget.dart';
import 'package:stirred_backoffice/src/utils/constants/global_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';


@RoutePage()
class RecipeDetailsView extends HookWidget {
  final Recipe? recipe;
  final String? id;
  final bool editButtonsVisibility;

  const RecipeDetailsView({Key? key, this.recipe, this.id, this.editButtonsVisibility = true}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    final recipeDetailsCubit = BlocProvider.of<RecipeDetailsCubit>(context);

    useEffect(() {
      recipeDetailsCubit.setRecipe(recipe: recipe, id: id);
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<RecipeDetailsCubit, RecipeDetailsState>(
          builder: (context, state) {
            return Column(
              children: [
                Text(state.recipe?.name ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
                SelectableText(
                  "${state.recipe?.id}",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
              ],
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 28),
        actions: [
          Visibility(
            visible: editButtonsVisibility,
            child: Row(
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
                            child: _editRecipeModal(context, recipeDetailsCubit)
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
                          item: recipeDetailsCubit.state.recipe,
                          onCancel: () {
                            appRouter.pop();
                          },
                          onConfirm: () {
                            recipeDetailsCubit.deleteRecipe(recipeDetailsCubit.state.recipe!.id);
                          },
                        ),
                      );
                      if (recipeDetailsCubit.state.runtimeType == RecipeDeleteSuccess) {
                        appRouter.pop("deleted");
                      }
                    }
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<RecipeDetailsCubit, RecipeDetailsState>(
          builder: (context, state) {
            if (state.runtimeType == RecipeDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.recipe == null) {
              return const SizedBox();
            } else {
              Recipe currentRecipe = state.recipe!;
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
                          DescriptionAttributeWidget(text : currentRecipe.description),
                        ],
                      ),
                      CustomGenericAttributeWidget(
                        title: "Difficulty",
                        child: Text(getDifficultyTitle(currentRecipe.difficulty)),
                      ),
                      CustomGenericAttributeWidget(
                        title: "Preparation time",
                        child: Text("${currentRecipe.preparationTime} minutes"),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DescriptionAttributeWidget(text : currentRecipe.instructions, title: "Instructions",),
                        ],
                      ),
                      CustomGenericAttributeWidget(
                        title: "Ingredients",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for ( var element in currentRecipe.ingredients )

                              RichText(text: TextSpan(text : "- ${element.quantity} ${element.unit} of ",
                                children: [
                                  TextSpan(
                                    text: element.ingredientName,
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      appRouter.push(IngredientDetailsRoute(id: element.ingredientId, editButtonsVisibility: false));
                                    },
                                    style: const TextStyle(color: Colors.deepPurple, fontSize: 14.5, fontWeight: FontWeight.bold)
                                  ),
                                ]
                              ),)
                          ],
                        ),
                      )
                    ],
                  )
              );
            }
          }),
    );
  }

  Widget _editRecipeModal(BuildContext context, RecipeDetailsCubit recipeDetailsCubit) {
    return RecipeEditModalWidget(
      onSave: (data) async {
        await recipeDetailsCubit.patchRecipe(recipeDetailsCubit.state.recipe!.id, data);
      },
      title: "Edit Recipe",
      currentItem: recipeDetailsCubit.state.recipe,
    );
  }
}