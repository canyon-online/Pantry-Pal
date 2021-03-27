import 'dart:convert';

import 'package:client/models/Ingredient.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IngredientFieldController {
  List<String> list = [];
}

class IngredientField extends StatefulWidget {
  final IngredientFieldController controller;

  IngredientField({required this.controller});

  @override
  IngredientFieldState createState() => IngredientFieldState();
}

class IngredientFieldState extends State<IngredientField> {
  @override
  build(BuildContext context) {
    return DropdownSearch<Ingredient>(
      label: 'Name',
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        labelText: "Search a name",
      ),
      onFind: (String filter) async {
        var response = await http.get(
          Uri.https('5d85ccfb1e61af001471bf60.mockapi.io', '/user',
              {'filter': filter}),
        );
        return Ingredient.fromJsonList(json.decode(response.body));
      },
      onChanged: print,
    );
  }
}
