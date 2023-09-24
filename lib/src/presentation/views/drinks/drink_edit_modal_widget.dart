import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_edit_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
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
        _ingredientsWidget(),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _ingredientsWidget() {
    return const SizedBox();
  }


}
