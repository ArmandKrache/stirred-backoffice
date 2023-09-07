import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/material.dart';

class CustomGenericAlertDialogWidget extends StatelessWidget {
  final dynamic item;
  final Function onCancel;
  final Function onConfirm;

  const CustomGenericAlertDialogWidget({
    super.key,
    required this.item,
    required this.onConfirm,
    required this.onCancel

  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("Warning", style: TextStyle(fontWeight: FontWeight.bold),)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 156, maxHeight: 284,
          minWidth: 400, maxWidth: 800,
        ),
        child: Center(child: Text(
          "You are about to delete this ${item.runtimeType.toString()} item.\n"
              "This action is definitive, Are you sure ?",
          style: const TextStyle(fontSize: 18),
        ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        ElevatedButton(
          onPressed: () {
            onCancel.call();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all(const BorderSide(color: Colors.black))
          ),
          child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Cancel", style: TextStyle(fontSize: 18, color: Colors.black),)
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm.call();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Confirm", style: TextStyle(fontSize: 18, color: Colors.white),)
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}