import 'package:receptor/tags/tag.model.dart';

class CookBook {
  final int id;
  final String name;
  final int pageNumber;
  CookBook({this.id, this.name, this.pageNumber});
  factory CookBook.fromJson(Map<String, dynamic> json) {
    return CookBook(
        id: json['id'], name: json['name'], pageNumber: json['page_number']);
  }
}

enum QuantityType { none, piece, gramm, milliliter }

class Ingredient {
  final int id;
  final String name;
  final double amount;
  final QuantityType quantityType;
  Ingredient({this.id, this.name, this.amount, this.quantityType});
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        quantityType: QuantityType.values.firstWhere(
            (qt) => qt == json['quantity-type'],
            orElse: () => QuantityType.none));
  }
}

class Recipe {
  final int id;
  String name;
  List<String> tags;
  List<Ingredient> ingredients;
  final CookBook cookBook;
  Recipe({this.id, this.name, this.tags, this.cookBook, this.ingredients});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> seasons = [];
    if (json['seasons'] != null) {
      for (final season in json['seasons']) {
        var frseason = Season.fromJson(season);
        seasons.add(frseason.name);
      }
    }
    List<CookBook> cookBooks = [];
    if (json['cook_books'] != null) {
      for (final cook_book in json['cook_books']) {
        var frcookbook = CookBook.fromJson(cook_book);
        cookBooks.add(frcookbook);
      }
    }
    List<Ingredient> ingredients = [];
    if (json['ingredients'] != null) {
      for (final ingredient in json['ingredients']) {
        var fringredient = Ingredient.fromJson(ingredient);
        ingredients.add(fringredient);
      }
    }

    return Recipe(
        id: json['id'],
        name: json['name'],
        tags: seasons,
        cookBook: cookBooks.isNotEmpty ? cookBooks.first : null,
        ingredients: ingredients);
  }
}
