import 'package:client/models/Ingredient.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientFieldController {
  Set<Ingredient> list = Set();
  late Ingredient selectedIngredient;
}

class IngredientField extends StatefulWidget {
  final IngredientFieldController controller;
  IngredientField({required this.controller});

  @override
  IngredientFieldState createState() => IngredientFieldState();
}

class IngredientFieldState extends State<IngredientField> {
  void handleOnChange(Ingredient? value) {
    setState(() {
      widget.controller.selectedIngredient = value!;
    });
  }

  Widget _buildDropDown(context) {
    String token = Provider.of<UserProvider>(context, listen: false).user.token;
    return DropdownSearch<Ingredient>(
      label: 'Ingredient',
      showSearchBox: true,
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
    return Container(
      child: Column(children: [
        Row(children: [
          Expanded(child: _buildDropDown(context)),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add the selected ingredient',
            onPressed: () {
              setState(() {
                widget.controller.list
                    .add(widget.controller.selectedIngredient);
                print(widget.controller.list);
              });
            },
          )
        ]),
        Wrap(
          spacing: 5,
          runSpacing: -15,
          children: widget.controller.list
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
                              widget.controller.list.remove(item);
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
