import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class CategoriesEditFieldWidget extends StatefulWidget {
  final Categories categories;
  final TextEditingController keywordsController;

  const CategoriesEditFieldWidget({
    super.key,
    required this.categories,
    required this.keywordsController,
  });


  @override
  State<CategoriesEditFieldWidget> createState() => _CategoriesEditFieldWidgetState();
}

class _CategoriesEditFieldWidgetState extends State<CategoriesEditFieldWidget> {

  @override
  Widget build(BuildContext context) {
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
              currentValues: widget.categories.origins,
              onAdd: (String value) {
                if (!widget.categories.origins.contains(value)) {
                  widget.categories.origins.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.origins.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Seasons",
              possibleValues: allPossibleCategories.seasons,
              currentValues: widget.categories.seasons,
              onAdd: (String value) {
                if (!widget.categories.seasons.contains(value)) {
                  widget.categories.seasons.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.seasons.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Colors",
              possibleValues: allPossibleCategories.colors,
              currentValues: widget.categories.colors,
              onAdd: (String value) {
                if (!widget.categories.colors.contains(value)) {
                  widget.categories.colors.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.colors.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Strengths",
              possibleValues: allPossibleCategories.strengths,
              currentValues: widget.categories.strengths,
              onAdd: (String value) {
                if (!widget.categories.strengths.contains(value)) {
                  widget.categories.strengths.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.strengths.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Eras",
              possibleValues: allPossibleCategories.eras,
              currentValues: widget.categories.eras,
              onAdd: (String value) {
                if (!widget.categories.eras.contains(value)) {
                  widget.categories.eras.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.eras.remove(value);
              },
            ),
            _categoryPickerWidget(
              title: "Diets",
              possibleValues: allPossibleCategories.diets,
              currentValues: widget.categories.diets,
              onAdd: (String value) {
                if (!widget.categories.diets.contains(value)) {
                  widget.categories.diets.add(value);
                }
              },
              onRemove : (String value) {
                widget.categories.diets.remove(value);
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: widget.keywordsController,
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