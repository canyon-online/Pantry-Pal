import 'package:client/models/Ingredient.dart';
import 'package:client/models/Recipe.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/IngredientModel.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/IngredientSelecter.dart';
import 'package:client/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  String _query = '';

  Widget _buildCenteredIndicator() {
    return Center(
        child: SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(),
    ));
  }

  Future<Map<String, dynamic>> _getRecipes(
      String token, int offset, int limit, Set<Ingredient> ingredients) {
    var response =
        API().searchFromIngredients(token, offset, limit, ingredients, _query);

    return response;
  }

  Widget _buildSearchField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Search for a dish',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      onChanged: (text) {
        setState(() {
          _query = text.trim();
        });
      },
    );
  }

  Widget _buildSliver(String token, Set<Ingredient> ingredients) {
    return FutureBuilder(
        future: _getRecipes(token, 0, 10, ingredients),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          var childCount = 0;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              childCount = 1;
              return SliverList(
                  delegate:
                      SliverChildListDelegate([_buildCenteredIndicator()]));
            default:
              if (snapshot.hasData == false)
                return SliverList(
                    delegate:
                        SliverChildListDelegate([_buildCenteredIndicator()]));
              var data = Map.from(snapshot.data!);
              var recipes = Recipe.fromJsonList(data['recipes']);
              childCount = recipes.length;
              if (recipes.length <= 0)
                return SliverList(
                    delegate: SliverChildListDelegate(
                        [Text('No recipes matched the current criteria')]));
              else
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return RecipeCard(
                      recipes[index],
                      duration: 100 * (index + 1),
                    );
                  }, childCount: childCount),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 391,
                      maxCrossAxisExtent: 500,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 30,
                      childAspectRatio: 391 / 500),
                );
          }
        });
  }

  @override
  build(BuildContext context) {
    String _token = Provider.of<UserProvider>(context).user.token;
    return Consumer<IngredientModel>(
      builder: (context, ingredients, child) =>
          CustomScrollView(shrinkWrap: true, slivers: <Widget>[
        child ??
            SliverList(
              delegate: SliverChildListDelegate([_buildCenteredIndicator()]),
            ),
        _buildSliver(_token, ingredients.ingredients)
      ]),
      child: SliverList(
          delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Text('Search by name:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchField(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Search by ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IngredientSelecter(),
          ),
        ],
      )),
    );
  }
}
