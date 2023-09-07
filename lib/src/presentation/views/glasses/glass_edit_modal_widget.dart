import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class GlassEditModalWidget extends StatefulWidget {
  final void Function() onClose;
  final void Function(Map<String, dynamic> data) onSave;
  final Glass? currentItem;
  final String title;
  final String errorText;

  const GlassEditModalWidget({
    Key? key,
    required this.onClose,
    required this.onSave,
    required this.title,
    this.errorText = "",
    this.currentItem,
  }) : super(key: key);

  @override
  State<GlassEditModalWidget> createState() => _GlassEditModalWidgetState();
}

class _GlassEditModalWidgetState extends State<GlassEditModalWidget> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  http.MultipartFile? selectedImage;

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

    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 600,
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
              labelText: "Username"
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
    );
  }
}
