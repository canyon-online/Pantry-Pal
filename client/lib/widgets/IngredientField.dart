import 'dart:convert';
import 'package:client/models/Ingredient.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IngredientFieldController {
  Set<String> list = Set();
  late String selectedIngredient;
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
      widget.controller.selectedIngredient = value!.name;
    });
  }

  Widget _buildDropDown() {
    return DropdownSearch<Ingredient>(
      label: 'Ingredient',
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        labelText: 'Search an ingredient',
      ),
      onFind: (String filter) async {
        var response = await http.get(
          Uri.https('5d85ccfb1e61af001471bf60.mockapi.io', '/user',
              {'filter': filter}),
        );
        return Ingredient.fromJsonList(json.decode(response.body));
      },
      onChanged: handleOnChange,
    );
  }

  @override
  build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(children: [
          Expanded(child: _buildDropDown()),
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
        // Using a ListView builder here is extremely dubious and might cause
        // some problems in the future.
        Container(
          height: widget.controller.list.length * 50 < 150
              ? widget.controller.list.length * 50
              : 150,
          child: ListView.builder(
              itemCount: widget.controller.list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = widget.controller.list.elementAt(index);
                return Row(children: [
                  TextPill(item),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: 'Remove this ingredient',
                    onPressed: () {
                      setState(() {
                        widget.controller.list.remove(item);
                      });
                    },
                  )
                ]);
              }),
        )
      ]),
    );
  }
}
