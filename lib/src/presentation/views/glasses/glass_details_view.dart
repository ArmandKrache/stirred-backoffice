import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glass_edit_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/description_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/picture_attribute_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


@RoutePage()
class GlassDetailsView extends HookWidget {
  final Glass glass;

  const GlassDetailsView({Key? key, required this.glass}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    final glassDetailsCubit = BlocProvider.of<GlassDetailsCubit>(context);

    useEffect(() {
      glassDetailsCubit.handleEvent(event: GlassDetailsSetGlassEvent(glass: glass));
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              glass.name ?? "",
              style: const TextStyle(color: Colors.black),
            ),
            SelectableText(
              "${glass.id}",
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 28),
        actions: [
          TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1)),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.redAccent,
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.delete, color: Colors.white,),
                    Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                  ],
                ),
              ),
              onPressed: () async {
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Center(child: Text("Warning", style: TextStyle(fontWeight: FontWeight.bold),)),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 156, maxHeight: 284,
                        minWidth: 400, maxWidth: 800,
                      ),
                      child: Center(child: Text(
                        "You are about to delete this ${glass.runtimeType.toString()} item.\n"
                            "This action is definitive, Are you sure ?",
                        style: const TextStyle(fontSize: 18),
                      ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            appRouter.pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            side: MaterialStateProperty.all(const BorderSide(color: Colors.black))
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Cancel", style: TextStyle(fontSize: 18, color: Colors.black),)
                          ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          glassDetailsCubit.handleEvent(
                            event : GlassDeleteEvent(request : GlassDeleteRequest(id: glass.id))
                          );
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Confirm", style: TextStyle(fontSize: 18, color: Colors.white),)
                        ),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                );
                if (glassDetailsCubit.state.runtimeType == GlassDeleteSuccess) {
                  appRouter.pop("deleted");
                }
              }
          ),
        ],
      ),
      body: BlocBuilder<GlassDetailsCubit, GlassDetailsState>(
          builder: (context, state) {
            if (state.runtimeType == GlassDetailsLoading) {
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
                        PictureAttributeWidget(src : glass.picture!),
                        const SizedBox(width: 16,),
                        DescriptionAttributeWidget(text : glass.description!),
                      ],
                    ),
                  ],
                )
              );
            }
          }),
    );
  }
}