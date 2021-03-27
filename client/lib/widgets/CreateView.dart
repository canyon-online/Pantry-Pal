import 'package:client/widgets/IngredientField.dart';
import 'package:flutter/material.dart';

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

  Widget _buildIngredientField() {
    return IngredientField(controller: _ingredients);
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
    return Expanded(
      child: Slider(
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          var validated = _formKey.currentState?.validate() ?? false;
          if (validated) {
            // FETCH VALUES FROM FIELDS
            print(_name.text);
            print(_directions.text);
            print(_ingredients.list);
            print(_currentSliderValue);
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        },
        child: Text('Submit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNameField(),
            _buildIngredientField(),
            _buildInstructionsField(),
            _buildSlider(),
            _buildSubmitButton()
          ],
        ),
      ),
    );
  }
}
