import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses_list_request.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/glass_create_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


@RoutePage()
class GlassesView extends HookWidget {
  const GlassesView({Key? key}) : super (key: key);



  @override
  Widget build(BuildContext context) {
    final glassesCubit = BlocProvider.of<GlassesCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      glassesCubit.handleEvent(event: GlassesListEvent(request: GlassesListRequest()));
      return;
    }, []);


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Glasses",
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
                builder: (BuildContext context) => const Dialog(
                  child: GlassCreateModalWidget(),
                ),
              );
            }
          ),
        ],
      ),
      body: BlocBuilder<GlassesCubit, GlassesState>(
          builder: (context, state) {
            if (state.runtimeType == GlassesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.glasses.isEmpty) {
              return const Center(child: Text("Glasses list is empty"),);
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
                    child: _buildDataTable(state.glasses)
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildDataTable(List<Glass> glasses) {
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
        data: glasses,
        buildRow: (item) {
          return DataRow(
            cells: [
              DataCell(
                SelectableText.rich(TextSpan(
                  text: item.id ?? "",
                  style: const TextStyle(color: Colors.blue,),
                  mouseCursor: SystemMouseCursors.click,
                ),
                  onTap: () {
                    log("Clicked : ${item.id ?? ""}");
                  },
                ),
              ),
              DataCell(SelectableText(item.name ?? "")),
              DataCell(Container(
                width: 300,
                child: SelectableText(item.description ?? "",
                  style: const TextStyle(), maxLines: 2,),
              )
              ),
            ],
          );
        },
      ),
    );
  }
}