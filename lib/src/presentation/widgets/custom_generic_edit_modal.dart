import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:flutter/material.dart';

class CustomGenericEditModalWidget extends StatelessWidget {
  final String title;
  final void Function() onSave;
  final Function onClose;
  final String errorText;
  final List<Widget> children;

  const CustomGenericEditModalWidget({
    super.key,
    required this.title,
    required this.onSave,
    this.onClose = _defaultOnClose,
    this.errorText = "",
    this.children = const [],
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
              ...children,
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