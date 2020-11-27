import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './recipes.model.dart';
import '../http/backend.service.dart';

class RecipesRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final recipeListApiEnpoint = "getRecipes.php";

  Future<List<Recipe>> allRecipes() async {
    var prefs = await _prefs;

    String data;
    try {
      final response = await BackendService().get(recipeListApiEnpoint);
      data = response.data;
      final SharedPreferences prefs = await _prefs;
      prefs.setString("recipes", data);
    } on ServerUnreachableError catch (e) {
      if (!prefs.containsKey("recipes")) throw e;
      data = prefs.getString("recipes");
    }
    final jsonResponse = jsonDecode(data) as List;
    return jsonResponse.map((recipe) => new Recipe.fromJson(recipe)).toList();
  }
}
