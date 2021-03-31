import 'dart:convert';
import 'dart:io';
import 'package:client/models/Ingredient.dart';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    User user = Provider.of<UserProvider>(context, listen: false).user;
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
            Uri.https(API.baseURL, API.searchIngredient, {'name': filter}),
            headers: {HttpHeaders.authorizationHeader: 'bearer ' + user.token});
        return Ingredient.fromJsonList(
            json.decode(response.body)['ingredients']);
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
                ]);
              }),
        )
      ]),
    );
  }
}
