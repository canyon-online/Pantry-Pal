import 'package:flutter/material.dart';

class Recipe {
  final String recipeId;
  final String author;
  final String name;
  // List<Ingredient> ingredients;
  final String directions;
  final List<String> tags;
  final Image image;
  final int difficulty;
  int favorites;
  int hits;

  Recipe(
      {this.recipeId = 'none',
      this.name = 'New Dish',
      this.author = 'Pantry Pal',
      this.directions = 'There are no directions.',
      this.favorites = 0,
      this.difficulty = 1,
      this.hits = 0,
      this.image = const Image(
          image: AssetImage('assets/images/noodles.jpg'), fit: BoxFit.fitWidth),
      this.tags = const <String>[]});

  factory Recipe.fromJson(Map<String, dynamic> data) {
    return Recipe.fromMap(data);
  }

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      recipeId: data['_id'],
      name: data['name'],
      author: data['author']['display'],
      directions: data['directions'],
      favorites: data['numFavorites'],
      hits: data['numHits'],
      // image: data['image'],
      tags: data['tags'].map<String>((item) => item.toString()).toList(),
      difficulty: data['difficulty'],
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

  static List<Recipe> fromJsonList(List list) {
    return list.map((item) => Recipe.fromJson(item)).toList();
  }

  String recipeAsString() {
    return '#${this.recipeId} ${this.name}';
  }

  bool isEqual(Recipe model) {
    return this.recipeId == model.recipeId;
  }

  @override
  String toString() => recipeId;
}
