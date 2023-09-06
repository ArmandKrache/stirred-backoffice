import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses_list_request.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_data_table_widget.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glass_create_modal_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/description_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/picture_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


@RoutePage()
class GlassDetailsView extends HookWidget {
  final Glass glass;

  const GlassDetailsView({Key? key, required this.glass}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    final glassDetailsCubit = BlocProvider.of<GlassesCubit>(context);

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
                color: Colors.deepPurpleAccent,
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add, color: Colors.white,),
                    Text("Button", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                  ],
                ),
              ),
              onPressed: () async {

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
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PictureAttributeWidget(src : glass.picture!),
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