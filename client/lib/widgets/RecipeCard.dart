import 'package:client/models/Recipe.dart';
import 'package:client/utils/API.dart';
import 'package:client/widgets/LikeButton.dart';
import 'package:client/widgets/RecipeModal.dart';
import 'package:client/widgets/TextPill.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  const RecipeCard(this.recipe);

  @override
  RecipeCardState createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  Widget _drawCardBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeLikeButton(recipe: widget.recipe),
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
                (int index) => TextPill(widget.recipe.tags[index])))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RecipeModal(recipe: widget.recipe);
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
                    // child: widget.recipe.image,
                    child: Image.network(
                        'https://' + API.baseURL + widget.recipe.image),
                    fit: BoxFit.fill,
                  ),
                ),
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
