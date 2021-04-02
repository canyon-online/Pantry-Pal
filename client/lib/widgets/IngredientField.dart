import 'package:client/models/Ingredient.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientFieldController {
  Set<Ingredient> list = Set();
}

class IngredientField extends StatefulWidget {
  final IngredientFieldController controller;
  IngredientField({required this.controller});

  @override
  IngredientFieldState createState() => IngredientFieldState();
}

class IngredientFieldState extends State<IngredientField> {
  final TextEditingController _ingredient = TextEditingController();

  Widget _buildTextField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        maxLength: 12,
        controller: _ingredient,
        // textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: 'Enter an ingredient',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.only(left: 15.0),
        ));
  }

  void addIngredient(String token, String name) async {
    Ingredient i;

    List<Ingredient> fetchedIngredients =
        await API().getIngredients(token, name);

    if (fetchedIngredients.length == 0) {
      print('Could not find $name in the database. Creating it.');
      var response = await API().submitIngredient(token, name);
      i = Ingredient.fromJson(response);
    } else {
      print('Found ${fetchedIngredients[0]} in the database.');
      i = fetchedIngredients[0];
    }

    setState(() {
      widget.controller.list.add(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<UserProvider>(context).user.token;
    return Container(
      child: Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField()),
              IconButton(
                icon: Icon(
                  Icons.add,
                  // color: widget.controller.list.length < 3
                  //     ? Colors.black
                  //     : Colors.grey,
                ),
                tooltip: 'Add the selected tag',
                onPressed: () {
                  addIngredient(token, _ingredient.text);
                  _ingredient.clear();
                  print(widget.controller.list);
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
