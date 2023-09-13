import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/material.dart';

class CategoriesAttributeWidget extends StatelessWidget {
  final String title;
  final void Function() onSave;
  final Function onClose;
  final String errorText;

  const CategoriesAttributeWidget({
    super.key,
    required this.title,
    required this.onSave,
    this.onClose = _defaultOnClose,
    this.errorText = "",
  });

  static _defaultOnClose() {
    appRouter.pop();
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      onClose.call();
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.close, size: 24,),
                    ),
                  ),
                  Text(title),
                  const SizedBox(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onSave.call();
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