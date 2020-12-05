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
    return Recipe(
        id: json['id'],
        name: json['name'],
        tags: seasons,
        cookBook: cookBooks.isNotEmpty ? cookBooks.first : null);
  }
}
