import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:receptor/tags/tags.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './recipes.model.dart';
import '../http/backend.service.dart';

class RecipesRepository extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final recipeListApiEnpoint = "api/getAllRecipes.php";

  Future<List<Recipe>> allRecipes(bool forceRefresh) async {
    var prefs = await _prefs;

    String data;
    if (!forceRefresh) {
      if (prefs.containsKey("recipes")) {
        data = prefs.getString("recipes");
      }
    }

    if (data == null) {
      try {
        final response = await BackendService().get(recipeListApiEnpoint);
        data = response.data;
        final SharedPreferences prefs = await _prefs;
        prefs.setString("recipes", data);
        notifyListeners();
      } on ServerUnreachableError catch (e) {
        if (!prefs.containsKey("recipes")) throw e;
        data = prefs.getString("recipes");
      }
    }
    final jsonResponse = jsonDecode(data) as List;
    final list = jsonResponse.map((recipe) => Recipe.fromJson(recipe)).toList();
    list.sort((r, other) => r.name.compareTo(other.name));
    return list;
  }

  Map<String, dynamic> _toJson(Recipe recipe) {
    return {
      "id": recipe.id,
      "name": recipe.name,
      "seasons": recipe.tags.map((tag) => {"name": tag, "id": null}).toList(),
      "cook_books": recipe.cookBook != null
          ? [
              {
                "id": recipe.cookBook.id,
                "name": recipe.cookBook.name,
                "page_number": recipe.cookBook.pageNumber
              }
            ]
          : []
    };
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    final recipeJson = _toJson(recipe);
    final response =
        await BackendService().post(recipeJson, "api/updateRecipe.php");
    await TagsRepository().getAllTags(true);
    await allRecipes(true);
    return Recipe.fromJson(jsonDecode(response.data));
  }

  Future deleteRecipe(Recipe recipe) async {
    await BackendService().delete(_toJson(recipe), "api/deleteRecipe.php");
    await allRecipes(true);
  }
}
