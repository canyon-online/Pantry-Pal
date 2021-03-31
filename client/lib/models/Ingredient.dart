class Ingredient {
  final String id;
  final String name;

  Ingredient({this.id = 'none', this.name = 'none'});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id'],
      name: json['name'],
    );
  }

  static List<Ingredient> fromJsonList(List list) {
    return list.map((item) => Ingredient.fromJson(item)).toList();
  }

  static List<String> toIdString(Set<Ingredient> list) {
    return list.map((item) => item.id).toList();
  }

  String ingredientAsString() {
    return '#${this.id} ${this.name}';
  }

  @override
  String toString() => name;

  bool operator ==(Object other) => other is Ingredient && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
