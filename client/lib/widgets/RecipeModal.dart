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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.recipe.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              )),
          Divider(),
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
          SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: Scrollbar(
              child: ListView(children: [
                Text(
                  widget.recipe.directions,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ]),
            ),
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
