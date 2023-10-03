import 'package:flutter/material.dart';

class CustomGenericAttributeWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final Color backgroundColor;

  const CustomGenericAttributeWidget({
    super.key,
    this.title = "",
    this.child = const SizedBox(),
    this.backgroundColor = Colors.deepPurpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12),),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.3),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: child,
        ),
      ],
    );
  }
}