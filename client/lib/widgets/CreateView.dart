import 'dart:convert';
import 'dart:io';

import 'package:client/models/Ingredient.dart';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/ImageButton.dart';
import 'package:client/widgets/IngredientField.dart';
import 'package:client/widgets/TagField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateView extends StatefulWidget {
  @override
  CreateViewState createState() => CreateViewState();
}

// Creates a state class relating to the addRecipeForm widget
class CreateViewState extends State<CreateView> {
  // Ingredient list & get, add, remove, and console print fxns
  List<String> ingredients = ['carrot', 'second carrot', 'something else'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _directions = TextEditingController();
  final IngredientFieldController _ingredients = IngredientFieldController();
  final TagFieldController _tags = TagFieldController();
  final ImageButtonController _image = ImageButtonController();
  double _currentSliderValue = 5;

  void addIngredient(String ingredient) {
    ingredients.add(ingredient);
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: 'Name of Dish'),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildInstructionsField() {
    return TextFormField(
      controller: _directions,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(labelText: 'Directions'),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _buildSlider() {
    return Slider(
      value: _currentSliderValue,
      min: 1,
      max: 10,
      divisions: 9,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Future<void> submitRecipe(context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    final Map<String, dynamic> recipeData = {
      'name': _name.text,
      'ingredients': Ingredient.toIdString(_ingredients.list),
      'directions': _directions.text,
      'tags': _tags.list.toList(),
      'image': _image.url,
      'difficulty': _currentSliderValue.round()
    };

    print('sending ' + recipeData.toString());

    final response = await http.post(Uri.https(API.baseURL, API.createRecipe),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer ' + user.token
        },
        body: jsonEncode(recipeData));

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
  }

  Widget _buildSubmitButton(context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false)
            submitRecipe(context).then((value) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Recipe created'))));
        },
        child: Text('Submit'),
      ),
    );
  }

  Widget _buildForm(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNameField(),
            Divider(),
            IngredientField(controller: _ingredients),
            _buildInstructionsField(),
            Divider(),
            TagField(controller: _tags),
            _buildSlider(),
            ImageButton(
              controller: _image,
            ),
            _buildSubmitButton(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(child: _buildForm(context)),
    );
  }
}
