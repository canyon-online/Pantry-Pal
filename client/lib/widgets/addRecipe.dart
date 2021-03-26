import 'package:flutter/material.dart';

// Creates the form widget for adding a recipe
class AddRecipeForm extends StatefulWidget {
  @override
  AddRecipeFormState createState() {
    return AddRecipeFormState();
  }
}

// Creates a state class relating to the addRecipeForm widget
class AddRecipeFormState extends State<AddRecipeForm>{
  // Create global key uniquely to this form widget
  //    (allows verification of form)
  final _formKey = GlobalKey<AddRecipeFormState>();

  // Ingredient list & get, add, remove, and console print fxns
  List<String> ingredients = ['carrot','second carrot','something else'];
  List<String> getIngredients(){return ingredients;}
  void addIngredient(String ingredient){ingredients.add(ingredient);}
  void removeIngredient(String ingredient){ingredients.remove(ingredient);}
  void conPrintIngredients(){print(ingredients);}

  // Difficulty & get, getInt, set, and console print fzns
  double difficulty = 5;
  void setDifficulty(_difficulty){difficulty = _difficulty;conPrintDiff();}
  double getDifficulty(){return difficulty;}
  int getIntDifficulty(){return difficulty.round();}
  void conPrintDiff(){print(getDifficulty().toString());}

  callback(newDifficulty) {
    setState(() {
      difficulty = newDifficulty;
    });
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
              // Dish Name Field
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Name of Dish'
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              // Ingredient Adding Field
              TextFormField(
                decoration: InputDecoration(
                  // Add button for ingredients
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => {
                      addIngredient('test')
                    },
                  ),
                  labelText: 'Add an Ingredient',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              // Directions
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Directions'
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              // Difficulty Slider
              Expanded(
                child: DifficultySlider(),
              ),
              // Submit button
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    //if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    setDifficulty(_DifficultySlider().getSliderValue());
                    print(getDifficulty().toString());
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
        ),
      ),
    );
  }

}




// Difficulty Slider class
class DifficultySlider extends StatefulWidget {
  const DifficultySlider({Key? key}) : super(key: key);

  @override
  _DifficultySlider createState() => _DifficultySlider();
}
// Private helper class for slider
class _DifficultySlider extends State<DifficultySlider> {
  // Difficulty and slider get function
  double _difficulty = 5;
  double getSliderValue(){return _difficulty;}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: _difficulty,
      min: 1,
      max: 10,
      divisions: 9,
      label: _difficulty.round().toString(),
      onChanged: (double value) {
        setState(() {
          _difficulty = value;
          AddRecipeFormState().setDifficulty(value);
        });
      },
    );
  }
}

