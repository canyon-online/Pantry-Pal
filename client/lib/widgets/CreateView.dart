import 'package:client/models/Ingredient.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/ImageButton.dart';
import 'package:client/widgets/IngredientField.dart';
import 'package:client/widgets/TagField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      maxLength: 32,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: 'Dish Name',
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
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
      maxLength: 2000,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration(
          labelText: 'Directions',
          alignLabelWithHint: true,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
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
      divisions: 10,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Widget _buildSubmitButton(context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          String token =
              Provider.of<UserProvider>(context, listen: false).user.token;

          final Map<String, dynamic> recipe = {
            'name': _name.text,
            'ingredients': Ingredient.toIdString(_ingredients.list),
            'directions': _directions.text,
            'tags': _tags.list.toList(),
            'image': _image.url,
            'difficulty': _currentSliderValue.round()
          };

          if (_formKey.currentState?.validate() ?? false)
            API().submitRecipe(token, recipe).then((value) =>
                ScaffoldMessenger.of(context)
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
            TagField(controller: _tags),
            Text('Difficulty:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSlider(),
            SizedBox(height: 16),
            Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
            ImageButton(
              controller: _image,
            ),
            Divider(),
            Align(
                alignment: Alignment.bottomRight,
                child: _buildSubmitButton(context))
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
