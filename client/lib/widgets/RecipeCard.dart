import 'package:client/models/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  const RecipeCard(this.recipe);

  @override
  RecipeCardState createState() => RecipeCardState();
}

class IngredientPill extends StatelessWidget {
  final String ingredient;
  const IngredientPill(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Text(
            ingredient,
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
    );
  }
}

class RecipeCardState extends State<RecipeCard> {
  Widget _drawCardBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            LikeButton(
                size: 30,
                likeCountAnimationDuration: Duration(milliseconds: 200),
                onTap: (value) {
                  // favorited = !favorited;
                  return Future.value(!value);
                },
                likeCount: widget.recipe.favorites,
                countBuilder: (count, bool isLiked, String text) {
                  var color = isLiked ? Colors.pink : Colors.grey;
                  return count == 0
                      ? Text('love', style: TextStyle(color: color))
                      : Text(text);
                }),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.touch_app, color: Colors.grey, size: 30),
                Text(widget.recipe.hits.round().toString()),
              ],
            )
          ],
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.generate(widget.recipe.tags.length,
                (int index) => IngredientPill(widget.recipe.tags[index])))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {
              print('Card tapped');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.recipe.image,
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Divider(height: 20, thickness: 2),
                      Text(
                        widget.recipe.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(widget.recipe.author,
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
