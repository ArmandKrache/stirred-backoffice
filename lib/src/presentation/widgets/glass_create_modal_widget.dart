import 'dart:io';

import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class GlassCreateModalWidget extends StatelessWidget {

  const GlassCreateModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final glassCreateCubit = BlocProvider.of<GlassCreateCubit>(context);

    return BlocBuilder<GlassCreateCubit, GlassCreateState>(
      builder: (context, state) {
        if (state.runtimeType == GlassCreateSuccess) {
          glassCreateCubit.reset();
          Navigator.pop(context);
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      glassCreateCubit.reset();
                      Navigator.pop(context);
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.close, size: 24,),
                    ),
                  ),
                  const Text("New Glass"),
                  const SizedBox(),
                ],
              ),
              const SizedBox(height: 16,),
              TextField(
                controller: nameController,
                cursorColor: Colors.deepPurple,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 8,),
              TextField(
                controller: descriptionController,
                cursorColor: Colors.deepPurple,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Description',
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

                      if (pickedImage != null) {
                        glassCreateCubit.setSelectedImage(File(pickedImage.path));
                      }
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
                    child: const Text('Select Picture'),
                  ),
                  const SizedBox(width: 8,),
                  state.selectedImage != null ?
                  Image.network(state.selectedImage!.path, width: 96, height: 96,) :
                  const Text("No picture selected yet"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Visibility(
                    visible: state.runtimeType == GlassCreateFailed,
                    child: const Text("Missing required fields", style: TextStyle(color: Colors.red),),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      glassCreateCubit.createGlass(
                          {
                            "name" : nameController.text,
                            "description" : descriptionController.text,
                            "picture" : state.selectedImage,
                          }
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            nameController.text != "" && descriptionController.text != "" && state.selectedImage != null  ?
                            Colors.green : Colors.grey
                        ),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16))
                    ),
                    child: const Text('Create', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}