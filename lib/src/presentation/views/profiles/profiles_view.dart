import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

@RoutePage()
class ProfilesView extends HookWidget {
  const ProfilesView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final profilesCubit = BlocProvider.of<ProfilesCubit>(context);
    final scrollController = useScrollController();
    final TextEditingController _searchController = TextEditingController();


    useEffect(() {
      profilesCubit.handleEvent(event: ProfileListEvent(request: ProfileListRequest()));
      return ;
    }, []);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profiles",
            style: TextStyle(color: Colors.black),
          ),
          actions: const [],
        ),
      body: BlocBuilder<ProfilesCubit, ProfilesState>(
          builder: (context, state) {
            if (state.runtimeType == ProfilesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.profiles.isEmpty) {
              return const Center(child: Text("Profile list is empty"),);
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
                  BlocBuilder<ProfilesCubit, ProfilesState>(
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case ProfilesLoading:
                            return const Center(child: CupertinoActivityIndicator());
                          case ProfilesFailed:
                            return const Center(child: Icon(Ionicons.refresh));
                          case ProfilesSuccess:
                            return Expanded(
                              child: _buildDataTable(state.profiles)
                            );
                          default:
                            return const SizedBox();
                        }
                      }
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildDataTable(List<Profile> profiles) {
    const column = <DataColumn>[
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
            'Email',
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
            'Date of Birth',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
    ];

    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomGenericDataTableWidget(
        columns: column,
        data: profiles,
        buildRow: (item) {
          return DataRow(
            cells: [
              DataCell(
                SelectableText.rich(TextSpan(
                  text: item.id,
                  style: const TextStyle(color: Colors.blue,),
                  mouseCursor: SystemMouseCursors.click,
                ),
                  onTap: () {
                    appRouter.push(ProfileDetailsRoute(profile: item));
                  },
                ),
              ),
              DataCell(SelectableText(item.name)),
              DataCell(SelectableText(item.email)),
              DataCell(SizedBox(
                width: 300,
                child: SelectableText(item.description,
                  style: const TextStyle(), maxLines: 2,),
              )
              ),
              DataCell(SelectableText(item.dateOfBirth)),
            ],
          );
        },
      ),
    );
  }


}