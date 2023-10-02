import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_edit_modal.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_text_tile.dart';
import 'package:cocktail_app/src/presentation/widgets/search_bar_widget.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:cocktail_app/src/utils/resources/utils_data_functions.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class RecipeEditModalWidget extends StatefulWidget {
  final void Function() onClose;
  final void Function(Map<String, dynamic> data) onSave;
  final Recipe? currentItem;
  final String title;
  final String errorText;

  const RecipeEditModalWidget({
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
  State<RecipeEditModalWidget> createState() => _RecipeEditModalWidgetState();
}

class _RecipeEditModalWidgetState extends State<RecipeEditModalWidget> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final prepTimeController = TextEditingController();
  final instructionsController = TextEditingController();
  String difficulty = allPossibleDifficulties.first;
  List<RecipeIngredient> ingredients = [];
  int preparationTime = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Ingredient> ingredientsSearchResults = [];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentItem?.name ?? "";
    descriptionController.text = widget.currentItem?.description ?? "";
    instructionsController.text = widget.currentItem?.instructions ?? "";
    ingredients = widget.currentItem?.ingredients ?? [];
    difficulty = widget.currentItem?.difficulty ?? allPossibleDifficulties.first;
    preparationTime = widget.currentItem?.preparationTime ?? 0;
    prepTimeController.text = preparationTime.toString();
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
        if (nameController.text == "" ||
            descriptionController.text == "" ||
            instructionsController.text == "" ||
            ingredients.isEmpty
        ) {
          /// TODO: display error toast
          return ;
        }
        data["name"] = nameController.text;
        data["description"] = descriptionController.text;
        data["instructions"] = instructionsController.text;
        data["difficulty"] = difficulty;
        data["preparation_time"] = int.parse(prepTimeController.text);
        data["ingredients"] = List<Map<String, dynamic>>.from(ingredients.map((e) {
          return {
            "ingredient" : e.ingredientId,
            "unit" : e.unit,
            "quantity" : e.quantity
          };
        }));
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
        const SizedBox(height: 12,),
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
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 12,),
        TextField(
          controller: prepTimeController,
          cursorColor: Colors.deepPurple,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5),
              ),
              fillColor: Colors.white,
              filled: true,
              labelText: "Preparation Time (in minutes)"
          ),
        ),
        const SizedBox(height: 12,),
        _difficultyWidget(),
        const SizedBox(height: 12,),
        TextField(
          controller: instructionsController,
          cursorColor: Colors.deepPurple,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: "Instructions",
          ),
          maxLines: 5,
          keyboardType: TextInputType.multiline,
        ),
        /// ingredients list with search + free numberfield for quantity + unit choices (single key)
        const SizedBox(height: 12,),
        _ingredientsWidget(),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _ingredientsWidget() {
    List<Widget> ingredientsSearchResultsWidgetList = List<Widget>.from(ingredientsSearchResults.map((e) {
      return CustomTextTileWidget(
        text: e.name,
        textStyle: const TextStyle(fontSize: 12),
        onTap: () {
          RecipeIngredient newIngredient = RecipeIngredient(
            ingredientId: e.id,
            ingredientName: e.name,
            quantity: 0,
            unit: allPossibleUnits.first
          );
          setState(() {
            if (!ingredients.contains(newIngredient)) {
              ingredients.add(newIngredient);
            }
          });
        },
        icon: const Icon(Icons.add, size: 12,),
        backgroundColor: Colors.green,
      );
    }));

    return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
                    List<Ingredient> res = await searchIngredients(query);
                    logger.d("Search : $res");
                    setState(() {
                      ingredientsSearchResults = res;
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
                      ...ingredientsSearchResultsWidgetList
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12,),
            Column(
              children: [
                for (var item in ingredients)
                  _recipeIngredientWidget(item)
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _recipeIngredientWidget(RecipeIngredient item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 256),
                child: Text(item.ingredientName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                )
            ),
          ),
          const SizedBox(width: 12,),
          SizedBox(
            width: 96,
            height: 48,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  ingredients.firstWhere((element) => element == item).quantity = double.parse(value);
                });
              },
              cursorColor: Colors.deepPurple,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0123456789.]'))
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Quantity"
              ),
            ),
          ),
          const SizedBox(width: 12,),
          PopupMenuButton<String>(
            initialValue: item.unit,
            onSelected: (String newUnit) {
              setState(() {
                ingredients.firstWhere((element) => element == item).unit = newUnit;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                for (var unit in allPossibleUnits)
                  PopupMenuItem<String>(
                    value: unit,
                    child: Text(getUnitTitle(unit)),
                  )
              ];
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurpleAccent),
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
              padding: const EdgeInsets.all(8),
              child: Center(child: Text(getUnitTitle(item.unit), style: const TextStyle(fontSize: 16),)),
            ),
          ),
          const Expanded(
            flex: 3,
              child: SizedBox(),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                ingredients.remove(item);
              });
            },
            icon: const Icon(Icons.delete, color: Colors.redAccent,),
            padding: const EdgeInsets.all(4),
            splashRadius: 16,
          )
        ],
      ),
    );
  }

  Widget _difficultyWidget() {
    return Wrap(
      spacing: 8,
      runSpacing: 16,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center ,
      children: [
        for (var di in allPossibleDifficulties)
          ElevatedButton(
              onPressed: () {
                setState(() {
                  difficulty = di;
                });
              },
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: difficulty == di ?
                  MaterialStateProperty.all(getDifficultyColor(di).withOpacity(0.7)) :
                  MaterialStateProperty.all(Colors.grey.shade300)
          ),
              child: Text(
                getDifficultyTitle(di),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: difficulty == di ?
                    Colors.white :
                    Colors.grey.shade500
                ),
              )
          ),
        const SizedBox(width: 8,),
      ],
    );
  }


}
