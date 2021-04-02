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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _directions = TextEditingController();
  final IngredientFieldController _ingredients = IngredientFieldController();
  final TagFieldController _tags = TagFieldController();
  final ImageButtonController _image = ImageButtonController();
  double _currentSliderValue = 5;

  Widget _buildNameField() {
    return TextFormField(
      controller: _name,
      maxLength: 32,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value?.isEmpty ?? false) return 'Please enter a dish name';
        return null;
      },
    );
  }

  Widget _buildInstructionsField() {
    return TextFormField(
      controller: _directions,
      maxLength: 5000,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value?.isEmpty ?? false)
          return 'Please enter the recipe directions';

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
            // 'ingredients': Ingredient.toIdString(_ingredients.list),
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
            Text('Dish Name:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildNameField(),
            Text('Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            IngredientField(controller: _ingredients),
            Text('Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildInstructionsField(),
            Text('Tags:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TagField(controller: _tags),
            Text('Difficulty:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildSlider(),
            Text('Image:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ImageButton(
              controller: _image,
            ),
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
