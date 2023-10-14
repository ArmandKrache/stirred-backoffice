
import 'package:auto_route/auto_route.dart';
import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/views/glasses/glass_edit_modal_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/custom_generic_delete_alert_dialog_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/description_attribute_widget.dart';
import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/picture_attribute_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';


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
        title: BlocBuilder<GlassDetailsCubit, GlassDetailsState>(
          builder: (context, state) {
            return Column(
                  children: [
                    Text(state.glass?.name ?? "",
                      style: const TextStyle(color: Colors.black),
                    ),
                    SelectableText(
                      "${state.glass?.id}",
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
                        child: _editGlassModal(context, glassDetailsCubit)
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
                        item: glassDetailsCubit.state.glass,
                        onCancel: () {
                          appRouter.pop();
                        },
                        onConfirm: () {
                          glassDetailsCubit.handleEvent(
                              event : GlassDeleteEvent(request : GlassDeleteRequest(id: glassDetailsCubit.state.glass?.id))
                          );
                        },
                      ),
                    );
                    if (glassDetailsCubit.state.runtimeType == GlassDeleteSuccess) {
                      appRouter.pop("deleted");
                    }
                  }
              ),
            ],
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
                        PictureAttributeWidget(src : state.glass!.picture),
                        const SizedBox(width: 16,),
                        DescriptionAttributeWidget(text : state.glass!.description),
                      ],
                    ),
                  ],
                )
              );
            }
          }),
    );
  }
  
  Widget _editGlassModal(BuildContext context, GlassDetailsCubit glassDetailsCubit) {
    return GlassEditModalWidget(
      onSave: (data) async {
        await glassDetailsCubit.patchGlass(glassDetailsCubit.state.glass!.id, data);
      },
      title: "Edit Glass",
      currentItem: glassDetailsCubit.state.glass,
    );
  }
}