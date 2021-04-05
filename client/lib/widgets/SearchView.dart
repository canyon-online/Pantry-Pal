import 'package:client/models/Ingredient.dart';
import 'package:client/models/Recipe.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/IngredientModel.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/IngredientSelecter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RecipeCard.dart';

class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _search.addListener(() {
      setState(() {
        _query = _search.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getRecipes(
      String token, int offset, int limit, Set<Ingredient> ingredients) {
    var response =
        API().searchFromIngredients(token, offset, limit, ingredients, _query);

    return response;
  }

  Widget _buildScrollview(List<Recipe> recipes) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(30, 15, 15, 30),
      // controller: controller,
      shrinkWrap: true,
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipes[index]);
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 391,
          maxCrossAxisExtent: 500,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          childAspectRatio: 391 / 500),
    );
  }

  Widget _buildFuture(String _token, Set<Ingredient> ingredients) {
    return FutureBuilder(
      future: _getRecipes(_token, 0, 10, ingredients),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              var data = Map.from(snapshot.data!);
              var recipes = Recipe.fromJsonList(data['recipes']);
              if (recipes.length <= 0)
                return Text('No recipes matched the current criteria');
              else
                return Expanded(child: _buildScrollview(recipes));
            }
        }
      },
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _search,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Search for a recipe',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
    );
  }

  @override
  build(BuildContext context) {
    String _token = Provider.of<UserProvider>(context).user.token;
    return Consumer<IngredientModel>(
        builder: (context, ingredients, child) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                // Use the child here, without rebuilding everytime.
                child ?? Text('No child found.'),
                _buildFuture(_token, ingredients.ingredients)
              ],
            ),
        // Build the expensive widget here.
        child: Column(
          children: [
            _buildSearchField(),
            IngredientSelecter(),
          ],
        ));
  }
}
