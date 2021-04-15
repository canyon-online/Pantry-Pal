import 'package:client/models/Ingredient.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/IngredientModel.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientSelecter extends StatefulWidget {
  @override
  IngredientSelecterState createState() => IngredientSelecterState();
}

class IngredientSelecterState extends State<IngredientSelecter> {
  late Ingredient? selectedIngredient;

  void handleOnChange(Ingredient? value) {
    if (value == null) return;
    setState(() {
      selectedIngredient = value;
    });
  }

  Widget _buildDropDown(context) {
    String token = Provider.of<UserProvider>(context, listen: false).user.token;
    return DropdownSearch<Ingredient>(
      label: 'Ingredient',
      showSearchBox: true,
      dropdownSearchDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15),
        // labelText: 'Search an ingredient',
      ),
      searchBoxDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        labelText: 'Search an ingredient',
      ),
      onFind: (String filter) async {
        return API().getIngredients(token, filter);
      },
      onChanged: handleOnChange,
    );
  }

  @override
  build(BuildContext context) {
    IngredientModel ingredients =
        Provider.of<IngredientModel>(context, listen: false);
    return Container(
      child: Column(children: [
        Row(children: [
          Expanded(child: _buildDropDown(context)),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add the selected ingredient',
            onPressed: () {
              setState(() {
                if (selectedIngredient != null)
                  ingredients.add(selectedIngredient!);
              });
            },
          )
        ]),
        Wrap(
          spacing: 5,
          runSpacing: -15,
          children: ingredients.ingredients
              .map((item) => Wrap(
                      spacing: -10,
                      runSpacing: -10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextPill(item.name),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          tooltip: 'Remove this ingredient',
                          onPressed: () {
                            setState(() {
                              ingredients.remove(item);
                            });
                          },
                        )
                      ]))
              .toList(),
        )
      ]),
    );
  }
}
