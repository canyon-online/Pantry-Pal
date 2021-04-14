import 'Ingredient.dart';

class Recipe {
  final String recipeId;
  final String author;
  final String authorId;
  final String name;
  final List<Ingredient> ingredients;
  final String directions;
  final List<String> tags;
  final String image;
  final int serves;
  bool isLiked;
  int favorites;
  int hits;

  Recipe(
      {this.recipeId = '',
      this.name = '',
      this.author = '',
      this.authorId = '',
      this.directions = '',
      this.ingredients = const <Ingredient>[],
      this.favorites = 0,
      this.serves = 1,
      this.hits = 0,
      this.isLiked = false,
      this.image = '/images/4bade9c7fb6df087d927e753f77ae354da950f3e.png',
      this.tags = const <String>[]});

  factory Recipe.fromJson(Map<String, dynamic> data) {
    return Recipe.fromMap(data);
  }

  factory Recipe.fromMap(Map<String, dynamic> data) {
    // print(data);
    return Recipe(
      recipeId: data['_id'] ?? '',
      name: data['name'] ?? 'Unknown',
      author: data['author']['display'] ?? 'Unknown',
      authorId: data['author']['_id'] ?? '',
      directions: data['directions'] ?? '',
      favorites: data['numFavorites'] ?? 0,
      hits: data['numHits'] ?? 0,
      image: data['image'] ?? '',
      isLiked: data['isLiked'] ?? false,
      ingredients: data['ingredients']
              .map<Ingredient>((item) => Ingredient.fromJson(item))
              .toList() ??
          [],
      tags: data['tags'].map<String>((item) => item.toString()).toList() ?? [],
      serves: data['serves'] ?? 0,
    );
  }

  factory Recipe.defaultRecipe() {
    return Recipe(
      recipeId: 'myrecipeidhere123',
      name: 'Soy Sauce Garlic Butter Noodles',
      author: 'super_amazing_cook12',
      directions: 'cook it',
      favorites: 1230,
      serves: 2,
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

  bool operator ==(Object other) =>
      other is Recipe && other.recipeId == recipeId;

  @override
  int get hashCode => recipeId.hashCode;

  @override
  String toString() => recipeId;
}
