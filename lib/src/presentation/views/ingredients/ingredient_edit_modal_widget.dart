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
  Categories? categories;
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
        data["name"] = nameController.text;
        data["description"] = descriptionController.text;
        categories?.keywords.addAll(keywordsController.text.split(",").map((e) => e.trim()).toList());

        if (picture != null) {
          final MultipartFile multipartFilePicture = MultipartFile.fromStream(
                () => picture.finalize(),
            picture.length,
            filename: picture.filename,
            contentType: picture.contentType,
          );
          data["picture"] = multipartFilePicture;
        }
        /// TODO: add Matches and categories to data

        log(data.toString());
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
        /// TODO: Matches selector widget
        _matchesWidget(),
        _categoriesWidget(),
        const SizedBox(height: 16,),
      ],
    );
  }

  /// TODO Matches
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

  /// TODO Categories
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
            TextField(
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
          ],
        ),
      ),
    );
  }
}
