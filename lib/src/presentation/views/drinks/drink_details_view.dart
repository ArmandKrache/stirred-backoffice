import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/presentation/cubits/drinks/drink_details_cubit.dart';
import 'package:cocktail_app/src/presentation/views/drinks/drink_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/views/drinks/drink_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/categories_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_clickable_text.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_delete_alert_dialog_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/description_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/glass_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/picture_attribute_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

@RoutePage()
class DrinkDetailsView extends HookWidget {
  final Drink drink;

  const DrinkDetailsView({Key? key, required this.drink}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    final drinkDetailsCubit = BlocProvider.of<DrinkDetailsCubit>(context);

    useEffect(() {
      drinkDetailsCubit.setDrink(drink);
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<DrinkDetailsCubit, DrinkDetailsState>(
          builder: (context, state) {
            return Column(
              children: [
                Text(state.drink?.name ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
                SelectableText(
                  "${state.drink?.id}",
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
                          child: _editDrinkModal(context, drinkDetailsCubit)
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
                        item: drinkDetailsCubit.state.drink,
                        onCancel: () {
                          appRouter.pop();
                        },
                        onConfirm: () {
                          drinkDetailsCubit.deleteDrink(drinkDetailsCubit.state.drink!.id);
                        },
                      ),
                    );
                    if (drinkDetailsCubit.state.runtimeType == DrinkDeleteSuccess) {
                      appRouter.pop("deleted");
                    }
                  }
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<DrinkDetailsCubit, DrinkDetailsState>(
          builder: (context, state) {
            if (state.runtimeType == DrinkDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Drink currentDrink = state.drink!;
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
                          PictureAttributeWidget(src : currentDrink.picture),
                          const SizedBox(width: 16,),
                          DescriptionAttributeWidget(text : currentDrink.description),
                        ],
                      ),
                      CustomGenericAttributeWidget(
                        title: "Average Rating",
                        backgroundColor: Colors.white,
                        child: currentDrink.averageRating == 0.0 ?
                          const Text("No Ratings yet",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ) :
                          RatingBarIndicator(
                            rating: currentDrink.averageRating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                      ),
                      CustomGenericAttributeWidget(
                        title: "Recipe",
                        child: CustomClickableText(
                          text: Text(currentDrink.recipe.name ?? "",
                            style: const TextStyle(color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          onTap: () {
                            appRouter.push(RecipeDetailsRoute(id: currentDrink.recipe.id, editButtonsVisibility: false));
                          },
                        ),
                      ),
                      CustomGenericAttributeWidget(
                        title: "Author",
                        child: CustomClickableText(
                          text: Text(currentDrink.author.name ?? "",
                            style: const TextStyle(color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          onTap: () {
                            ///TODO: Go to Author Details View
                          },
                        ),
                      ),
                      GlassAttributeWidget(glass: currentDrink.glass),
                      CategoriesAttributeWidget(categories: currentDrink.categories)
                    ],
                  ),
              );
            }
          }),
    );
  }

  Widget _editDrinkModal(BuildContext context, DrinkDetailsCubit drinkDetailsCubit) {
    return DrinkEditModalWidget(
      onSave: (data) async {
        await drinkDetailsCubit.patchDrink(drinkDetailsCubit.state.drink!.id, data);
      },
      title: "Edit Drink",
      currentItem: drinkDetailsCubit.state.drink,
    );
  }
}