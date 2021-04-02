import 'package:client/models/Recipe.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/LikeButton.dart';
import 'package:client/widgets/RecipeModal.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  const RecipeCard(this.recipe);

  @override
  RecipeCardState createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  late Recipe _recipe;

  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Widget _drawCardBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeLikeButton(recipe: _recipe),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.touch_app, color: Colors.grey, size: 30),
                Text(_recipe.hits.round().toString()),
              ],
            )
          ],
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.generate(_recipe.tags.length,
                (int index) => TextPill(_recipe.tags[index])))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<UserProvider>(context).user.token;

    void _tapCounter(String token, String recipeId) async {
      var response = await API().doClickRecipe(token, recipeId);
      Recipe newRecipe = Recipe.fromJson(response);
      setState(() {
        _recipe = newRecipe;
        print(_recipe.hits);
      });
    }

    return Card(
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    _tapCounter(token, _recipe.recipeId);
                    return RecipeModal(recipe: _recipe);
                  });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 500,
                  height: 194,
                  child: FittedBox(
                    clipBehavior: Clip.hardEdge,
                    child:
                        Image.network('https://' + API.baseURL + _recipe.image),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Divider(height: 20, thickness: 2),
                      Text(
                        _recipe.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(_recipe.author,
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 15),
                      _drawCardBody(),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            )));
  }
}
