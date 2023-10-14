import 'package:flutter/material.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final double width;
  final int debounceDelay;
  final EdgeInsets margin;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = "Search",
    this.width = 400,
    this.debounceDelay = 500,
    this.margin = EdgeInsets.zero
  });

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: debounceDelay);

    return Container(
      width: width,
      margin: margin,
      child: SearchBar(
        controller: controller,
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
        hintText : hintText,
        hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.grey)),
        onChanged: (query) {
          debouncer.debounce(() {
            onChanged.call(query);
          });
        },
        leading: const Icon(Icons.search),
      ),
    );
  }
}