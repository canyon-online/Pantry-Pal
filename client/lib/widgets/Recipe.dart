import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class Recipe {
  String recipeId;
  String author;
  String name;
  // List<Ingredient> ingredients;
  String directions;
  List<String> tags;
  Image image;
  int favorites;
  int hits;
  int difficulty;

  Recipe(
      {required this.recipeId,
      required this.name,
      required this.author,
      required this.directions,
      required this.favorites,
      required this.difficulty,
      required this.hits,
      required this.image,
      required this.tags});

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      recipeId: data['recipeId'] ?? 'NULL',
      name: data['name'] ?? 'NULL',
      author: data['author'] ?? 'NULL',
      directions: data['directions'] ?? 'NULL',
      favorites: data['favorites'] ?? 0,
      image: data['image'] ??
          Image(
              image: AssetImage('assets/images/noodles.jpg'),
              fit: BoxFit.fitWidth),
      tags: data['tags'] ?? [],
      difficulty: data['difficulty'] ?? 0,
      hits: data['hits'] ?? 0,
    );
  }

  factory Recipe.defaultRecipe() {
    return Recipe(
      recipeId: 'myrecipeidhere123',
      name: 'Soy Sauce Garlic Butter Noodles',
      author: 'super_amazing_cook12',
      directions: 'cook it',
      image: Image(
          image: AssetImage('assets/images/noodles.jpg'), fit: BoxFit.fitWidth),
      favorites: 1230,
      difficulty: 2,
      tags: ['Vegetarian', '🥡'],
      hits: 12304,
    );
  }
}

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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(widget.recipe.author,
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              LikeButton(
                                  size: 30,
                                  likeCountAnimationDuration:
                                      Duration(milliseconds: 200),
                                  onTap: (value) {
                                    // favorited = !favorited;
                                    return Future.value(!value);
                                  },
                                  likeCount: widget.recipe.favorites,
                                  countBuilder:
                                      (count, bool isLiked, String text) {
                                    var color =
                                        isLiked ? Colors.pink : Colors.grey;
                                    return count == 0
                                        ? Text('love',
                                            style: TextStyle(color: color))
                                        : Text(text);
                                  }),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.touch_app,
                                      color: Colors.grey, size: 30),
                                  Text(widget.recipe.hits.round().toString()),
                                ],
                              )
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List<Widget>.generate(
                                  widget.recipe.tags.length,
                                  (int index) => IngredientPill(
                                      widget.recipe.tags[index])))
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            )));
  }
}
