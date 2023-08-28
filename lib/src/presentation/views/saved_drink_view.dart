import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/presentation/cubits/local_drink/local_drink_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/profile_list_element_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

@RoutePage()
class SavedDrinksView extends HookWidget {
  const SavedDrinksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => appRouter.pop(),
          child: const Icon(Ionicons.chevron_back, color: Colors.black,),
        ),
        title: Text(
          tr("saved_articles.saved_articles"),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder<LocalDrinkCubit, LocalDrinkState>(
        builder: (_, state) {
          switch (state.runtimeType) {
            case LocalDrinkLoading:
              return const Center(child: CupertinoActivityIndicator());
            case LocalDrinkSuccess:
              return _buildArticlesList(state.drinkList);
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildArticlesList(List<Drink> drinks) {
    if (drinks.isEmpty) {
      return Center(
        child: Text(
          tr("saved_articles.no_saved_articles_disclaimer"),
          style: const TextStyle(color: Colors.black),
      ),);
    }

    return ListView.builder(
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        return Text(index.toString());
        /*return DrinkWidget(
          drink: drinks[index],
          isRemovable: true,
          onRemove: (details) => BlocProvider.of<LocalDrinkCubit>(context)
            .removeDrink(drink: drinks[index]),
          onArticlePressed: (drink) => appRouter.push(
            DrinkDetailsRoute(drink: drink)
          ),
        );*/
    });
  }

}