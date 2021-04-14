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
  bool _removed = false;

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RecipeLikeButton(recipe: _recipe),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.visibility, color: Colors.grey, size: 30),
                SizedBox(width: 3),
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

    Future<bool> _tapCounter(String token, String recipeId) async {
      var response = await API().doClickRecipe(token, recipeId);

      if (response['code'] != 200) {
        setState(() {
          _removed = true;
        });
        return false;
      } else {
        setState(() {
          _recipe = Recipe.fromJson(response);
        });
        return true;
      }
    }

    FutureBuilder _buildDialog(String token, String recipeId) {
      return FutureBuilder(
        future: _tapCounter(token, recipeId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return SizedBox();
            default:
              if (snapshot.hasError)
                return Text('Error ${snapshot.error}');
              else if (snapshot.data == true)
                return RecipeModal(recipe: _recipe);
              else
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('This recipe does not exist'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                        child: Text('Okay'))
                  ],
                );
          }
        },
      );
    }

    Widget _buildCard() {
      return Card(
          child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildDialog(token, _recipe.recipeId);
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
                      child: Image.network(
                          'https://${API.baseURL}${_recipe.image}'),
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

    return _removed == false ? _buildCard() : SizedBox();
  }
}
