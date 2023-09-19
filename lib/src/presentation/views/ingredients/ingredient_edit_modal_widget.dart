import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_edit_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/constants/constants.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class IngredientEditModalWidget extends StatefulWidget {
  final void Function() onClose;
  final void Function(Map<String, dynamic> data) onSave;
  final Ingredient? currentItem;
  final String title;
  final String errorText;
  final Future<List<Ingredient>> Function(String query) searchMatches;

  const IngredientEditModalWidget({
    Key? key,
    required this.onSave,
    required this.title,
    required this.searchMatches,
    this.onClose = _defaultOnClose,
    this.errorText = "",
    this.currentItem,
  }) : super(key: key);

  static _defaultOnClose() {
    appRouter.pop();
  }

  @override
  State<IngredientEditModalWidget> createState() => _IngredientEditModalWidgetState();
}

class _IngredientEditModalWidgetState extends State<IngredientEditModalWidget> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();
  http.MultipartFile? selectedImage;
  Categories categories = Categories.empty();
  List<IngredientMatch> matches = [];
  final TextEditingController _searchController = TextEditingController();
  List<Ingredient> matchesSearchResults = [];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentItem?.name ?? "";
    descriptionController.text = widget.currentItem?.description ?? "";
    keywordsController.text = widget.currentItem?.categories.keywords.join(",") ?? "";
    categories = widget.currentItem?.categories ?? Categories.empty();
    matches = widget.currentItem?.matches ?? [];
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
        final http.MultipartFile? picture = selectedImage;
        Map<String, dynamic> data = {};
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
        }
        data["matches"] = List<String>.from(matches.map((e) => e.id));
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
        const SizedBox(height: 16,),
        _matchesWidget(),
        _categoriesWidget(),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _matchesWidget() {

    log("matches : $matches");
    List<Widget> matchesWidgetList = List<Widget>.from(matches.map((e) {
      return CustomTextTileWidget(
        text: e.name,
        onTap: () {
          setState(() {
            matches.remove(e);
          });
        },
      );
    }));

    List<Widget> matchesSearchResultsWidgetList = List<Widget>.from(matchesSearchResults.map((e) {
      return CustomTextTileWidget(
        text: e.name,
        textStyle: const TextStyle(fontSize: 12),
        onTap: () {
          IngredientMatch newMatch = IngredientMatch(id: e.id, name: e.name);
          setState(() {
            if (!matches.contains(newMatch)) {
              matches.add(newMatch);
            }
          });
        },
        icon: const Icon(Icons.add, size: 12,),
        backgroundColor: Colors.green,
      );
    }));


    return ExpandablePanel( /// Matches
      header: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ),
      collapsed: const SizedBox(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  hintText: "Search for matches",
                  controller: _searchController,
                  onChanged: (query) async {
                    List<Ingredient> res = await widget.searchMatches.call(query);
                    logger.d("Search :  $res");
                    setState(() {
                      matchesSearchResults = res;
                    });
                  },
                  width: 300,
                  margin: const EdgeInsets.only(left: 4, right: 8),
                ),
                Flexible(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...matchesSearchResultsWidgetList
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...matchesWidgetList
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriesWidget() {
    return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ),
      collapsed: const SizedBox(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _categoryPickerWidget(
              title: "Origins",
              possibleValues: allPossibleCategories.origins,
              currentValues: categories.origins,
              onAdd: (String value) {
                if (!categories.origins.contains(value)) {
                  categories.origins.add(value);
                }
              },
              onRemove : (String value) {
                categories.origins.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Seasons",
              possibleValues: allPossibleCategories.seasons,
              currentValues: categories.seasons,
              onAdd: (String value) {
                if (!categories.seasons.contains(value)) {
                  categories.seasons.add(value);
                }
              },
              onRemove : (String value) {
                categories.seasons.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Colors",
              possibleValues: allPossibleCategories.colors,
              currentValues: categories.colors,
              onAdd: (String value) {
                if (!categories.colors.contains(value)) {
                  categories.colors.add(value);
                }
              },
              onRemove : (String value) {
                categories.colors.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Strengths",
              possibleValues: allPossibleCategories.strengths,
              currentValues: categories.strengths,
              onAdd: (String value) {
                if (!categories.strengths.contains(value)) {
                  categories.strengths.add(value);
                }
              },
              onRemove : (String value) {
                categories.strengths.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Eras",
              possibleValues: allPossibleCategories.eras,
              currentValues: categories.eras,
              onAdd: (String value) {
                if (!categories.eras.contains(value)) {
                  categories.eras.add(value);
                }
              },
              onRemove : (String value) {
                categories.eras.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Diets",
              possibleValues: allPossibleCategories.diets,
              currentValues: categories.diets,
              onAdd: (String value) {
                if (!categories.diets.contains(value)) {
                  categories.diets.add(value);
                }
              },
              onRemove : (String value) {
                categories.diets.remove(value);
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: keywordsController,
                cursorColor: Colors.deepPurple,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Keywords (eg: keyword1,keyword2,keyword3)",
                    labelStyle: TextStyle(fontSize: 12)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryPickerWidget({
    required String title,
    required List<String> possibleValues,
    required List<String> currentValues,
    required void Function(String) onAdd,
    required void Function(String) onRemove,
  }) {

    List<Widget> possibleValuesWidgets = List<Widget>.from(possibleValues.map((e) {
      return CustomTextTileWidget(
        text: e,
        textStyle: const TextStyle(fontSize: 12),
        onTap: () {
          setState(() {
            onAdd.call(e);
          });
        },
        icon: const Icon(Icons.add, size: 12,),
        backgroundColor: Colors.green,
      );
    }));


    List<Widget> currentValuesWidgets = List<Widget>.from(currentValues.map((e) {
      return CustomTextTileWidget(
        text: e,
        textStyle: const TextStyle(fontSize: 12),
        onTap: () {
          setState(() {
            onRemove.call(e);
          });
        },
        icon: const Icon(Icons.close, size: 12,),
        backgroundColor: Colors.blue,
      );
    }));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(),
                ),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 4, right: 4, bottom: 8),
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: [
                    ...possibleValuesWidgets
                  ],
                ),
              ),
            ),
            Expanded(
              child: currentValuesWidgets.isEmpty ?
                  Center(child: Text("No $title selected", style: const TextStyle(color: Colors.grey),)):
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(),
                ),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 4, right: 4, bottom: 8),
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: [
                    ...currentValuesWidgets
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
