// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rezepte',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

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
  final String name;
  final Season season;
  final CookBook cookBook;
  Recipe({this.id, this.name, this.season, this.cookBook});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        name: json['name'],
        season: json['season'] != null ? Season.fromJson(json['season']) : null,
        cookBook: json['cook_book'] != null
            ? CookBook.fromJson(json['cook_book'])
            : null);
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _biggerFont = TextStyle(fontSize: 18);

  Future<List<Recipe>> _fetchRecipes() async {
    final recipeListApiUrl = "http://192.168.178.27:5556/getRecipes.php";
    final response = await http.get(recipeListApiUrl);

    if (response.statusCode == 200) {
      final List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((recipe) => new Recipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Rezepte")),
        body: FutureBuilder<List<Recipe>>(
          future: _fetchRecipes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Recipe> data = snapshot.data;
              return _buildSuggestions(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Rezepte"),
    //     ),
    //     body: _buildSuggestions());
  }

  Widget _buildSuggestions(List<Recipe> recipes) {
    recipes.sort((recipe1, recipe2) => recipe1.name.compareTo(recipe2.name));
    return Scrollbar(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: recipes.length,
            separatorBuilder: (BuildContext context, int i) => Divider(
                  height: 2,
                  color: Colors.blue,
                ),
            itemBuilder: (context, i) {
              return _buildRow(recipes[i]);
            }));
  }

  Widget _buildRow(Recipe recipe) {
    String subtitle = "";
    final hasSeason = recipe.season != null;
    if (hasSeason) {
      subtitle += recipe.season.name;
    }

    if (recipe.cookBook != null) {
      if (hasSeason) {
        subtitle += " - ";
      }
      subtitle += recipe.cookBook.name;
      if (recipe.cookBook.pageNumber != null) {
        subtitle += " (S. ${recipe.cookBook.pageNumber})";
      }
    }
    return ListTile(
        title: Text(recipe.name, style: _biggerFont),
        subtitle: Text(subtitle),
        dense: true);
  }
}
