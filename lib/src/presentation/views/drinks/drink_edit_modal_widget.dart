import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/categories_edit_field_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_edit_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/generic_object_picker_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:cocktail_app/src/utils/resources/utils_data_functions.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class DrinkEditModalWidget extends StatefulWidget {
  final void Function() onClose;
  final void Function(Map<String, dynamic> data) onSave;
  final Drink? currentItem;
  final String title;
  final String errorText;

  const DrinkEditModalWidget({
    Key? key,
    required this.onSave,
    required this.title,
    this.onClose = _defaultOnClose,
    this.errorText = "",
    this.currentItem,
  }) : super(key: key);

  static _defaultOnClose() {
    appRouter.pop();
  }

  @override
  State<DrinkEditModalWidget> createState() => _DrinkEditModalWidgetState();
}

class _DrinkEditModalWidgetState extends State<DrinkEditModalWidget> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();
  String recipeId = "";
  String glassId = "";
  String authorId = "";
  Categories categories = Categories.empty();
  http.MultipartFile? selectedImage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentItem?.name ?? "";
    descriptionController.text = widget.currentItem?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final Widget picturePreviewWidget;

    if (selectedImage == null &&  widget.currentItem != null) {
      picturePreviewWidget = Image.network(widget.currentItem!.picture, width: 32, height: 32,);
    } else {
      picturePreviewWidget = Text(selectedImage == null ? "No picture selected yet" :
      selectedImage!.filename ?? "",
        style: const TextStyle(color: Colors.grey),
      );
    }

    return CustomGenericEditModalWidget(
      title: widget.title,
      onClose: widget.onClose,
      errorText: widget.errorText,
      onSave: () {
        /// TODO : Handle data sending
        Map<String, dynamic> data = {};
        /*
        final http.MultipartFile? picture = selectedImage;
        if (nameController.text == "" ||
            descriptionController.text == "") {
          /// TODO: display error toast
          return ;
        }
        data["name"] = nameController.text;
        data["description"] = descriptionController.text;

        if (picture != null) {
          final MultipartFile multipartFilePicture = MultipartFile.fromStream(
                () => picture.finalize(),
            picture.length,
            filename: picture.filename,
            contentType: picture.contentType,
          );
          data["picture"] = multipartFilePicture;
        }*/

        logger.d(data.toString());
        widget.onSave.call(data);
      },
      children: [
        const SizedBox(height: 16,),
        TextField(
          controller: nameController,
          cursorColor: Colors.deepPurple,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5),
              ),
              fillColor: Colors.white,
              filled: true,
              labelText: "Name"
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller: descriptionController,
          cursorColor: Colors.deepPurple,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: "Description",
          ),
          maxLines: 5,
          keyboardType: TextInputType.multiline,
        ),
        /// TODO: add other fields Widgets
        const SizedBox(height: 8,),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                uploadInput.click();
                uploadInput.onChange.listen((event) {
                  final file = uploadInput.files!.first;
                  final reader = html.FileReader();
                  reader.onLoadEnd.listen((loadEndEvent) async {
                    final Uint8List data = reader.result as Uint8List;
                    final image = http.MultipartFile.fromBytes(
                      'picture',
                      data,
                      filename: file.name,
                    );
                    setState(() {
                      selectedImage = image;
                    });
                  });
                  reader.readAsArrayBuffer(file);
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
              child: const Text('Select Picture'),
            ),
            const SizedBox(width: 16,),
            picturePreviewWidget,
          ],
        ),
        const SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton( /// Recipe
              onPressed: () async {
                String? res = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      searchFunction: (String query) async {
                        List<Recipe> recipes = await searchRecipes(query);
                        return recipes;
                      },
                      currentItem: widget.currentItem?.recipe,
                    ),
                  ),
                );
                if (res != null) {
                  recipeId = res;
                  logger.d(recipeId);
                }
              },
              child: const Text("Recipe"),
            ),
            ElevatedButton( /// Glass
              onPressed: () async {
                String? res = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      searchFunction: (String query) async {
                        List<Glass> glasses = await searchGlasses(query);
                        return glasses;
                      },
                      currentItem: widget.currentItem?.glass,
                    ),
                  ),
                );
                if (res != null) {
                  glassId = res;
                  logger.d(glassId);
                }
              },
              child: const Text("Glass"),
            ),
            ElevatedButton( /// Author
              onPressed: () async {
                String? res = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      searchFunction: (String query) async {
                        List<Profile> profiles = await searchProfiles(query);
                        return profiles;
                      },
                      currentItem: widget.currentItem?.author,
                    ),
                  ),
                );
                if (res != null) {
                  authorId = res;
                  logger.d(authorId);
                }
              },
              child: const Text("Author"),
            ),
          ],
        ),
        const SizedBox(height: 8,),
        CategoriesEditFieldWidget(
          categories: categories,
          keywordsController: keywordsController,
        ),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _ingredientsWidget() {
    return const SizedBox();
  }


}
