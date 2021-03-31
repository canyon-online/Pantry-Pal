import 'package:client/models/Recipe.dart';
import 'package:client/widgets/LikeButton.dart';
import 'package:flutter/material.dart';

class RecipeModal extends StatefulWidget {
  final Recipe recipe;
  RecipeModal({required this.recipe});

  @override
  RecipeModalState createState() => RecipeModalState();
}

class RecipeModalState extends State<RecipeModal> {
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

          Divider(),

          // This row if for aligning the heart and click icons.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

          // Vertical spacing in the column
          SizedBox(height: 10),

          // This constrained box maes it so the listview doesn't take up unlimited
          // vertical height. Max height can be calculated to be some percent of
          // the screen.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            // Add a scroll bar to the listview.
            child: Scrollbar(
              child: ListView(children: [
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
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text('Close'),
            ),
          ),
        ]),
      ),
    );
  }
}
