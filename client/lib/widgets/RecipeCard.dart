import 'package:client/models/Recipe.dart';
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
                (int index) => TextPill(widget.recipe.tags[index])))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {
              print('Card tapped');
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 350),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                    text:
                                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.black,
                                        wordSpacing: 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
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
