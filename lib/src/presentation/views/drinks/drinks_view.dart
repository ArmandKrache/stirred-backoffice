
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/presentation/cubits/drinks/drink_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/drinks/drinks_cubit.dart';
import 'package:cocktail_app/src/presentation/views/drinks/drink_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class DrinksView extends HookWidget {
  const DrinksView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final drinksCubit = BlocProvider.of<DrinksCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      drinksCubit.fetchList(request: DrinksListRequest());
      return ;
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
                    child: _drinkCreateModal(context, drinksCubit)
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DrinksCubit, DrinksState>(
          builder: (context, state) {
            if (state.runtimeType == DrinksLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.drinks.isEmpty) {
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
                      child: _buildDataTable(state.drinks, drinksCubit)
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildDataTable(List<Drink> drinks, DrinksCubit drinksCubit ) {
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
        data: drinks,
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
                    final deleted = await appRouter.push(DrinkDetailsRoute(drink: item));
                    if (deleted == "deleted") {
                      drinksCubit.fetchList(request: DrinksListRequest());
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


  Widget _drinkCreateModal(BuildContext context, DrinksCubit drinksCubit) {
    final drinkCreateCubit = BlocProvider.of<DrinkCreateCubit>(context);
    String errorText = "";

    return BlocBuilder<DrinkCreateCubit, DrinkCreateState>(
        builder: (context, state) {
          if (state.runtimeType == DrinkCreateSuccess) {
            drinkCreateCubit.reset();
            appRouter.pop();
            drinksCubit.fetchList(request: DrinksListRequest());
            return const SizedBox();
          } else if (state.runtimeType == DrinkCreateFailed) {
            errorText = "Some fields are missing";
          }
          return DrinkEditModalWidget(
            onClose: () {
              drinkCreateCubit.reset();
              appRouter.pop();
            },
            onSave: (Map<String, dynamic> data) {
              drinkCreateCubit.createDrink(data);
            },
            title: "New Drink",
            errorText: errorText,
          );
        }
    );
  }
}