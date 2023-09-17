import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
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
                builder: (BuildContext context) => Dialog(
                  child: _glassCreateModal(context, glassesCubit)
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
                    child: _buildDataTable(state.glasses, glassesCubit)
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildDataTable(List<Glass> glasses, GlassesCubit glassesCubit ) {
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
                  onTap: () async {
                    final deleted = await appRouter.push(GlassDetailsRoute(glass: item));
                    if (deleted == "deleted") {
                      glassesCubit.handleEvent(event: GlassesListEvent(request: GlassesListRequest()));
                    }
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

  Widget _glassCreateModal(BuildContext context, GlassesCubit glassesCubit) {
    final glassCreateCubit = BlocProvider.of<GlassCreateCubit>(context);
    String errorText = "";

    return BlocBuilder<GlassCreateCubit, GlassCreateState>(
        builder: (context, state) {
          if (state.runtimeType == GlassCreateSuccess) {
            glassCreateCubit.reset();
            appRouter.pop(context);
            glassesCubit.handleEvent(event: GlassesListEvent(request: GlassesListRequest()));
            return const SizedBox();
          } else if (state.runtimeType == GlassCreateFailed) {
            errorText = "Some fields are missing";
          }
          return GlassEditModalWidget(
            onClose: () {
              glassCreateCubit.reset();
              appRouter.pop(context);
            },
            onSave: (Map<String, dynamic> data) {
              glassCreateCubit.createGlass(data);
            },
            title: "New Glass",
            errorText: errorText,
          );
        }
    );
  }

}