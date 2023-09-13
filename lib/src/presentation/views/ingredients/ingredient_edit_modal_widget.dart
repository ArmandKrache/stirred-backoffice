import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
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

  const IngredientEditModalWidget({
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
  State<IngredientEditModalWidget> createState() => _IngredientEditModalWidgetState();
}

class _IngredientEditModalWidgetState extends State<IngredientEditModalWidget> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();
  http.MultipartFile? selectedImage;
  Categories? categories;
  List<String> matches = [];

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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
            minHeight: 300,
            minWidth: 200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onClose,
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.close, size: 24,),
                    ),
                  ),
                  Text(widget.title),
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
              ExpandablePanel( /// Matches
                header: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                collapsed: const SizedBox(),
                expanded: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          CustomTextTileWidget(
                            text: "Name",
                            onTap: () {
                              log("TIP TAP");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              /// Categories
              ExpandablePanel(
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
                          labelText: "Keywords (keyword1,keyword2,...",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(widget.errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final http.MultipartFile? picture = selectedImage;
                      Map<String, dynamic> data = {};
                      data["name"] = nameController.text;
                      data["description"] = descriptionController.text;
                      categories?.keywords.addAll(keywordsController.text.split(","));

                      if (picture != null) {
                        final MultipartFile multipartFilePicture = MultipartFile.fromStream(
                              () => picture.finalize(),
                          picture.length,
                          filename: picture.filename,
                          contentType: picture.contentType,
                        );
                        data["picture"] = multipartFilePicture;
                      }

                      log(data.toString());
                      widget.onSave.call(data);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
