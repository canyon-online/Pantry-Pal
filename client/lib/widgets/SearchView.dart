import 'package:client/models/Ingredient.dart';
import 'package:client/models/Recipe.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/IngredientModel.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/IngredientSelecter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  List<Widget> _getRecipes(
      String token, int offset, int limit, Set<Ingredient> ingredients) {
    var response =
        API().searchFromIngredients(token, offset, limit, ingredients);
    return [];
  }

  @override
  build(BuildContext context) {
    String _token = Provider.of<UserProvider>(context).user.token;
    return Consumer<IngredientModel>(
        builder: (context, ingredients, child) => Column(
              children: [
                // Use the child here, without rebuilding everytime.
                child ??
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.red),
                      ),
                    ),

                Column(
                    children:
                        _getRecipes(_token, 0, 10, ingredients.ingredients))
              ],
            ),
        // Build the expensive widget here.
        child: IngredientSelecter());
  }
}
