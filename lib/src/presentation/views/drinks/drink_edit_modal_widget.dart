import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/generic_preview_data_model.dart';
import 'package:cocktail_app/src/domain/models/glasses/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:cocktail_app/src/presentation/data/search_functions.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/categories_edit_field_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/custom_generic_edit_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/generic_object_picker_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:cocktail_app/src/utils/resources/utils_functions.dart';
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
  GenericPreviewDataModel recipe = GenericPreviewDataModel.empty();
  GenericPreviewDataModel author = GenericPreviewDataModel.empty();
  Glass glass = Glass.empty();
  Categories categories = Categories.empty();
  http.MultipartFile? selectedImage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentItem?.name ?? "";
    descriptionController.text = widget.currentItem?.description ?? "";
    recipe = widget.currentItem?.recipe ?? GenericPreviewDataModel.empty();
    author = widget.currentItem?.author ?? GenericPreviewDataModel.empty();
    glass = widget.currentItem?.glass ?? Glass.empty();
    categories = widget.currentItem?.categories ?? Categories.empty();
  }

  @override
  Widget build(BuildContext context) {
    final Widget picturePreviewWidget;

    if (selectedImage == null &&  widget.currentItem != null) {
      picturePreviewWidget = Image.network(widget.currentItem!.picture, width: 32, height: 32,);
    } else {
      picturePreviewWidget = Text(selectedImage == null ? "No picture selected yet" :
      selectedImage!.filename ?? "",
        style: TextStyle(color: selectedImage == null ? Colors.grey : Colors.black),
      );
    }

    return CustomGenericEditModalWidget(
      title: widget.title,
      onClose: widget.onClose,
      errorText: widget.errorText,
      onSave: () {
        Map<String, dynamic> data = {};
        final http.MultipartFile? picture = selectedImage;
        if (nameController.text == "" ||
            descriptionController.text == "" ||
            recipe.id == "" ||
            author.id == "" ||
            glass.id == ""
        ) {
          /// TODO: display error toast
          return ;
        }
        data["name"] = nameController.text;
        data["description"] = descriptionController.text;
        data["recipe"] = recipe.id;
        data["author"] = author.id;
        data["glass"] = glass.id;

        if (picture != null) {
          final MultipartFile multipartFilePicture = MultipartFile.fromStream(
                () => picture.finalize(),
            picture.length,
            filename: picture.filename,
            contentType: picture.contentType,
          );
          data["picture"] = multipartFilePicture;
        }

        Map<String, List<String>> categoriesData = {};
        categories.keywords = keywordsController.text.split(",").map((e) => e.trim()).toList();
        categoriesData["origins"] = categories.origins;
        categoriesData["eras"] = categories.eras;
        categoriesData["strengths"] = categories.strengths;
        categoriesData["diets"] = categories.diets;
        categoriesData["seasons"] = categories.seasons;
        categoriesData["colors"] = categories.colors;
        categoriesData["keywords"] = categories.keywords;

        data["categories"] = categoriesData;

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
          children: [
            ElevatedButton( /// Recipe
              onPressed: () async {
                Recipe? res = await showDialog<Recipe>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      title: "Recipe",
                      searchFunction: (String query) async {
                        List<Recipe> recipes = await searchRecipes(query);
                        return recipes;
                      },
                      currentItem: widget.currentItem?.recipe,
                    ),
                  ),
                );
                if (res != null) {
                  setState(() {
                    recipe = GenericPreviewDataModel(id: res.id, name: res.name, description: res.description);
                  });
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
              child: const Text("Select Recipe"),
            ),
            const SizedBox(width: 16,),
            Text(recipe.name ?? "",),
            const SizedBox(width: 4,),
            Text(recipe.id ?? "", style: const TextStyle(color: Colors.grey, fontSize: 10),),
          ],
        ),
        const SizedBox(height: 8,),
        Row(
          children: [
            ElevatedButton( /// Glass
              onPressed: () async {
                Glass? res = await showDialog<Glass>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      title: "Glass",
                      searchFunction: (String query) async {
                        List<Glass> glasses = await searchGlasses(query);
                        return glasses;
                      },
                      currentItem: widget.currentItem?.glass,
                    ),
                  ),
                );
                if (res != null) {
                  setState(() {
                    glass = res;
                  });
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
              child: const Text("Select Glass"),
            ),
            const SizedBox(width: 16,),
            Text(glass.name,),
            const SizedBox(width: 4,),
            Text(glass.id, style: const TextStyle(color: Colors.grey, fontSize: 10),),
          ],
        ),
        const SizedBox(height: 8,),
        Row(
          children: [
            ElevatedButton( /// Author
              onPressed: () async {
                Profile? res = await showDialog<Profile>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: GenericObjectPickerModal(
                      title: "Author",
                      searchFunction: (String query) async {
                        List<Profile> profiles = await searchProfiles(query);
                        return profiles;
                      },
                      currentItem: widget.currentItem?.author,
                    ),
                  ),
                );
                if (res != null) {
                  setState(() {
                    author = GenericPreviewDataModel(id: res.id, name: res.name);
                  });
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
              child: const Text("Select Author"),
            ),
            const SizedBox(width: 16,),
            Text(author.name ?? "",),
            const SizedBox(width: 4,),
            Text(author.id ?? "", style: const TextStyle(color: Colors.grey, fontSize: 10),),
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
