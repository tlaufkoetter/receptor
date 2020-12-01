class Season {
  final int id;
  final String name;
  Season({this.id, this.name});
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(id: json['id'], name: json['name']);
  }
}

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

class Recipe {
  final int id;
  String name;
  List<String> tags;
  final CookBook cookBook;
  Recipe({this.id, this.name, this.tags, this.cookBook});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        name: json['name'],
        tags: json['season'] != null
            ? [Season.fromJson(json['season']).name]
            : [],
        cookBook: json['cook_book'] != null
            ? CookBook.fromJson(json['cook_book'])
            : null);
  }
}
