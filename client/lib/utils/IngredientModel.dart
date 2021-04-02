import 'package:client/models/Ingredient.dart';
import 'package:flutter/cupertino.dart';

class IngredientModel extends ChangeNotifier {
  final Set<Ingredient> _ingredients = {};

  /// An unmodifiable view of the items in the cart.
  Set<Ingredient> get ingredients => _ingredients;

  void add(Ingredient ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void removeAll() {
    _ingredients.clear();
    notifyListeners();
  }

  void remove(Ingredient ingredient) {
    _ingredients.remove(ingredient);
    notifyListeners();
  }
}
