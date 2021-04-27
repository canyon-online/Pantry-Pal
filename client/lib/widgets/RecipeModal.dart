import 'package:pantrypal/models/Recipe.dart';
import 'package:pantrypal/models/User.dart';
import 'package:pantrypal/utils/API.dart';
import 'package:pantrypal/utils/UserProvider.dart';
import 'package:pantrypal/widgets/LikeButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TextPill.dart';

class RecipeModal extends StatefulWidget {
  final Recipe recipe;
  RecipeModal({required this.recipe});

  @override
  RecipeModalState createState() => RecipeModalState();
}

class RecipeModalState extends State<RecipeModal> {
  Widget _deleteButton(context) {
    User user = Provider.of<UserProvider>(context).user;
    if (user.userId.compareTo(widget.recipe.authorId) == 0)
      return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Delete Recipe'),
                    content:
                        Text('Are you sure you want to delete this recipe?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                        child: Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          API()
                              .removeRecipe(user.token, widget.recipe.recipeId);

                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Recipe deleted')));
                        },
                        child: Text('Yes'),
                      )
                    ],
                  ));
        },
        child: Icon(Icons.delete),
      );
    else
      return SizedBox(width: 10, height: 10);
  }

  @override
  Widget build(BuildContext context) {
    // Dialog acts sort of like a container
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // The padding class just gives the outer padding so these elements aren't
      // touching the corners from Left, Top, Right, Bottom (LTRB).
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),

        // In the column I set the MainAxisSize to min as to make the modal take up
        // the least amount of vertical space as possible.
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // The first few children are stacic in terms of movement in the modal.
          Text(widget.recipe.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              )),

          Text('A recipe by ${widget.recipe.author}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              )),

          Divider(),

          // This row if for aligning the heart and click icons.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RecipeLikeButton(recipe: widget.recipe),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.visibility, color: Colors.grey, size: 30),
                  SizedBox(width: 3),
                  Text(widget.recipe.hits.round().toString()),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.grey, size: 30),
                  Text(widget.recipe.serves == 10
                      ? '10+'
                      : widget.recipe.serves.toString()),
                ],
              ),
            ],
          ),

          SizedBox(height: 10),

          Wrap(
            // TAGS
            spacing: 10,
            children: widget.recipe.tags
                .map(
                  (item) => TextPill(item, size: 12),
                )
                .toList(),
          ),

          SizedBox(height: 10),

          // This constrained box maes it so the listview doesn't take up unlimited
          // vertical height. Max height can be calculated to be some percent of
          // the screen.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            // Add a scroll bar to the listview.
            child: Scrollbar(
              child: ListView(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ingredients: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5),
                Wrap(
                  // INGREDIENTS
                  spacing: 10,
                  children: widget.recipe.ingredients
                      .map(
                        (item) => TextPill(item.name, size: 12),
                      )
                      .toList(),
                ),
                Divider(),
                // The only child will be the text since it might become long.
                Text(
                  widget.recipe.directions,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ]),
            ),
          ),

          // The rest of this stuff stays static as well.
          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _deleteButton(context),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: Text('Close'),
              )
            ],
          )
        ]),
      ),
    );
  }
}
