import 'package:flutter/material.dart';

class Recipe {
  String recipeId;
  String author;
  // List<Ingredient> ingredients;
  String directions;
  // List<Tags> tags;
  // AssetImage
  int favorites;
  int hits;
  int difficulty;

  Recipe(
      {required this.recipeId,
      required this.author,
      required this.directions,
      required this.favorites,
      required this.difficulty,
      required this.hits});

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      recipeId: data['recipeId'] ?? 'NULL',
      author: data['author'] ?? 'NULL',
      directions: data['directions'] ?? 'NULL',
      favorites: data['favorites'] ?? 0,
      difficulty: data['difficulty'] ?? 0,
      hits: data['hits'] ?? 0,
    );
  }

  factory Recipe.defaultRecipe() {
    return Recipe(
      recipeId: 'Soy Sauce Garlic Butter Noodles',
      author: 'Mike',
      directions: 'cook it',
      favorites: 1230,
      difficulty: 2,
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

class RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
          child: InkWell(
              onTap: () {
                print('Card tapped');
              },
              child: SizedBox(
                width: 300,
                height: 100,
                child: Text('A card that can be tapped'),
              ))),
    );
  }
}
